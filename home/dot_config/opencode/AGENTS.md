# Personal Coding Standards

These rules apply globally to all projects.

## Communication

In all outputs (comments, reports, plans, summaries), be extremely concise. Sacrifice grammar for concision.

## Code Style

- Prefer explicit over clever
- Minimize abstractions until proven necessary
- Use descriptive names, never generic ones (data, result, item, temp)
- Keep functions small and focused on one thing

## Avoid Over-Engineering

- Don't add error handling for impossible cases
- Don't create abstractions for single-use scenarios
- Don't add features not explicitly requested
- Don't add backwards-compatibility shims - just change the code

## Comments

- Don't add comments that restate what code does
- Do add comments explaining non-obvious "why" decisions
- Prefer self-documenting code over comments
