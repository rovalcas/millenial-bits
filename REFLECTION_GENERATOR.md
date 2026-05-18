# Generate New Reflections

Quick tools to generate dated reflection skeletons automatically.

## Bash Script: Generate Any Reflection

Use `scripts/new-reflection.sh` on Linux/macOS or any shell environment with GNU `date`.

```bash
# Generate current week/month/quarter
./scripts/new-reflection.sh weekly
./scripts/new-reflection.sh monthly
./scripts/new-reflection.sh quarterly

# Generate specific periods
./scripts/new-reflection.sh weekly 2026-06-01
./scripts/new-reflection.sh monthly 2026-06
./scripts/new-reflection.sh quarterly 2026_Q3
```

The Bash generator mirrors the PowerShell skeletons, including the `Audience`, `Team insight candidate`, and newsletter/team-sharing sections.

## PowerShell Script: Generate Weekly Reflection

Save as `scripts/New-WeeklyReflection.ps1`

```powershell
<#
.SYNOPSIS
    Generate a new weekly reflection file with date headers filled in.

.PARAMETER WeekOf
    The Monday date of the week (e.g., "2026-05-19" or "May 19, 2026")
    If not provided, uses current week's Monday.

.EXAMPLE
    .\New-WeeklyReflection.ps1
    # Generates for this week

    .\New-WeeklyReflection.ps1 -WeekOf "2026-06-02"
    # Generates for week of June 2, 2026
#>

param(
    [Parameter(ValueFromPipeline)]
    [datetime]$WeekOf
)

if (-not $WeekOf) {
    $today = [datetime]::Now
    $WeekOf = $today.AddDays(- ($today.DayOfWeek - [DayOfWeek]::Monday))
}

$year = $WeekOf.Year
$month = $WeekOf.Month.ToString("00")
$dayStart = $WeekOf.Day.ToString("00")
$dayEnd = $WeekOf.AddDays(6).Day.ToString("00")

$filename = "{0}-{1}_Week_{2:D2}_{3:D2}_Reflection.md" -f $year, $month, [math]::Ceiling($WeekOf.Day / 7), [math]::Ceiling($WeekOf.AddDays(6).Day / 7)

$reposPath = "C:\Users\roman.castro\Source\Personal\millenial-bits"
$filePath = Join-Path $reposPath "memories" $filename

if (Test-Path $filePath) {
    Write-Host "File already exists: $filename"
    return
}

$dateRange = "$($WeekOf.ToString('MMMM d'))-$($WeekOf.AddDays(6).ToString('d, yyyy'))"

$content = @"
# Weekly Reflection: Week of $dateRange

**Status**: Completed
**Projects Touched**: 

## Wins This Week

- ✅ 
- ✅ 
- ✅ 

## Blockers Encountered

- **Blocker 1**: Description → Resolution/Status

## Learning Moments

- Discovered: 
- Reinforced: 
- Realized: 

## Patterns Observed

- About my work: 
- About team/projects: 

## Next Week's Focus

- [ ] Priority 1
- [ ] Priority 2
- [ ] Open question

## Metrics

- Sessions: 
- PRs: 
- Skills/docs completed: 
- Time on primary project: %

---

*Fill in during Friday reflection. Aim for 15 minutes.*
"@

New-Item -Path $filePath -ItemType File -Value $content | Out-Null
Write-Host "✅ Created: $filename"
Write-Host "📁 Path: $filePath"
```

**Usage**:
```powershell
# Generate for current week
.\scripts\New-WeeklyReflection.ps1

# Generate for specific week
.\scripts\New-WeeklyReflection.ps1 -WeekOf "2026-06-02"
```

---

## PowerShell Script: Generate Monthly Retrospective

Save as `scripts/New-MonthlyRetrospective.ps1`

```powershell
<#
.SYNOPSIS
    Generate a new monthly retrospective file with date headers filled in.

.PARAMETER Month
    The month in format "YYYY-MM" (e.g., "2026-06")
    If not provided, uses current month.

.EXAMPLE
    .\New-MonthlyRetrospective.ps1
    # Generates for current month

    .\New-MonthlyRetrospective.ps1 -Month "2026-06"
    # Generates for June 2026
#>

param(
    [Parameter(ValueFromPipeline)]
    [string]$Month
)

if (-not $Month) {
    $today = [datetime]::Now
    $Month = $today.ToString("yyyy-MM")
}

$filename = "{0}_Retrospective.md" -f $Month
$reposPath = "C:\Users\roman.castro\Source\Personal\millenial-bits"
$filePath = Join-Path $reposPath "memories" $filename

if (Test-Path $filePath) {
    Write-Host "File already exists: $filename"
    return
}

[datetime]$monthStart = "$Month-01"
$monthName = $monthStart.ToString("MMMM yyyy")
$year = $monthStart.Year

$content = @"
# Monthly Retrospective: $monthName

**Period**: $Month-01 to $Month-$([DateTime]::DaysInMonth($monthStart.Year, $monthStart.Month))
**Primary Focus**: 
**Sessions**: 

## Big Picture

### Goals Set

- [ ] Goal 1: [Outcome]
- [ ] Goal 2: [Outcome]
- [ ] Goal 3: [Outcome]

### Results

## What Went Well ✅

1. **Win 1**
   - Context: 
   - Outcome: 
   - Replicable: 

## What Was Challenging ⚠️

1. **Challenge 1**
   - Context: 
   - What I tried: 
   - Lesson: 

## Key Learnings

### Technical

- Learning 1: 
- Pattern discovered: 

### Process

- Process improvement: 
- Bad habit identified: 

### About Myself

- Observation: 
- Surprising: 

## Data Points

| Metric | Value | Notes |
|--------|-------|-------|
| Sessions | | |
| Commits/PRs | | |
| Primary repo time | % | |
| Major blockers | | |

## Projects Updated

- **[Project 1]**: [Status]

## Decisions Made

- **Decision 1**: [Choice] → File: \`decisions/Decision_Name.md\`

## Open Questions / Explorations

- **Question 1**: [Status] → File: \`ponderings/Question.md\`

## Team Impact

- What did your work enable for others?
- Feedback received?

## Next Month's Direction

**Theme**: 

### Priorities

1. [ ] Priority 1 & why
2. [ ] Priority 2 & why

### Skills to Develop

- Skill 1: Why is this next?

### Risks / Concerns

- Risk: [What could go wrong?] → Mitigation: [How to address]

---

## Month-on-Month Comparison

| Aspect | This Month | Last Month | Change |
|--------|-----------|-----------|--------|
| Focus | | | |
| Shipping | | | |
| Learning | | | |

---

*This retro took [time]. Goal: 1-2 hours investment.*
"@

New-Item -Path $filePath -ItemType File -Value $content | Out-Null
Write-Host "✅ Created: $filename"
Write-Host "📁 Path: $filePath"
```

**Usage**:
```powershell
# Generate for current month
.\scripts\New-MonthlyRetrospective.ps1

# Generate for specific month
.\scripts\New-MonthlyRetrospective.ps1 -Month "2026-06"
```

---

## PowerShell Script: Generate Quarterly Review

Save as `scripts/New-QuarterlyReview.ps1`

```powershell
<#
.SYNOPSIS
    Generate a new quarterly review file.

.PARAMETER Quarter
    The quarter in format "YYYY_QN" (e.g., "2026_Q2")
    If not provided, uses current quarter.

.EXAMPLE
    .\New-QuarterlyReview.ps1
    # Generates for current quarter

    .\New-QuarterlyReview.ps1 -Quarter "2026_Q3"
    # Generates for Q3 2026
#>

param(
    [Parameter(ValueFromPipeline)]
    [string]$Quarter
)

if (-not $Quarter) {
    $today = [datetime]::Now
    $qNum = [math]::Ceiling($today.Month / 3)
    $Quarter = "$($today.Year)_Q$qNum"
}

$filename = "{0}_Quarterly_Review.md" -f $Quarter
$reposPath = "C:\Users\roman.castro\Source\Personal\millenial-bits"
$filePath = Join-Path $reposPath "memories" $filename

if (Test-Path $filePath) {
    Write-Host "File already exists: $filename"
    return
}

$content = @"
# Quarterly Review: $Quarter

**Period**: 
**Overarching Theme**: 

## Quarter Snapshot

- **Sessions**: 
- **Primary repos**: 
- **Major shipped items**: 
- **Blockers**: 

## Goals Assessment

### Set at Start of Quarter

| Goal | Target | Actual | Status |
|------|--------|--------|--------|
| Goal 1 | | | ✅ / ⚠️ / ❌ |

### Why gaps exist (if any)

## Capabilities Gained

What can you do now that you couldn't at start of quarter?

- Capability 1: 
- Capability 2: 

## Expertise Markers

Areas where people now see you as the expert:

1. [Domain/skill]: Why? How did you demonstrate it?

## Work Trajectory

**Arc of the quarter**: 

## Three Biggest Wins

1. **Win**: 
   - Impact: 
   - Leveraged: 

## Three Biggest Learnings

1. **Learning**: 
   - Source: 
   - Application: 

## Team Dynamics

- How did you contribute to team success?
- Feedback from peers/leads?

## Personal Observations

### What's Different About How I Work

- Shift 1: 

### What Surprised Me

- Surprise 1: 

### Energy Levels

- What energized you? 
- What depleted you? 
- Sustainable pace: 

## Market / External Changes

What changed in your domain, platforms, or team landscape?

- Change 1: 

## Looking Ahead to Q3

### Strategic Focus

**Theme**: 

### Priorities (in order)

1. [Priority 1 & why it matters]

### Stretch Goals

- Goal 1: 

### Risk Mitigation

- Risk: [What could derail?] → Mitigation: 

### Skill Development Roadmap

**Want to develop**:
- Skill 1: 

**Want to deepen**:
- Skill 1: 

---

## Quarter-on-Quarter Comparison

| Dimension | This Q | Last Q | Trajectory |
|-----------|--------|--------|------------|
| Shipping velocity | | | ⬆️ / ➡️ / ⬇️ |
| Expertise breadth | | | |
| Team impact | | | |

---

## Recommitment

At the end of this quarter, do you want to:
- [ ] Continue current trajectory
- [ ] Shift direction (why?)
- [ ] Pause and reassess (why?)

**Why**: 

---

*This review took [time].*
"@

New-Item -Path $filePath -ItemType File -Value $content | Out-Null
Write-Host "✅ Created: $filename"
Write-Host "📁 Path: $filePath"
```

**Usage**:
```powershell
# Generate for current quarter
.\scripts\New-QuarterlyReview.ps1

# Generate for specific quarter
.\scripts\New-QuarterlyReview.ps1 -Quarter "2026_Q3"
```

---

## Bash Alternative (if you prefer)

If you use bash/git bash:

```bash
#!/bin/bash
# scripts/new-weekly-reflection.sh

REPO_PATH="C:/Users/roman.castro/Source/Personal/millenial-bits"
MONDAY=${1:-$(date -d 'monday this week' +%Y-%m-%d)}

YEAR=$(date -d "$MONDAY" +%Y)
MONTH=$(date -d "$MONDAY" +%m)
WEEK=$(date -d "$MONDAY" +%V)

FILENAME="${YEAR}-${MONTH}_Week_${WEEK}_Reflection.md"
FILEPATH="$REPO_PATH/memories/$FILENAME"

if [ -f "$FILEPATH" ]; then
    echo "File already exists: $FILENAME"
    exit 1
fi

DATE_RANGE=$(date -d "$MONDAY" +'%B %-d')-$(date -d "$MONDAY + 6 days" +'%-d, %Y')

cat > "$FILEPATH" << 'EOF'
# Weekly Reflection: Week of $DATE_RANGE

**Status**: Completed
**Projects Touched**: 

[... rest of template ...]
EOF

echo "✅ Created: $FILENAME"
```

---

## Quick Aliases

Add to PowerShell profile (`$PROFILE`) or `.bashrc`:

**PowerShell**:
```powershell
function New-WeeklyReflection { & "C:\Users\roman.castro\Source\Personal\millenial-bits\scripts\New-WeeklyReflection.ps1" @args }
function New-MonthlyRetrospective { & "C:\Users\roman.castro\Source\Personal\millenial-bits\scripts\New-MonthlyRetrospective.ps1" @args }
function New-QuarterlyReview { & "C:\Users\roman.castro\Source\Personal\millenial-bits\scripts\New-QuarterlyReview.ps1" @args }
```

Then use:
```powershell
New-WeeklyReflection
New-MonthlyRetrospective -Month "2026-06"
New-QuarterlyReview -Quarter "2026_Q3"
```

---

## How It Works

Each script:
1. ✅ Calculates proper dates (Monday for week, month range for retro, etc.)
2. ✅ Generates filename with date format: `YYYY-MM_Name.md`
3. ✅ Pre-fills skeleton with all template sections
4. ✅ Prevents overwriting (checks if file exists)
5. ✅ Outputs confirmation + filepath

**No manual date entry needed.**

---

## Workflow

**Every Friday @ EOD**:
```powershell
New-WeeklyReflection  # Creates 2026-05_Week_2_Reflection.md
# Takes 2 minutes to fill in
```

**Month-end (May 31)**:
```powershell
New-MonthlyRetrospective  # Creates 2026-05_Retrospective.md
# Takes 90 minutes to complete
```

**Quarter-end (June 30)**:
```powershell
New-QuarterlyReview  # Creates 2026_Q2_Quarterly_Review.md
# Takes 2-3 hours to complete
```

---

*Scripts handle the grunt work; you focus on reflection.*
