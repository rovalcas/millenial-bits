# scripts/New-WeeklyReflection.ps1

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
$week = [math]::Ceiling($WeekOf.Day / 7)
$weekFormatted = [string]$week
if ($weekFormatted.Length -eq 1) { $weekFormatted = "0$weekFormatted" }

$dateRange = "$($WeekOf.ToString('MMMM d'))-$($WeekOf.AddDays(6).ToString('d, yyyy'))"
$filename = "$year-$month`_Week_$weekFormatted`_Reflection.md"

$reposPath = "C:\Users\roman.castro\Source\Personal\millenial-bits"
$filePath = Join-Path $reposPath "memories" $filename

if (Test-Path $filePath) {
    Write-Host "⚠️  File already exists: $filename"
    Write-Host "📁 Path: $filePath"
    return
}

$content = @"
# Weekly Reflection: Week of $dateRange

**Status**: Completed
**Projects Touched**: 
**Audience**: Private / Sanitized / Shareable
**Team insight candidate**: yes/no
**Evidence/source**: reflection / project lesson / decision / observed pattern

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

## Shareable Signals

- Team-useful lesson:
- Needs sanitizing:
- Possible newsletter item:

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

New-Item -Path $filePath -ItemType File -Value $content -Force | Out-Null
Write-Host "✅ Created: $filename"
Write-Host "📁 Path: $filePath"
Write-Host ""
Write-Host "Remember to update:" -ForegroundColor Cyan
Write-Host "  • memories/REFLECTIONS_INDEX.md (add new entry)"
Write-Host "  • Mark Audience and Team insight candidate"
Write-Host "  • Fill in sections during Friday EOD"
