# AI Tooling Stack

**Last Updated**: May 2026

## Primary Tools

### GitHub Copilot CLI
**Role**: Primary development assistant
- Installed locally, scriptable
- Skills framework for custom commands
- Integration with GitHub ecosystem
- Most familiar tool

**Setup**: 
```powershell
# Copilot CLI available system-wide
copilot [command]
copilot /help
```

### GitHub Copilot in VS Code
**Role**: IDE code completion and chat
- Fast, integrated suggestions
- Copilot Chat for multi-file context
- Inline fixes and refactoring

### Claude (claude.ai & Claude Code)
**Role**: Complex reasoning, analysis, teaching
- Better at explaining tradeoffs
- Useful for architecture decisions
- Web interface for scratchpad work
- Claude Code for pair programming

**Strengths over Copilot**:
- Deeper reasoning on ambiguous problems
- Better at long-form documentation
- Good for rubber-duck feedback
- Strong on security/governance analysis

### Cline
**Role**: Autonomous file operations
**When**: Batch file edits, refactoring across many files
**Limitation**: Less familiar with company-specific patterns

## Setup & Preferences

### PowerShell Configuration
**Primary shell**: Windows PowerShell 5.1 (corporate standard)
- Most scripts assume pwsh syntax
- Azure CLI integration heavy
- Git aliases for common workflows

### Environment Variables
```
GH_TOKEN=<personal access token>
COPILOT_CLI_CONFIG=~/.copilot
ADO_PAT=<azure devops pat>
```

### Installed Tools
- Git
- GitHub CLI (gh)
- Azure CLI (az)
- PowerShell Core (optional, for testing)

## Tool Selection Heuristics

| Task | Tool | Why |
|------|------|-----|
| Write PowerShell script | Copilot CLI | Best context on patterns |
| Explain complex design | Claude | Deeper reasoning |
| Refactor large area | Cline | Batch operations |
| IDE completion | Copilot IDE | Fastest feedback |
| Governance analysis | audit-ai-inf skill | Pre-built, verified |
| Learning new thing | Claude Code | Teaching-focused |

## Future Setup Considerations

- [ ] Evaluate Cline for more routine tasks
- [ ] Test MCP servers for local tool execution
- [ ] Consider Claude Code for larger refactors
- [ ] Explore agent-based automation (vs. CLI)

---

*This tooling is intentionally overlapping. Each tool has strengths; combining them covers more ground.*
