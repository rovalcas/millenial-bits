# scripts/New-QuarterlyReview.ps1

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
    Write-Host "⚠️  File already exists: $filename"
    Write-Host "📁 Path: $filePath"
    return
}

$content = @"
# Quarterly Review: $Quarter

**Period**: 
**Overarching Theme**: 
**Audience**: Private / Sanitized / Shareable
**Team insight candidates**:
**Evidence/source**: monthly retros / decisions / work patterns / team feedback

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

## Shareable Synthesis

- Patterns to teach:
- Decisions worth broadcasting:
- Practices to recommend:
- Private context to remove:

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

## Looking Ahead to Next Quarter

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

New-Item -Path $filePath -ItemType File -Value $content -Force | Out-Null
Write-Host "✅ Created: $filename"
Write-Host "📁 Path: $filePath"
Write-Host ""
Write-Host "Remember to:" -ForegroundColor Cyan
Write-Host "  • Update memories/REFLECTIONS_INDEX.md"
Write-Host "  • Promote durable lessons into team-updates/ or work-patterns/"
Write-Host "  • Assess progress on quarterly goals"
Write-Host "  • Set direction for next quarter"
