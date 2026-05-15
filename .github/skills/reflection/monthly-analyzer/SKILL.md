# SKILL.md: Monthly Pattern Analyzer

**Skill Name**: Monthly Pattern Analyzer
**Purpose**: Extract patterns from 4 weekly reflections + metrics
**Invocation**: `New-MonthlyRetrospective.ps1 -Analyze` or copilot skill
**Time**: 5-10 minutes AI analysis, 30 min human review
**Output**: Month-at-a-glance summary feeding into full retrospective

---

## Description

AI analyzer that reads your 4 weekly reflections and identifies patterns, trends, and insights you might miss. Instead of manually comparing weeks, the skill does the pattern extraction and surface-level analysis, so you can focus on strategic reflection.

---

## When to Use

- End of month: "Before I write my full retro, what patterns jumped out?"
- Mid-month check: "Is there a pattern forming in these blockers?"
- Context switch: "What's the overall shape of this month?"

---

## How It Works

### Step 1: Trigger

```powershell
New-MonthlyRetrospective -Analyze -WeeklyReflections @("2026-05_Week_1", "2026-05_Week_2", "2026-05_Week_3", "2026-05_Week_4")
```

### Step 2: AI Analysis

Skill reads all 4 weeks and extracts:
- Recurring themes
- Blocker patterns
- Energy trends
- Learning repetition
- Milestone moments

### Step 3: Output

```markdown
# Monthly Analysis: May 2026

**Theme**: Systems Building

**Month Arc**: Started with reflection system skeleton,
built generators week 2-3, documented and refined week 4.
Momentum built throughout month.

## Patterns Found

**Winning Pattern**: All 4 weeks included infrastructure/systems work.
Energy highest when building reusable patterns.

**Blocker Pattern**: PowerShell quirks hit weeks 1-2, resolved by
week 3 with different approach. Problem-solving improved over month.

**Learning Pattern**: "Automation reduces friction" appeared 3/4 weeks.
Central learning for month.

**Energy Pattern**: High early week, slightly dips mid-week, 
high again Friday. Weekly rhythm visible.

## Month at a Glance

- 14 sessions total
- 15+ files created
- 3 scripts automated
- Energy: High and sustainable
- Key achievement: Reflection system shipped
- Key learning: Systems compound
```

---

## Integration with Scripts

### Enhanced New-MonthlyRetrospective.ps1

```powershell
param(
    [switch]$Analyze,
    [string[]]$WeeklyReflections
)

if ($Analyze) {
    # Load analysis prompt
    $analysisPrompt = Get-MonthlyAnalysisPrompt
    
    # Read all weekly reflection files
    $weeklyContent = $WeeklyReflections | ForEach-Object {
        Get-Content "memories\$_.md" -Raw
    }
    
    # Invoke skill
    $analysis = Invoke-CopilotSkill -Skill "monthly-pattern-analyzer" `
        -Prompt $analysisPrompt -Context $weeklyContent
    
    # Generate monthly skeleton with analysis embedded
    $skeleton = Convert-AnalysisToSkeleton -Analysis $analysis -Month (Get-Date -Format "yyyy-MM")
    
    New-Item -Path $monthlyFile -Value $skeleton
}
```

### Usage

```powershell
# Manual (default)
New-MonthlyRetrospective

# With AI pattern analysis
New-MonthlyRetrospective -Analyze
# Auto-finds weekly reflections from current month

# Specific weeks
New-MonthlyRetrospective -Analyze -WeeklyReflections @("2026-05_Week_1", "2026-05_Week_2", "2026-05_Week_3", "2026-05_Week_4")
```

---

## Customization

**Focus areas:**
```powershell
-AnalysisDepth "quick"    # Top patterns only (5 min)
-AnalysisDepth "standard" # Full pattern analysis (10 min)
-AnalysisDepth "deep"     # Including edge cases (15 min)
```

**Pattern types:**
```powershell
-AnalyzeBlocers $true     # Focus on what slowed you down
-AnalyzeEnergy $true      # Focus on energy/sustainability
-AnalyzeTheme $true       # Focus on month's primary theme
```

---

## What Gets Analyzed

✅ **Repeating themes** - Appeared multiple weeks = significant
✅ **Blocker patterns** - Same issue multiple times = signal
✅ **Energy trends** - When was momentum high/low?
✅ **Learning repetition** - Learned same thing multiple ways?
✅ **Metrics trends** - Sessions increasing? Focus shifting?
✅ **Decision points** - What should be documented?

❌ **Individual week details** - Skip; that's in weekly reflections
❌ **Predictions** - Don't guess future; analyze past
❌ **Judgments** - Describe patterns, not "good" vs. "bad"

---

## Example Flow

**Weeks completed**: 4 weekly reflections done

**You run**:
```powershell
New-MonthlyRetrospective -Analyze
```

**Skill extracts**:
- Week 1: infrastructure work, PowerShell struggle, learning about automation
- Week 2: continued infrastructure, blocker resolved, same automation insight
- Week 3: infrastructure complete, new focus on documentation, energy high
- Week 4: reflection system shipped, learning compounded, direction clear

**Skill outputs**:
```
Theme: Systems Building
Pattern 1: Infrastructure focus all 4 weeks = core commitment
Pattern 2: PowerShell blocker resolved mid-month = learning curve completed
Pattern 3: Automation insight repeated = foundational understanding
Pattern 4: Energy high + sustainable = good pace
```

**You review & add strategic context**:
```
- Why infrastructure? Because it compounds.
- What did I learn about pace? Sustainable is better than cramped.
- Next month? Build on this foundation.
```

**Total time**: 5 min analysis + 30 min strategic review = 35 min vs. 90 min manual

---

## Future Enhancements

1. **Session data integration**: Auto-pull commits, PRs, file edits
2. **Comparison to prior months**: "This month was X% more focused than April"
3. **Velocity metrics**: "You shipped 40% more this month"
4. **Sustainability index**: "Energy remained consistent" vs. "Energy declined week 3"
5. **Anomaly detection**: "This week was unusual because..."

---

*5-10 min of AI thinking surfaces 60+ minutes of human insight.*
