# Copilot Instructions for Personal Tech Life Repo

This repository documents your professional journey, learning, and technical work across multiple projects and domains.

## Repository Purpose

**Not** a production codebase. This is a personal knowledge management system for capturing your tech life: reflections, decisions, learnings, and work patterns.

## File Classes & Conventions

### Memories (./memories/)
- Retrospectives on completed projects
- Lessons learned from failures and successes
- Weekly/monthly/quarterly reviews
- Decision outcomes (what happened after you chose option X?)
- Format: Markdown with dates; captures signal quickly

### Decisions (./decisions/)
- Tool/technology evaluations
- Architectural choices with tradeoffs
- Strategic choices with review dates
- Format: Question → Options → Rationale → Outcome

### Ponderings (./ponderings/)
- Open research questions
- Experimental ideas and explorations
- Status: pending/exploring/resolved
- Format: Question-focused; when resolved, converts to decision

### Contemplations (./contemplations/)
- Career reflections and inflection points
- Learning strategy decisions
- Personal observations about work style
- Format: Reflective, honest voice

### Projects (./projects/)
- **active/** - Current work with context and blockers
- **archived/** - Completed projects with retrospectives
- Use sparingly; prefer decisions/ponderings for capturing work

### Learning (./learning/)
- Skills in progress
- Learning paths and roadmaps
- Resources used and progress tracking

### Work Patterns (./work-patterns/)
- Observations about your habits and engagement
- Productivity patterns
- Energy levels and sustainable pace
- Self-knowledge that informs decisions

### Team Updates (./team-updates/)
- Sanitized monthly summaries for teammates
- Newsletter-style digests from reflections, decisions, and ponderings
- Format: actionable lessons, reusable patterns, practical recommendations, open questions
- Keep raw personal reflection private; share generalized patterns and source links

## Reflection System

This repo includes automated reflection generators:
- **Weekly**: 15-minute check-in on wins/blockers/metrics
- **Monthly**: 90-minute retrospective with pattern analysis
- **Quarterly**: 2-3 hour strategic assessment
- **Annual**: Full year trajectory review

See `REFLECTION_SYSTEM.md` for setup and workflow.

## When Working with This Repo

- Use markdown for all entries
- Link related items (decisions → ponderings → learnings)
- Keep entries honest and complete
- Regular reflection cycle (weekly → monthly → quarterly)
- Mark sharing boundaries with Audience and Team insight candidate fields
- Convert the strongest sanitized insights into `team-updates/`
- Archive systematically with retrospectives

## AI Tool Context

This repository is designed to be compatible with:
- GitHub Copilot CLI & Copilot in IDEs
- Claude (Code/Chat)
- Cline and other AI assistants

Each session can reference this file and the INDEX.md to understand context and find related work.
