# Learning Path: Human Skills for the AI-Augmented Era

**Current Focus**: Q3 2026 onward
**Status**: Active — evolving
**Context**: .NET company, PowerShell-native, Copilot CLI primary, shifting toward agents and eval

---

## The Core Premise

As AI agents write more of the code, the value a human brings isn't *typing* — it's **judgment, taste, and the ability to ask the right question at the right tier**.

The "human-in-the-loop" is not a safety checkbox. It's an architectural role. Staying educated means knowing *what* humans are uniquely good at, and drilling those skills intentionally while the easy automation stuff gets delegated away.

This is what I want to be excellent at: **the irreplaceable human at the center of well-governed agentic systems.**

---

## Tier 1: Irreplaceable Human Skills

These are not "soft skills." They are the primary leverage points for someone operating at the agent-governance/infrastructure level.

### 1.1 Problem Formulation (highest leverage)

**Why it matters**: AI can execute with stunning precision on the wrong problem. The human job is to define the problem correctly — constraining scope, naming assumptions, identifying what *not* to automate.

Relate to my work:
- Writing good SKILL.md instructions is problem formulation
- A bad system prompt causes cascading failures no guardrail can fix
- The best prompt engineers I've observed are precise writers, not prompt hackers

**Practice**: Before every skill authoring session, write one paragraph: "what problem does this solve, and what problems does it deliberately *not* solve?" File it. Review accuracy after delivery.

### 1.2 Evaluation Judgment (most urgent gap)

**Why it matters**: When AI writes the code, the human role shifts from *writing* to *judging correctness*. This requires understanding what good looks like — in outputs, in trace logs, in edge-case behavior — even when you didn't write the thing being evaluated.

Relate to my work:
- The eval-under-investment problem (flagged in `Honest_Audit_Waza_and_Wrong_Trees.md`)
- Reading Waza run outputs, grading LLM-as-judge results, catching regressions
- Knowing when a workflow "passed" but is still wrong

**Practice**: Write the acceptance criteria *before* running the agent. Then compare what you got against what you specified. The gap is learning.

### 1.3 Systems Thinking at Scale

**Why it matters**: Individual skills/claws are easy. The hard part is understanding how they compose, how failure propagates, and where the control flow assumptions break. This is a human reasoning task — agents don't yet reason well about their own architectures.

Relate to my work:
- The claw/workflow/bot tiering is systems thinking applied to agent design
- ADO-GitHub bridges, orchestrator-worker patterns, trust propagation across agents
- Infrastructure as Craft — thinking about future-me reading this

**Practice**: For any new system, draw the failure mode diagram before building. Ask: if step 3 returns garbage, what happens to steps 4–6?

### 1.4 Taste and Pattern Recognition

**Why it matters**: AI-generated code is syntactically correct and often subtly wrong. Spotting "this works but it's fragile" or "this is elegant" is taste — developed through exposure, reading, and reflection. The engineers AI can't replace are the ones who immediately recognize bad architecture even when they can't always articulate why.

Relate to my work:
- Reading others' Skills and knowing when one is well-designed
- Recognizing over-engineered governance vs. good governance
- The craft contemplation: "People notice poorly-designed infrastructure"

**Practice**: Read one well-crafted external skill, script, or agent implementation per week. Write 3 sentences on what made it good or bad. File in `work-patterns/`.

### 1.5 Clear Technical Writing

**Why it matters**: AI reads your instructions literally. Ambiguity in a system prompt or SKILL.md causes real failures. The humans who will thrive are those who can write with precision — who can express constraints, scope, intent, and edge cases unambiguously.

Also: as the team's "AI infrastructure" person, teaching others (through documentation) *is* the primary force multiplier.

Relate to my work:
- Every SKILL.md, every copilot-instructions.md, every ADR
- Documentation-first bias already present — double down, don't relax it

**Practice**: After writing any instruction set, have a junior (or an LLM) try to follow it literally and report what went wrong. Ambiguity surfaces instantly.

---

## Tier 2: Technical Skills Worth Investing In

### 2.1 Python — Framework Tier (start now)

**What to learn**: Not Python-as-programming-language (you can read it). Python *as the lingua franca of agentic frameworks*.

Specific targets:
- `pydantic` and `pydantic-ai` — typed data modeling, used everywhere in agent definitions
- `asyncio` — most agent frameworks are async; understanding the event loop matters when debugging
- `httpx` + `openai` / `anthropic` SDK — raw client calls without frameworks, so you can read framework source
- One framework end-to-end: **PydanticAI** (typed, clean, closest to your PowerShell-typed instincts) or **CrewAI** (higher-level, good for multi-agent prototypes)

**What not to learn right now**: LangChain (too much abstraction), LlamaIndex (RAG-specific, not your primary focus), ML training (not applied AI engineering).

**Approach**: One real project, not tutorials. Build the "honest bot" (incident-investigation use case from the Bots-and-Claws pondering) in Python. Force the context switch.

**Honest note on .NET**: keep C# as the delivery language for production integrations at your company. Microsoft Semantic Kernel (`microsoft/semantic-kernel`) is the .NET-native agent framework — it's credible, has MCP support, and if you ever need to ship agent logic inside a .NET service, that's the path. But don't prototype in it; prototype in Python and port selectively.

### 2.2 Semantic Kernel (.NET) — Know It, Don't Dive Yet

**Why it matters**: This is the Microsoft answer to LangChain/CrewAI for .NET shops. It has:
- Plugin/skill registration (analogous to tool-calling)
- Planner (auto-orchestration, the "bot" tier)
- Memory stores (vector, in-memory)
- Native MCP client support (as of 2025)

**When this becomes important**: when your company needs agent logic shipped inside an existing .NET API or Azure Function. Today it's research; in 12–18 months it could be production infrastructure.

**For now**: one hour reading the Getting Started + Planner docs. Enough to know the vocabulary. Revisit when a real .NET integration project surfaces.

### 2.3 MCP (Model Context Protocol) — Invest Here

**Why it matters**: MCP is the TCP/IP of agentic tool connectivity. Anthropic open-sourced it, Microsoft/GitHub adopted it, OpenAI aligned to it. It is the emerging standard for how agents connect to tools, databases, file systems, and APIs. This is not framework-specific — a skill in MCP design pays off across Copilot, Cursor, Claude Code, PydanticAI, Semantic Kernel.

**Specific skills to develop**:
- Writing an MCP server (TypeScript SDK is simplest to start; Python SDK exists)
- Tool schema design — inputs/outputs, error contracts, idempotency
- Understanding transport: stdio vs. HTTP/SSE vs. WebSocket
- Security model: what an MCP server can and can't be trusted to expose

**Relate to your governance work**: MCP server design *is* the "Tool design = leverage point" insight from the Bots-and-Claws pondering. Building one end-to-end will teach more about agent/tool contracts than reading 10 blog posts.

### 2.4 YAML / Structured Config Literacy

**Why it matters**: Eval harnesses (Waza), agent policies, Kubernetes manifests, GitHub Actions, skill metadata — nearly everything in the agentic infrastructure layer is configured in YAML. Humans who can read and write dense YAML schemas fluently, and who can reason about what a config *actually does*, are undervalued.

This is already partially present (SKILL.md frontmatter, copilot-instructions YAML). Extend it deliberately: understand JSON Schema, OpenAPI spec structure, and the MCP schema format.

---

## Tier 3: Keep Watching, Not Investing Yet

| Area | Signal to invest | Current stance |
|---|---|---|
| TypeScript / Node (MCP servers) | When you write your first MCP server | Know enough to read it |
| Rust / Go (Waza, low-level infra) | Unlikely to be needed — let the binary be a binary | Skip |
| Fine-tuning / model training | If you need custom model behavior that prompting can't achieve | Not yet |
| RAG / vector search | If eval or knowledge retrieval becomes a primary workstream | Monitor |
| Observability stack (OTel, Prometheus) | When you ship a bot to production | Aware, not active |

---

## The Language Reality Check

| Language | Your role | Justification |
|---|---|---|
| **PowerShell** | Script tier, infra glue, generators, Windows automation | Keep; it has a ceiling for agent frameworks but not for its actual job |
| **Python** | Framework tier, agent prototypes, eval harnesses | Invest now; this is where the agent ecosystem lives |
| **C# / .NET** | Production delivery in company systems | Keep as deployment language; Semantic Kernel when needed |
| **TypeScript** | MCP server authoring, Copilot SDK integrations | Learn enough to ship one MCP server |
| **YAML / JSON Schema** | Config, metadata, eval specs | Already started; deepen deliberately |
| **Bash/shell** | Minimal — enough to read CI pipelines | Don't invest |

---

## What "Human-in-the-Loop" Actually Means in Practice

It is **not** clicking "approve" on agent actions. That's a bottleneck, not a control.

Real HITL in a well-designed system means:

1. **You wrote the evals** that define what correct looks like — before the agent ran.
2. **You designed the gates** — which workflow steps require a human decision, and why.
3. **You're reading the traces** — not every run, but anomalies. You notice when the pattern shifts.
4. **You maintain the taxonomy** — the tier classification, the governance policy, the skill metadata. Machines execute; humans classify and decide policy.
5. **You're the teacher** — other engineers learn the system from your documentation and your code reviews. The system's quality ceiling is your quality ceiling.

The goal is not to stay in the loop of every agent run. The goal is to be the person who makes the loop worth running.

---

## Immediate Next Actions (Q3 2026)

- [ ] Build the "honest bot" incident-investigation prototype in **Python + PydanticAI**. File learnings in `memories/`.
- [ ] Write one MCP server (any useful tool from your existing Skills). Target: TypeScript SDK.
- [ ] Read Semantic Kernel Getting Started + Planner docs. One sitting. Note vocabulary in `decisions/`.
- [ ] Add "write acceptance criteria before running" habit to weekly reflection template.
- [ ] One well-crafted agent implementation read per week. 3-sentence debrief in `work-patterns/`.

---

## References

- Anthropic, *Building Effective Agents* — https://www.anthropic.com/engineering/building-effective-agents
- Microsoft Semantic Kernel — https://github.com/microsoft/semantic-kernel
- MCP Spec — https://modelcontextprotocol.io
- PydanticAI — https://ai.pydantic.dev
- Microsoft Waza — https://github.com/microsoft/waza
- Related local: `contemplations/Honest_Audit_Waza_and_Wrong_Trees.md`, `ponderings/Workflows_vs_Agents_Bots_and_Claws.md`, `decisions/AI_Platform_Focus.md`

---

*This path is about staying irreplaceable, not staying busy. The skills that matter are the ones that make the agents better — and only a human can do that.*

*Review: end of Q3 2026*
