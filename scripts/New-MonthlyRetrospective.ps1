# scripts/New-MonthlyRetrospective.ps1

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
    Write-Host "⚠️  File already exists: $filename"
    Write-Host "📁 Path: $filePath"
    return
}

[datetime]$monthStart = "$Month-01"
$monthName = $monthStart.ToString("MMMM yyyy")
$daysInMonth = [DateTime]::DaysInMonth($monthStart.Year, $monthStart.Month)

$content = @"
# Monthly Retrospective: $monthName

**Period**: $Month-01 to $Month-$daysInMonth
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

New-Item -Path $filePath -ItemType File -Value $content -Force | Out-Null
Write-Host "✅ Created: $filename"
Write-Host "📁 Path: $filePath"
Write-Host ""
Write-Host "Remember to:" -ForegroundColor Cyan
Write-Host "  • Update memories/REFLECTIONS_INDEX.md"
Write-Host "  • Compare with previous month"
Write-Host "  • Reference related decisions/ponderings"
