#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/new-reflection.sh weekly [YYYY-MM-DD]
  scripts/new-reflection.sh monthly [YYYY-MM]
  scripts/new-reflection.sh quarterly [YYYY_QN]

Examples:
  scripts/new-reflection.sh weekly
  scripts/new-reflection.sh weekly 2026-06-01
  scripts/new-reflection.sh monthly 2026-06
  scripts/new-reflection.sh quarterly 2026_Q3

Environment:
  REFLECTION_REPO_ROOT  Override repo root, useful for testing.
EOF
}

repo_root() {
  if [[ -n "${REFLECTION_REPO_ROOT:-}" ]]; then
    printf '%s\n' "$REFLECTION_REPO_ROOT"
    return
  fi

  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  cd -- "$script_dir/.." && pwd
}

require_date() {
  if ! date -d "$1" '+%Y-%m-%d' >/dev/null 2>&1; then
    echo "Invalid date: $1" >&2
    exit 2
  fi
}

ensure_memory_dir() {
  local root="$1"
  mkdir -p "$root/memories"
}

write_file() {
  local path="$1"
  local filename
  filename="$(basename "$path")"

  if [[ -e "$path" ]]; then
    echo "File already exists: $filename"
    echo "Path: $path"
    exit 0
  fi

  cat > "$path"
  echo "Created: $filename"
  echo "Path: $path"
}

generate_weekly() {
  local root="$1"
  local input_date="${2:-}"
  local week_of

  if [[ -n "$input_date" ]]; then
    require_date "$input_date"
    week_of="$(date -d "$input_date" '+%Y-%m-%d')"
  else
    week_of="$(date -d 'monday this week' '+%Y-%m-%d')"
  fi

  local year month day week week_formatted end_date date_range filename file_path
  year="$(date -d "$week_of" '+%Y')"
  month="$(date -d "$week_of" '+%m')"
  day="$(date -d "$week_of" '+%-d')"
  week="$(((day + 6) / 7))"
  week_formatted="$(printf '%02d' "$week")"
  end_date="$(date -d "$week_of +6 days" '+%Y-%m-%d')"
  date_range="$(date -d "$week_of" '+%B %-d')-$(date -d "$end_date" '+%-d, %Y')"
  filename="${year}-${month}_Week_${week_formatted}_Reflection.md"
  file_path="$root/memories/$filename"

  ensure_memory_dir "$root"
  write_file "$file_path" <<EOF
# Weekly Reflection: Week of $date_range

**Status**: Completed
**Projects Touched**:
**Audience**: Private / Sanitized / Shareable
**Team insight candidate**: yes/no
**Evidence/source**: reflection / project lesson / decision / observed pattern

## Wins This Week

- [ ]
- [ ]
- [ ]

## Blockers Encountered

- **Blocker 1**: Description -> Resolution/Status

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
EOF

  echo ""
  echo "Remember to update:"
  echo "  - memories/REFLECTIONS_INDEX.md (add new entry)"
  echo "  - Mark Audience and Team insight candidate"
  echo "  - Fill in sections during Friday EOD"
}

generate_monthly() {
  local root="$1"
  local month="${2:-$(date '+%Y-%m')}"

  if [[ ! "$month" =~ ^[0-9]{4}-[0-9]{2}$ ]]; then
    echo "Invalid month: $month. Expected YYYY-MM." >&2
    exit 2
  fi

  require_date "$month-01"

  local month_name days filename file_path
  month_name="$(date -d "$month-01" '+%B %Y')"
  days="$(date -d "$(date -d "$month-01 +1 month" '+%Y-%m-01') -1 day" '+%d')"
  filename="${month}_Retrospective.md"
  file_path="$root/memories/$filename"

  ensure_memory_dir "$root"
  write_file "$file_path" <<EOF
# Monthly Retrospective: $month_name

**Period**: $month-01 to $month-$days
**Primary Focus**:
**Sessions**:
**Audience**: Private / Sanitized / Shareable
**Team insight candidates**:
**Evidence/source**: weekly reflections / decisions / ponderings / work patterns

## Big Picture

### Goals Set

- [ ] Goal 1: [Outcome]
- [ ] Goal 2: [Outcome]
- [ ] Goal 3: [Outcome]

### Results

## What Went Well

1. **Win 1**
   - Context:
   - Outcome:
   - Replicable:

## What Was Challenging

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

- **Decision 1**: [Choice] -> File: \`decisions/Decision_Name.md\`

## Open Questions / Explorations

- **Question 1**: [Status] -> File: \`ponderings/Question.md\`

## Team Impact

- What did your work enable for others?
- Feedback received?

## Newsletter Candidates

- What I learned:
- Pattern worth reusing:
- Tooling or agent insight:
- Decision/tradeoff to watch:
- Practical recommendation:
- Open question:

## Next Month's Direction

**Theme**:

### Priorities

1. [ ] Priority 1 & why
2. [ ] Priority 2 & why

### Skills to Develop

- Skill 1: Why is this next?

### Risks / Concerns

- Risk: [What could go wrong?] -> Mitigation: [How to address]

---

## Month-on-Month Comparison

| Aspect | This Month | Last Month | Change |
|--------|-----------|-----------|--------|
| Focus | | | |
| Shipping | | | |
| Learning | | | |

---

*This retro took [time]. Goal: 1-2 hours investment.*
EOF

  echo ""
  echo "Remember to:"
  echo "  - Update memories/REFLECTIONS_INDEX.md"
  echo "  - Draft team-updates/$month.md from sanitized candidates"
  echo "  - Compare with previous month"
  echo "  - Reference related decisions/ponderings"
}

generate_quarterly() {
  local root="$1"
  local quarter="${2:-}"

  if [[ -z "$quarter" ]]; then
    local current_year current_month qnum
    current_year="$(date '+%Y')"
    current_month="$(date '+%-m')"
    qnum="$(((current_month + 2) / 3))"
    quarter="${current_year}_Q${qnum}"
  fi

  if [[ ! "$quarter" =~ ^[0-9]{4}_Q[1-4]$ ]]; then
    echo "Invalid quarter: $quarter. Expected YYYY_QN, for example 2026_Q3." >&2
    exit 2
  fi

  local filename file_path
  filename="${quarter}_Quarterly_Review.md"
  file_path="$root/memories/$filename"

  ensure_memory_dir "$root"
  write_file "$file_path" <<EOF
# Quarterly Review: $quarter

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
| Goal 1 | | | Done / Watch / Missed |

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

- Risk: [What could derail?] -> Mitigation:

### Skill Development Roadmap

**Want to develop**:
- Skill 1:

**Want to deepen**:
- Skill 1:

---

## Quarter-on-Quarter Comparison

| Dimension | This Q | Last Q | Trajectory |
|-----------|--------|--------|------------|
| Shipping velocity | | | Up / Same / Down |
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
EOF

  echo ""
  echo "Remember to:"
  echo "  - Update memories/REFLECTIONS_INDEX.md"
  echo "  - Promote durable lessons into team-updates/ or work-patterns/"
  echo "  - Assess progress on quarterly goals"
  echo "  - Set direction for next quarter"
}

main() {
  local kind="${1:-}"
  local value="${2:-}"

  if [[ -z "$kind" || "$kind" == "-h" || "$kind" == "--help" ]]; then
    usage
    exit 0
  fi

  local root
  root="$(repo_root)"

  case "$kind" in
    weekly)
      generate_weekly "$root" "$value"
      ;;
    monthly)
      generate_monthly "$root" "$value"
      ;;
    quarterly)
      generate_quarterly "$root" "$value"
      ;;
    *)
      echo "Unknown reflection type: $kind" >&2
      usage >&2
      exit 2
      ;;
  esac
}

main "$@"
