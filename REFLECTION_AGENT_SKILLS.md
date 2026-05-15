# Reflection Agent Skills: Implementation Guide

Your reflection system now has AI-powered skills to reduce friction and surface patterns.

---

## 🎯 The Vision

**Before**: Generate skeleton → Blank page → Manual reflection (15-90 min)

**After**: Generate skeleton + skill → Guided conversation → AI structures → Paste (7-35 min)

**Result**: Same quality insights, less friction, better patterns detected.

---

## 📦 Three Skills Available

### 1. Weekly Reflection Assistant

**What it does**: Conversation-based weekly reflection capture
**Invocation**: `New-WeeklyReflection.ps1 -Assist`
**Time**: 5-10 min (vs. 15 min manual)
**Output**: Pre-filled skeleton

### 2. Monthly Pattern Analyzer

**What it does**: Extract patterns from 4 weekly reflections
**Invocation**: `New-MonthlyRetrospective.ps1 -Analyze`
**Time**: 5-10 min analysis + 30 min review (vs. 90 min manual)
**Output**: Month-at-a-glance summary

### 3. Quarterly Strategic Assessor

**What it does**: Assess 3-month trajectory and strategic direction
**Invocation**: `New-QuarterlyReview.ps1 -Assess`
**Time**: 15 min assessment + 1 hr strategy (vs. 3 hrs manual)
**Output**: Strategic assessment

---

## 🔌 How Scripts Support Skills

Each script can invoke a skill with flags:

```powershell
# Weekly with skill
New-WeeklyReflection -Assist

# Monthly with skill
New-MonthlyRetrospective -Analyze

# Quarterly with skill
New-QuarterlyReview -Assess
```

**Flow**:
1. Script invokes skill with relevant prompt
2. AI conducts conversation/analysis
3. Returns structured output
4. Script converts to markdown skeleton
5. You review and paste into file

---

## 📂 File Structure

```
.github/skills/reflection/
  ├── weekly-assistant/
  │   ├── SKILL.md
  │   └── prompts/
  │       └── weekly-reflection-prompt.md
  ├── monthly-analyzer/
  │   ├── SKILL.md
  │   └── prompts/
  │       └── monthly-patterns.md
  └── quarterly-assessor/
      ├── SKILL.md
      └── prompts/
          └── quarterly-assessment.md
```

---

## 💻 Usage Examples

### Weekly with Skill

```powershell
.\scripts\New-WeeklyReflection.ps1 -Assist
# Conversation with skill → Markdown generated → Paste
# Time: ~7 minutes
```

### Monthly with Skill

```powershell
.\scripts\New-MonthlyRetrospective.ps1 -Analyze
# Analyzes 4 weekly reflections → Month summary → Paste
# Time: ~35-40 minutes (vs. 90)
```

### Quarterly with Skill

```powershell
.\scripts\New-QuarterlyReview.ps1 -Assess
# Analyzes 3 months → Strategic assessment → Strategic thinking
# Time: ~1.25 hrs (vs. 3)
```

---

## ⚡ Time Savings

| Activity | Manual | With Skills | Saved |
|----------|--------|-------------|-------|
| Weekly | 15 min | 7 min | 8 min |
| Monthly | 90 min | 40 min | 50 min |
| Quarterly | 3 hrs | 1.25 hrs | 1.75 hrs |
| **Per year** | **~50 hrs** | **~20 hrs** | **~30 hrs** |

---

## 📖 Skill Details

See individual SKILL.md files for:
- **Weekly Assistant**: `.github/skills/reflection/weekly-assistant/SKILL.md`
- **Monthly Analyzer**: `.github/skills/reflection/monthly-analyzer/SKILL.md`
- **Quarterly Assessor**: `.github/skills/reflection/quarterly-assessor/SKILL.md`

Each includes:
- Purpose and when to use
- How it works (step-by-step)
- Customization options
- Integration with scripts
- Example workflows

---

## 🎓 Getting Started

**This Friday**:
```powershell
.\scripts\New-WeeklyReflection.ps1 -Assist
```

**Month-end**:
```powershell
.\scripts\New-MonthlyRetrospective.ps1 -Analyze
```

**Quarter-end**:
```powershell
.\scripts\New-QuarterlyReview.ps1 -Assess
```

---

## 💡 Philosophy

Skills aren't replacing reflection; they're **reducing friction** so you actually do it.

- Weekly is 7 min → You do it Friday consistently
- Monthly is 40 min → You do it month-end
- Quarterly is 1.25 hrs → You do it quarter-end

**Consistency compounds.** Skills make consistency achievable.

---

*Skills align flows. Scripts support skills. You get insights.*
