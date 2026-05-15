# Decision: Focus on Copilot CLI Over Alternatives

**Date**: April 2026
**Status**: Active
**Review Date**: July 2026

## Question

Which AI assistant platform should be primary focus for infrastructure skills and tooling?

## Options Evaluated

1. **GitHub Copilot CLI** ✓ Chosen
   - Tight GitHub integration
   - Skills framework mature
   - CLI-first design
   - Growing ecosystem

2. Claude / Claude Code
   - Excellent reasoning
   - Strong for complex analysis
   - Web-based limitations
   - Not CLI-native

3. Cursor
   - IDE-integrated
   - Good for refactoring
   - Limited to IDE context
   - No team skills/governance model

4. Cline / Windsurf / OpenCode
   - Full capability MCP
   - Growing adoption
   - Less stable ecosystem
   - Fragmented tooling

## Rationale

**Chosen: Copilot CLI**

- GitHub Skills framework enables team reuse (highest leverage)
- CLI-first design aligns with infrastructure automation
- Tight integration with GitHub Actions, ADO bridges
- Sustainable business model through GitHub
- Multiple IDE support (not locked to one editor)

## Implementation Impact

- Primary skill development in PowerShell
- Copilot instructions as standard documentation pattern
- Multi-platform compatibility (Claude, Cursor, Cline via MCP)
- Tool-agnostic skill design (portable across platforms)

## Trade-offs

- Not optimizing for Claude's reasoning strength
- Missing IDE-only features (Cursor refactoring)
- Supporting multiple platforms adds complexity

## Outcome (so far)

- 30+ sessions on CLI_AiInstructions repo
- 7 projects using Copilot SDK or skills
- audit-ai-inf skill covers 6 AI platforms
- Team adoption path clear

## When to Revisit

- If Copilot Skills framework stagnates
- If Claude Claude Code gains substantial CLI tooling
- Quarterly evaluation against new platforms

---

*Related: [Why PowerShell](./PowerShell_Selection.md), [Audit Governance](./AI_Governance_Framework.md)*
