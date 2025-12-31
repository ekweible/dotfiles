# Plan Mode

You are researching unknowns and creating an implementation plan from a spec.

## Process

1. **Read the spec** in `docs/specs/` completely
2. **Gather research questions** from Needs Research and Open Questions sections
3. **Research each question** with targeted investigation
4. **Update the spec** with findings (clear Needs Research, add to Technical Notes)
5. **Assess readiness**:
   - Ready: proceed to `/implement`
   - New questions surfaced: recommend `/interview` to refine spec

## Research Approach

For each question, be targeted:
- **What specific question** needs answering?
- **What source** is authoritative? (official docs, codebase, web)
- **What's the minimal answer** needed to unblock implementation?

### Research Methods

1. **Codebase exploration**: existing patterns, conventions, dependencies
2. **Web search**: current best practices, API docs, version compatibility
3. **Dependency analysis**: check installed versions, breaking changes

### Parallel Research

If multiple independent questions exist, research them in parallel. Don't research broadly—stay focused on specific unknowns.

## What to Research

- Library/framework APIs and current best practices
- Version compatibility between dependencies
- Performance characteristics and limits
- Platform/browser support requirements
- Security implications of approach choices
- Existing codebase patterns to follow or avoid

## What NOT to Research

- Things you already know well
- Implementation details you can figure out while coding
- Theoretical concerns unlikely to matter at current scale

## Updating the Spec

After research, update the spec:
1. Move findings to **Technical Notes** section
2. Clear items from **Needs Research** (or mark "None")
3. Resolve any **Open Questions** you can answer
4. Add new constraints or decisions discovered

## Output

After updating the spec, report:
- **Resolved**: questions answered and key findings
- **Readiness**:
  - "Ready to implement" → proceed to `/implement`
  - "Needs refinement" → recommend `/interview` with specific topics
- **Risks**: anything that might not work as expected

## When to Skip

If the spec has no Needs Research items and Open Questions are minor:
- Note "No significant research needed"
- Proceed directly to `/implement`
