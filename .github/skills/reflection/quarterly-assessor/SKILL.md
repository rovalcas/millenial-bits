---
name: quarterly-strategic-assessor
description: Assess three monthly retrospectives to synthesize a quarterly strategic view.
---

# SKILL.md: Quarterly Strategic Assessor

**Skill Name**: Quarterly Strategic Assessor
**Purpose**: Assess 3-month trajectory and set strategic direction
**Invocation**: `New-QuarterlyReview.ps1 -Assess` or copilot skill
**Time**: 10-15 minutes AI assessment, 1-1.5 hours human strategy
**Output**: Strategic summary feeding into quarterly review

---

## Description

AI analyst that reviews your 3 monthly retrospectives and provides strategic assessment: Did goals materialize? What capabilities emerged? What's the authentic direction? Instead of manually stitching together 3 months, the skill synthesizes the patterns into a strategic view.

---

## When to Use

- Quarter-end (last day of quarter)
- Before setting next quarter priorities
- When reassessing strategic direction
- Career/role review conversations

---

## How It Works

### Step 1: Trigger

```powershell
New-QuarterlyReview -Assess -MonthlyRetros @("2026-04", "2026-05", "2026-06")
```

### Step 2: AI Assessment

Skill reads 3 months and extracts:
- Goals: planned vs. actual
- Capabilities emerged (planned + unplanned)
- Expertise markers
- Energy sustainability
- Work arc narrative
- Strategic signals

### Step 3: Output

```markdown
# Quarterly Strategic Assessment: Q2 2026

**Theme**: Building Scalable Personal Systems

**Quarter Arc**: Started with reflecting on work patterns,
evolved into building automated reflection system, culminated in
comprehensive reflection framework ready for long-term use.

## Strategic Observations

### Goals Assessment

- ✅ Reflection system: Exceeded (wanted framework, got full system)
- ✅ Personal knowledge repo: Achieved (structure + templates + examples)
- ⚠️  Learning path: Partial (created, but not yet tested)

### Capabilities Emerged

1. **Systems design** - Not planned; emerged from reflection work
   - Evidence: Designed 3 AI skills, modular architecture
   - Significance: Foundational for future work

2. **AI skill creation** - New capability
   - Evidence: Weekly/monthly/quarterly assistant skills
   - Significance: Opens new workflows

3. **Automation patterns** - Deepened
   - Evidence: PowerShell scripts, prompt engineering
   - Significance: Applicable to many domains

### Expertise Signals

- **Personal knowledge systems**: People asking, becoming go-to person
- **Reflection practice**: Teaching through examples, templates
- **Systems thinking**: Emerged as core strength

### Energy & Sustainability

- **Sustainable**: YES. 14 sessions/month felt right.
- **Energy pattern**: Highest when building systems, creating abstractions.
- **Pace**: Could sustain indefinitely.

### Strategic Direction Q3

**Recommendation**: Deepen systems thinking + start teaching.

Build on Q2 foundation:
1. Use reflection system for 8+ weeks (validate patterns emerge)
2. Document what you learn (teaching amplifies learning)
3. Explore: How do systems compound at team scale?

---

## Integration with Scripts

### Enhanced New-QuarterlyReview.ps1

```powershell
param(
    [switch]$Assess,
    [string[]]$MonthlyRetros
)

if ($Assess) {
    # Load assessment prompt
    $assessmentPrompt = Get-QuarterlyAssessmentPrompt
    
    # Read monthly retrospectives
    $monthlyContent = $MonthlyRetros | ForEach-Object {
        Get-Content "memories\$_`_Retrospective.md" -Raw
    }
    
    # Invoke skill
    $assessment = Invoke-CopilotSkill -Skill "quarterly-strategic-assessor" `
        -Prompt $assessmentPrompt -Context $monthlyContent
    
    # Generate quarterly skeleton with assessment
    $skeleton = Convert-AssessmentToSkeleton -Assessment $assessment -Quarter (Get-QuarterFromDate)
    
    New-Item -Path $quarterlyFile -Value $skeleton
}
```

### Usage

```powershell
# Manual (default)
New-QuarterlyReview

# With AI strategic assessment
New-QuarterlyReview -Assess
# Auto-finds monthly retros from current quarter

# Specific months
New-QuarterlyReview -Assess -MonthlyRetros @("2026-04", "2026-05", "2026-06")
```

---

## What Gets Assessed

✅ **Goal progress** - Planned vs. actual vs. exceeded
✅ **Emerging capabilities** - Unplanned skills that developed
✅ **Expertise markers** - What are you known for now?
✅ **Sustainability** - Can this pace continue?
✅ **Energy alignment** - What energizes you?
✅ **Strategic signals** - What direction feels natural?
✅ **Recommitment** - Stay course or shift?

❌ **Individual month details** - That's in monthly retros
❌ **Predictions** - Don't guess; assess what happened
❌ **Advice** - Offer patterns; let them decide

---

## Customization

**Assessment depth:**
```powershell
-AssessmentType "strategic"      # Big picture direction
-AssessmentType "capability"     # Skills/expertise growth
-AssessmentType "sustainability" # Energy + pace assessment
```

---

## Example Output

**Input**: 3 monthly retrospectives (April, May, June)

**Skill analysis**:
- April: Experimentation phase, low clarity
- May: Systems building, high focus, emerged capability
- June: Refinement + documentation, sustainable pace

**Skill synthesizes**:
- Theme: Systems matured from idea → implementation
- Goals: 60% hit, 20% exceeded, 20% shifted
- Capabilities: 3 emerged (systems, skills, automation)
- Expertise: Clear authority in personal systems
- Energy: Consistently high + sustainable
- Direction: Deepen + teach

**You review strategically**:
- Do these patterns feel right?
- Is this direction what I want?
- What does this mean for Q3?

**Total time**: 15 min assessment + 1 hr strategic thinking = 1.25 hrs vs. 3 hrs manual

---

## Future Enhancements

1. **Cross-quarter trends**: Compare to prior quarters
2. **Recommendation engine**: "Based on patterns, suggest Q[N+1] focus"
3. **Capability gap analysis**: "You're expert in X, growing in Y, missing Z"
4. **Market awareness**: "This expertise is valuable because..."
5. **Career trajectory**: "Multi-quarter arc suggests direction..."

---

*15 min of AI synthesis → 60+ minutes of strategic insight.*
