# Contemplation: Honest Audit — Waza, and Three Trees I Might Be Barking Up Wrong

**Timestamp**: May 2026
**Trigger**: Started playing with Microsoft Waza for skill-composition evaluation; questioning whether it's a tangent or a missing piece.

## On Waza Specifically

**What it is** (verified, not inferred): `microsoft/waza` — a Go-native single-binary CLI that scaffolds skills, defines evaluation specs in YAML, runs agentic test loops against real LLMs, grades with ~11 validator types (text, regex, code, JSON Schema, LLM-as-judge, behavioral, tool-invocation), benchmarks across models, and ships a local dashboard + GitHub Actions integration. Same SKILL.md shape I already use.

**Honest read**: this is *not* a tangent. It fills a real, named hole in my current stack.

Current state of my skills work:
- I author skills (Copilot Skills, audit-ai-inf, etc.)
- I govern skills (allowlists, audit trails — the governance pondering)
- I **don't** systematically evaluate skills. Regression is "did it feel right when I last ran it."

Waza is the evaluation layer. Without it, my tier system (claw / workflow / bot from the previous pondering) is unenforceable — I have no way to prove a workflow *stays* a workflow under model upgrades, or that a claw's output quality hasn't drifted.

**But the timing question is fair.** Two reasons to *not* go deep on Waza right now:

1. **Tier classification has to come first.** Evaluating skills before I've sorted them into claws/workflows/bots means writing the wrong evals. A claw needs an output-quality eval; a workflow needs gate-check evals; a bot needs trajectory/budget evals. Different shapes entirely.
2. **Adoption cost is non-trivial.** Go binary, YAML DSL, another dashboard to maintain, another CI surface. If I'm the only consumer right now, the leverage doesn't justify it yet.

**Recommendation to self**: don't commit to Waza as primary infrastructure. *Do* keep a sandbox repo with 2–3 representative skills under Waza eval as a "scout" — enough to know if it scales when I'm ready. Revisit when (a) tier classification is done on real skills, and (b) at least one other person on the team would consume the eval results. Until both are true, it's a research thread, not infrastructure.

This is a Tier-2 tool decision (per my own framing): worth knowing, not worth standardizing on yet. Park in `decisions/` as a "not yet, here's the trigger" entry rather than letting it become an active migration.

---

## Three Trees I Suspect I'm Barking Up Wrong

These are uncomfortable on purpose. Filing them so I can't pretend I didn't notice.

### 1. "Tool-agnostic, portable skills across 6 platforms"

From `AI_Platform_Focus.md`: *"Tool-agnostic skill design (portable across platforms)."* The audit-ai-inf skill covering 6 platforms is the proud artifact.

**The doubt**: platforms are diverging *faster* than they're converging. Anthropic Skills, GitHub Copilot Skills, OpenAI's tool-use shape, Google's Gemini extensions, Cursor's rules, Cline's MCP — these all *look* alike at the SKILL.md level and are subtly incompatible at the execution-semantics level (tool-call schema, context window strategy, file system access model, approval flow). Portability is becoming a tax I pay in lowest-common-denominator design.

**The honest version**: I picked Copilot CLI as primary (correct call). The portability work makes sense as a *survey / audit* function (audit-ai-inf is genuinely useful as a comparative tool). It makes much less sense as a design constraint on *new* skills I'm authoring. Most of my new skills should be Copilot-CLI-native and use the platform's full capability surface; cross-platform versions are a porting exercise, not a primary requirement.

**Action**: stop treating "works on all 6 platforms" as a quality bar for new skills. Treat it as a deliberate, opt-in feature for skills where reach actually matters.

### 2. PowerShell-first for everything agent-adjacent

From the learning path and Copilot CLI decision: PowerShell is the primary skill-authoring language.

**The doubt**: PowerShell is excellent for Windows-shop infra glue (its actual job), and fine for skill *bundled scripts*. It is a *poor fit* for the agent eval / orchestration / framework layer, which is overwhelmingly Python (PydanticAI, CrewAI, LangGraph) and TypeScript (Copilot SDK, Vercel AI SDK, MCP TS clients). Waza is Go. Anthropic's cookbook is Python. Every credible eval framework I'd reach for is Python or TS.

If I stay PowerShell-only for the agent stack, I'm cutting myself off from the ecosystem where the actual work is happening.

**The honest version**: keep PowerShell as the *script tier* (bundled scripts inside Skills, Windows infra automation, generators). Add **Python as the framework tier** (eval harnesses, agent orchestration prototypes, MCP servers when I write them). TypeScript only when I touch Copilot SDK directly. This isn't abandoning the PowerShell investment; it's recognizing it has a ceiling for this domain.

**Action**: next non-trivial agent prototype gets written in Python with PydanticAI or the Claude Agent SDK, *not* PowerShell. Treat it as a forcing function.

### 3. "Governance" as the primary lens on agent safety

From `AI_Agent_Governance.md` and the audit-ai-inf work: the framing is allowlists, policies, audit trails, OWASP-style controls.

**The doubt**: governance is a defensive posture. It catches bad outputs *after* the system is built. The teams I see shipping safe agents fastest aren't doing it through better guardrails — they're doing it through better **evals**. An eval suite that catches regressions across model upgrades is worth more than a policy file, because it tells you *whether the system actually works* rather than *whether it stayed inside a fence*.

Governance and eval are complements, not substitutes — but I've been treating governance as primary and eval as a "someday" item. That's backwards for an applied AI practitioner. The Anthropic post implicitly makes the same point: every workflow pattern they describe assumes you have an eval loop telling you whether the workflow is doing its job.

**The honest version**: my governance work is good and should continue. But the *next* major investment should be eval infrastructure (which is what made Waza catch my eye in the first place — instinct was right, framing was off). Reframe: I'm not exploring Waza because skill composition is interesting; I'm exploring it because I've been under-investing in eval and my gut knows it.

**Action**: add `evaluation` as a peer category to `governance` in audit-ai-inf and in the learning path. Stop asking "is this skill safe?" without also asking "is this skill correct, and how would I know if it stopped being correct?"

---

## Where I'm Definitely *Not* Barking Up the Wrong Tree

For balance — these calls hold up under the same scrutiny:

- **Copilot CLI as primary platform**: still correct; the Skills framework is the most mature team-shareable surface, and the rationale in `AI_Platform_Focus.md` survives this review.
- **Infrastructure as craft over management-track abstraction**: confirmed by the Anthropic post's whole thesis (favor composable primitives you understand end-to-end).
- **Markdown-first knowledge capture in this repo**: friction-free, AI-readable, version-controlled. Exactly the right substrate.
- **Reflection cadence as a forcing function**: weekly/monthly/quarterly generators are why I caught these three issues in the first place. The system is working.

---

## Summary

| Tree | Status | Next move |
|---|---|---|
| Waza | Right instinct, wrong timing | Sandbox scout, not infrastructure. Revisit when tier-classification is done. |
| Cross-platform portable skills | Over-invested as a design constraint | Demote to opt-in feature; Copilot-CLI-native by default. |
| PowerShell-only agent stack | Ceiling reached | Add Python for framework tier; PowerShell stays for scripts/infra. |
| Governance-primary framing | Defensive bias | Promote evaluation to peer status; under-investment is real. |

---

*Related: `ponderings/Workflows_vs_Agents_Bots_and_Claws.md`, `ponderings/AI_Agent_Governance.md`, `decisions/AI_Platform_Focus.md`, `contemplations/Infrastructure_as_Craft.md`*

*Convert the "evaluation as peer to governance" thread into a formal decision once I've run Waza on 2–3 real skills and have data, not opinion.*
