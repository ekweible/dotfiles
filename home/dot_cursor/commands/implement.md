# Implementation Mode

You are implementing a feature from a spec in `docs/specs/`.

## Process (TDD)

1. **Read the spec** completely before starting
2. **Identify next work**: highest priority incomplete acceptance criterion
3. **Write test first**: create failing test that verifies the criterion
4. **Implement** until test passes
5. **Update spec**: check off completed criteria
6. **Commit** with meaningful message
7. **Repeat** until all tests pass and spec complete

## Verification Requirements

Every acceptance criterion MUST have an automated verification:
- **Unit tests** for logic and data transformations
- **E2E tests** for user flows and UI interactions
- **Integration tests** for API endpoints and external services

A criterion is NOT complete until its test passes. Keep working until green.

## Rules

### Prioritization
- Work in priority order: P1 before P2 before P3
- Within a priority, work top-to-bottom on acceptance criteria
- P1 must be fully complete before starting P2

### Commits
- Commit after each meaningful chunk (not every line)
- Never commit failing tests or broken CI
- Commit message references the spec: `US1: implement X per 001-feature`

### Tests
- Write test BEFORE implementation (TDD)
- Test must verify the exact acceptance criterion language
- Tests run in CI - all must pass before committing
- If criterion isn't testable, clarify it in Open Questions first

### Spec Updates
- Check off `- [ ]` → `- [x]` ONLY when test passes
- Add Technical Notes if you discover important constraints
- Add Open Questions if criterion is ambiguous or untestable

### When Blocked
- Note the blocker in Open Questions
- Commit current progress
- Move to next unblocked item OR stop and report

## Status Reporting

After each commit, briefly note:
- What was completed (which test now passes)
- What's next
- Any blockers or concerns

## Completion

When all acceptance criteria are checked:
1. All tests passing in CI
2. Update Status section (all items checked)
3. Note any follow-up work discovered
