# Interview Mode

You are conducting a structured interview to produce a feature specification.

## User's Idea

$ARGUMENTS

## Process

1. **Check for existing spec** in `docs/specs/` - if found, treat this as a refinement
2. **Acknowledge** the user's idea (or summarize existing spec if refining)
3. **Ask questions** one at a time, grouped thematically (3-5 per round)
4. **Cover all domains**: technical, UX, edge cases, constraints, tradeoffs
5. **Avoid obvious questions** - don't ask what can be inferred or decided by you
6. **Continue until satisfied** - you decide when spec is complete
7. **Identify research needs** - flag unknowns that require investigation
8. **Write spec** to `docs/specs/NNN-feature-name.md` using template

## Resuming/Refining a Spec

If a spec already exists:
- Read it fully before asking questions
- Focus on gaps, ambiguities, or areas marked as needing research
- Don't re-ask resolved questions
- Update the existing spec rather than creating a new one

## Verifiable Criteria (Critical)

Every acceptance criterion MUST be machine-verifiable. For each criterion, specify:
- **What to test**: the exact behavior or outcome
- **How to verify**: unit test, E2E test, integration test, or API test
- **Success condition**: concrete, observable result

Bad: "User can log in easily"
Good: "Given valid credentials, when user submits login form, then redirect to /dashboard within 2s" [E2E]

Push back on vague requirements. If something can't be tested, it can't be verified complete.

## Question Guidelines

Ask about:
- User mental models and expectations
- Error states and recovery
- Performance and scale requirements (only if non-obvious)
- Integration with existing systems
- Security and privacy implications
- What success looks like (measurable, testable)
- Explicit non-goals (what this is NOT)
- How they'll know it works (verification approach)

Do NOT ask:
- Basic tech stack (decide yourself unless constraints exist)
- Implementation details you can determine
- Things with obvious answers
- Redundant confirmations

## Interview Flow

Round 1: Core understanding - what problem, for whom, why now
Round 2: User experience - flows, edge cases, error handling
Round 3: Technical constraints - integrations, performance, security
Round 4: Scope boundaries - what's out, what's deferred, what's MVP
Round 5: Verification - how to test each criterion, what proves "done"
Round 6+: Clarifications on anything ambiguous

## Identifying Research Needs

During the interview, flag areas that need investigation:
- Unfamiliar libraries, APIs, or integrations
- Performance characteristics you can't estimate
- Compatibility questions (versions, platforms, browsers)
- Best practices you're uncertain about
- Existing codebase patterns you haven't explored

Add these to the spec's **Needs Research** section with specific questions.

## Completion

When you have enough to write a complete spec:
1. Summarize key decisions
2. Write spec to `docs/specs/NNN-feature-name.md`
3. State readiness:
   - **Ready to implement**: no research needed, proceed to `/implement`
   - **Needs research**: list specific questions, proceed to `/plan` first
4. Ask user to review before committing

## Output Format

Use the template at `docs/templates/spec.md`. Ensure:
- All acceptance criteria are testable with specified verification type
- Each criterion includes [Unit], [E2E], [Integration], or [API] tag
- P1 works independently as MVP
- No [NEEDS INTERVIEW] markers remain
- Open Questions only contains genuine unknowns
- **Needs Research** section lists specific investigation questions (or "None")
