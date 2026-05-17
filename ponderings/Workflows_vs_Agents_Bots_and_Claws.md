# Pondering: Workflows vs. Agents — "Bots and Claws" as a Design Discipline

**Status**: Exploring
**Started**: May 2026
**Trigger**: Re-reading Anthropic's *Building Effective Agents* (Schluntz & Zhang) against my own work on audit-ai-inf and Copilot Skills.

## The Frame I'm Adopting

Anthropic draws a sharper line than most of the industry does:

- **Workflows** = LLMs + tools orchestrated through *predefined code paths*. Predictable, auditable, cheap.
- **Agents** = LLMs *dynamically directing* their own tool use and control flow. Flexible, expensive, hard to govern.

Most production "agents" I've shipped or audited are actually **workflows with one LLM step pretending to be autonomous**. That's not a failure — that's the correct answer most of the time. The Anthropic post is blunt about it: start with a single augmented LLM call, escalate only when the task genuinely demands model-driven control.

This reframes my governance pondering. "How do we govern agents?" is the wrong starting question. The right one is: **"What's the simplest agentic shape that solves this, and can I keep it a workflow?"**

## Mapping to My Work

| My Artifact | What it actually is | What I keep calling it |
|---|---|---|
| audit-ai-inf skill | Routing workflow (classify platform → run check → aggregate) | "Agent" |
| Copilot Skills generally | Prompt-chaining workflow with tool augmentation | "Agent" |
| ADO-GitHub bridges | Deterministic glue with optional LLM step | "Automation" (correct) |
| MCP server I've been sketching | Augmented-LLM building block | "Tool" (correct) |

Two of those four are mislabeled in my own head. That mislabeling is *why* governance feels brittle — I'm trying to put agent-grade controls on workflow-grade systems, and agent-grade autonomy on things that should stay deterministic.

## "Bots and Claws" — A Working Vocabulary

I want to stop saying "agent" as a catch-all. Borrowing the Anthropic patterns and giving them names that match how I actually think:

- **Claws** — single augmented-LLM calls with one tool reach (retrieval, a script, an API). Fast, cheap, audit-trivial. 80% of what I build should live here.
- **Workflows** — prompt chains, routers, parallel sectioning/voting, evaluator-optimizer loops. Deterministic control flow, LLM-powered steps. Most of my Skills belong here.
- **Bots** — true agents. LLM owns the control loop, decides which tool, when to stop. Reserve for open-ended tasks where I can't enumerate the steps in advance (e.g., "investigate why this incident happened").

The governance posture should differ per tier:

- Claws: input validation + output filter is enough.
- Workflows: per-step allowlists, gate checks between steps, full trace.
- Bots: trust scoring, budget caps (tokens, tool calls, wall time), human-in-the-loop checkpoints, sandboxed execution.

## What This Changes About My Governance Pondering

Going back to the open questions in `AI_Agent_Governance.md`:

1. **Trust decay** — only meaningful for *bots*. Workflows are re-verified by their gate checks every run; claws don't accumulate state.
2. **Cross-agent governance (A calls B)** — Anthropic's "orchestrator-workers" pattern is the honest framing. Compose policies most-restrictive-wins, and treat the orchestrator's budget as the hard ceiling.
3. **Human-in-the-loop cost** — solved structurally: HITL only at workflow gates or bot checkpoints, never on individual claws.
4. **Audit paradox** — log *decisions and tool calls*, not reasoning tokens. The post implicitly endorses this by treating the LLM as a black box between gates.

## Concrete Moves (Q3 2026 candidates)

- [ ] Re-classify every skill in `audit-ai-inf` and `CLI_AiInstructions` as claw / workflow / bot. Expect ~85% to be claws or workflows.
- [ ] Add a `tier:` field to SKILL.md frontmatter. Lets governance tooling apply the right policy automatically.
- [ ] Write the evaluator-optimizer pattern up as a reusable Skill template. I keep re-implementing it ad hoc for code-review and doc-generation work.
- [ ] Build *one* honest bot end-to-end (probably the incident-investigation use case) so I have first-hand data on where guardrails actually break, instead of theorizing.
- [ ] Stop using the word "agent" in repo names and PR titles unless tier 3 applies. Vocabulary discipline = design discipline.

## Tips I'm Taking from the Post

1. **"Start with the simplest solution; only add agentic complexity when measurable performance demands it."** This is the line I should print and tape over my monitor. My instinct is to reach for the bot pattern because it feels modern.
2. **Frameworks obscure prompts.** I've felt this with LangChain in the past. Confirms my Copilot-CLI bet — Skills keep the prompt visible and editable.
3. **Tool design is the leverage point.** "Agent-Computer Interfaces" matter as much as human UX. My audit-ai-inf experience confirms: the platforms with clean tool surfaces (MCP) are dramatically easier to govern than the ones with bespoke APIs.
4. **Parallelization > deeper chains** for cost/latency. Sectioning + voting is underused in my work.
5. **Evaluator-optimizer loops** are the highest-ROI workflow pattern I'm not using systematically.

## How This Sharpens "Infrastructure as Craft"

The craft contemplation said I'm choosing depth over abstraction-climbing. Anthropic's post is the same argument applied to agent design: refuse premature abstraction (frameworks, autonomous agents), prefer composable primitives you understand end-to-end. That's the same instinct that made me pick PowerShell + Skills over heavier orchestrators. Consistency check: passed.

## Open Questions This Surfaces

- Is there a useful "tier 0" below claws — pure deterministic automation where the LLM is optional or absent? Worth naming so I stop bolting LLMs onto things that don't need them.
- How do I measure when a workflow *should* graduate to a bot? Need a signal beyond "it feels limiting."
- Can `audit-ai-inf` evolve to detect tier-misclassification — flag when a skill is doing bot-level work without bot-level controls?

## References

- Anthropic, *Building Effective Agents* — https://www.anthropic.com/engineering/building-effective-agents
- Related local: `ponderings/AI_Agent_Governance.md`, `contemplations/Infrastructure_as_Craft.md`, `decisions/AI_Platform_Focus.md`
- Patterns to read next: Anthropic's agents cookbook; Simon Willison's tool-use writeups; OWASP LLM Top 10 mapped to claws/workflows/bots.

---

*Convert to decision once the claw/workflow/bot tiering proves out on at least 3 real skills (target: late Q3 2026).*
