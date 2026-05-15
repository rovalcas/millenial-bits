# Reflection Workflow Setup

Quick setup guide to start using automated reflection generation.

## Installation (2 minutes)

The PowerShell scripts are already in `scripts/`:
- `New-WeeklyReflection.ps1`
- `New-MonthlyRetrospective.ps1`
- `New-QuarterlyReview.ps1`

### Option 1: Use Directly (Simplest)

Open PowerShell in the repo root and run:

```powershell
.\scripts\New-WeeklyReflection.ps1
.\scripts\New-MonthlyRetrospective.ps1
.\scripts\New-QuarterlyReview.ps1
```

### Option 2: Add to PowerShell Profile (Recommended)

**Find your profile**:
```powershell
$PROFILE
# Output: C:\Users\roman.castro\Documents\PowerShell\profile.ps1
```

**Add these aliases**:
```powershell
# Tech Life Reflections
function New-WeeklyReflection { 
    & "C:\Users\roman.castro\Source\Personal\millenial-bits\scripts\New-WeeklyReflection.ps1" @args 
}

function New-MonthlyRetrospective { 
    & "C:\Users\roman.castro\Source\Personal\millenial-bits\scripts\New-MonthlyRetrospective.ps1" @args 
}

function New-QuarterlyReview { 
    & "C:\Users\roman.castro\Source\Personal\millenial-bits\scripts\New-QuarterlyReview.ps1" @args 
}
```

**Then use globally**:
```powershell
New-WeeklyReflection
New-MonthlyRetrospective -Month "2026-06"
New-QuarterlyReview -Quarter "2026_Q3"
```

---

## Weekly Workflow

**Every Friday @ EOD (15 min)**

```powershell
# Step 1: Generate skeleton
New-WeeklyReflection

# Step 2: Open and fill in
code memories\2026-05_Week_3_Reflection.md

# Step 3: Update index
code memories\REFLECTIONS_INDEX.md
# Add entry to timeline section
```

**What to capture**:
- 3-4 wins
- 1-2 blockers (and resolutions)
- Key learning moments
- Work metrics (sessions, PRs, focus %)

---

## Monthly Workflow

**Last day of month (90 min)**

```powershell
# Step 1: Generate skeleton
New-MonthlyRetrospective

# Step 2: Open, analyze, fill
code memories\2026-05_Retrospective.md

# Step 3: Update index
code memories\REFLECTIONS_INDEX.md
# Add new month to timeline, update metrics
```

**What to do**:
- Review all weekly reflections from month
- Look for patterns (productivity, focus, energy)
- Compare to previous month
- Set priorities for next month

---

## Quarterly Workflow

**End of quarter (2-3 hours)**

```powershell
# Step 1: Generate skeleton
New-QuarterlyReview

# Step 2: Do strategic assessment
code memories\2026_Q2_Quarterly_Review.md
# Reference all monthly retros
# Assess quarterly goals vs. actual
# Identify capabilities gained

# Step 3: Update index
code memories\REFLECTIONS_INDEX.md
# Add new quarter, update trajectory analysis
```

**What to assess**:
- Did you hit quarterly goals?
- What new capabilities emerged?
- What was the team impact?
- What should Q3 focus on?

---

## File Naming Convention

Scripts auto-generate filenames. Don't rename manually.

| Type | Format | Example |
|------|--------|---------|
| Weekly | `YYYY-MM_Week_NN_Reflection.md` | `2026-05_Week_03_Reflection.md` |
| Monthly | `YYYY-MM_Retrospective.md` | `2026-05_Retrospective.md` |
| Quarterly | `YYYY_QN_Quarterly_Review.md` | `2026_Q2_Quarterly_Review.md` |

---

## Timeline

| Cadence | When | Duration | Effort |
|---------|------|----------|--------|
| Weekly | Friday EOD | 15 min | Quick |
| Monthly | Last day of month | 90 min | Medium |
| Quarterly | Last day of quarter | 2-3 hrs | Deep |
| Annual | Dec 31 | 3-4 hrs | Strategic |

---

## Tips

### Auto-Generate Next Week's Skeleton Monday Morning

```powershell
# Add to your Monday morning routine
New-WeeklyReflection -WeekOf "2026-05-19"
```

### Batch-Generate Multiple Months (for backfill)

```powershell
# Backfill June, July, August
New-MonthlyRetrospective -Month "2026-06"
New-MonthlyRetrospective -Month "2026-07"
New-MonthlyRetrospective -Month "2026-08"
```

### Use Git to Track Reflection Progress

```bash
git add memories/2026-05_Week_3_Reflection.md
git add memories/REFLECTIONS_INDEX.md
git commit -m "Weekly reflection: May 19-25"
```

### Link Related Files in Reflections

When creating reflections, reference:
- `[My decision](../decisions/AI_Platform_Focus.md)`
- `[Project context](../projects/active/CLI_AiInstructions.md)`
- `[Pondering](../ponderings/AI_Agent_Governance.md)`

---

## Automation Ideas (Future)

Once the pattern is established, could:

1. **Auto-populate from git logs**
   - Extract commits from past week
   - List PRs merged
   - Count session files created

2. **Metrics dashboard**
   - Parse REFLECTIONS_INDEX.md
   - Generate velocity charts
   - Show patterns over time

3. **AI-assisted summary**
   - Use Claude to draft learnings from session history
   - Suggest patterns from your own data

---

## Troubleshooting

**Script won't run**:
```powershell
# Check execution policy
Get-ExecutionPolicy

# If restricted, allow for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**File already exists error**:
- Check `memories/` folder
- If file is there but incomplete, open and edit manually
- Scripts won't overwrite existing files (safety feature)

**Wrong date in filename**:
- Specify date explicitly: `New-WeeklyReflection -WeekOf "2026-05-19"`
- Format: "YYYY-MM-DD" or "Month DD, YYYY"

---

## What Happens After

Once you have 3-4 months of reflections:

1. **Review trends** - Weekly metrics → monthly patterns → quarterly arc
2. **Update REFLECTIONS_INDEX.md** - It becomes your knowledge base timeline
3. **Reference decisions** - When making choices, check what you learned before
4. **Teach from reflections** - Share patterns with team, adjust approach
5. **Annual review** - Synthesize year's learnings into single powerful narrative

---

*Start simple. Run `New-WeeklyReflection` this Friday and fill it in. One reflection at a time.*
