---
name: weekly-reflection-assistant
description: Assist with weekly reflection capture by turning conversational notes into a structured weekly reflection.
---

# SKILL.md: Weekly Reflection Assistant

**Skill Name**: Weekly Reflection Assistant
**Purpose**: Help capture weekly signal quickly with AI assistance
**Invocation**: `New-WeeklyReflection.ps1 -Assist` or copilot skill command
**Time**: 5-10 minutes AI-assisted (vs. 15 min manual)
**Output**: Pre-filled reflection skeleton, ready to paste

---

## Description

An AI-powered reflection coach that helps you extract genuine wins, blockers, and learnings from your week in conversation format. Instead of staring at a blank template, you talk about your week and the skill structures your thinking into a reflection.

---

## When to Use

- Friday end-of-day: "Let me capture this week before I forget the details"
- Monday morning: "Let me reflect on what just happened"
- During a context switch: "Before I move to the next project, what happened this week?"

---

## How It Works

### Step 1: Trigger the Skill

```powershell
New-WeeklyReflection -Assist

# Or use directly
copilot /skill weekly-reflection-assistant
```

### Step 2: Conversation

```
Skill: "Tell me about this week. What were your wins?"
You: "Finished the reflection system, tested generators, documented workflow..."

Skill: "Great. Any blockers or challenges?"
You: "PowerShell formatting was finicky, had to rewrite one script..."

Skill: "What's one thing that clicked for you this week?"
You: "The pattern of systems compounding value became really clear..."

Skill: "How much time did you spend on primary vs. side work?"
You: "Probably 70% on reflection system, 30% on learning..."
```

### Step 3: Generated Skeleton

The skill outputs markdown skeleton ready to paste.

---

## Prompts Used

The skill uses a multi-turn conversation pattern to extract signal:

1. **Wins extraction** - What genuinely went well?
2. **Blocker surfacing** - What slowed you down?
3. **Learning capture** - What clicked for you?
4. **Pattern spotting** - What surprised you?
5. **Metrics collection** - How much time/effort?

See `prompts/` directory for specific prompt files.

---

## Integration with Scripts

### Enhanced New-WeeklyReflection.ps1

```powershell
param(
    [datetime]$WeekOf,
    [switch]$Assist,
    [int]$TimeAvailable = 15
)

if ($Assist) {
    # Load and invoke skill
    $skillPrompt = Get-WeeklySkillPrompt -TimeAvailable $TimeAvailable
    $result = Invoke-CopilotSkill -Skill "weekly-reflection-assistant" -Prompt $skillPrompt
    
    # Skill returns structured output
    # Generate skeleton from result
    $skeleton = Convert-SkillOutputToMarkdown -SkillResult $result -WeekOf $WeekOf
    
    # Offer to open in editor
    New-Item -Path $filePath -Value $skeleton
    Write-Host "Skeleton created. Review and adjust as needed."
}
```

### Usage

```powershell
# Manual (default)
New-WeeklyReflection

# With AI assistance
New-WeeklyReflection -Assist

# Custom time allocation
New-WeeklyReflection -Assist -TimeAvailable 10
```

---

## Customization Options

**By time availability:**
```powershell
-TimeAvailable 10   # Quick: top wins + key learning
-TimeAvailable 15   # Standard: full reflection
-TimeAvailable 30   # Deep: includes patterns + decisions
```

**By focus area:**
```powershell
-Focus "learning"    # Emphasize what you learned
-Focus "shipping"    # Emphasize what you delivered
-Focus "patterns"    # Emphasize emerging patterns
```

---

## Example Output

Skill conversation → Generated markdown:

```markdown
# Weekly Reflection: Week of May 19-25, 2026

**Status**: Completed
**Projects Touched**: Personal repo, reflection skills

## Wins This Week

- ✅ Reflection agent skills framework designed
- ✅ Weekly, monthly, quarterly skill prompts drafted
- ✅ Integration plan with scripts documented

## Blockers Encountered

- **Directory structure**: Had to create skill directories manually
  → Resolved by adding mkdir to script

## Learning Moments

- Discovered: AI assistance reduces friction, not increases complexity
- Reinforced: Skills compound when designed for reuse
- Realized: Prompts + structure are more important than code

## Patterns Observed

- About my work: Systems design is more energizing than implementation
- About energy: Designing abstractions feels creative, not tedious

## Next Week's Focus

- [ ] Create monthly analyzer skill
- [ ] Create quarterly assessor skill
- [ ] Test integrated workflow

## Metrics

- Sessions: 2
- Skills designed: 1 (weekly) + drafts (monthly, quarterly)
- Time on skills framework: 80%
```

---

## Future Enhancements

1. **Session data integration**: Auto-pull metrics (commits, PRs, file edits)
2. **Anomaly detection**: "This week is unusual because..."
3. **Trend analysis**: Compare to previous weeks
4. **Energy tracking**: Mood/energy/sustainability trends
5. **Velocity metrics**: Output vs. effort over time

---

## Performance

- ✅ Faster: 5-10 min with skill vs. 15 min manual
- ✅ Better patterns: AI connects dots you might miss
- ✅ Consistent: Same structure every time
- ✅ Lower friction: Talk vs. blank page

---

*Conversation → Structure → Paste. The skill handles the middle part.*
