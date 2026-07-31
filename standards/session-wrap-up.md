---
type: strategy
subtype: skill-prompt
title: "Session Wrap-Up"
description: "Portable skill prompt for closing an AI-assisted work session with documentation, validation, and explicit handoff state."
status: active
version: "1.0"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-08
---

# Skill: Session Wrap-Up

## Purpose

Use this skill at the end of a discrete body of repository work. The goal is to
update durable documentation, capture pending decisions, validate the work, and make
the next session easier to start.

This skill does not assume that every session ends with a commit or push. Commit and
push only when the user asks, when the repository contract requires it, or when the
current task explicitly includes publication.

## Required Inputs

Gather what is available:

- Current diff and file status.
- User's requested outcome for the session.
- Repository session-log format (see `standards/repo-baseline.md`).
- README or other documentation affected by the work.
- Validation commands appropriate to the changed files.
- Commit or push instruction, if provided.

## Preflight

1. Inspect working-tree status.
2. Separate changes made in this session from unrelated pre-existing changes when
   possible.
3. Review the user request and any later user corrections.
4. Identify which durable docs need updates.
5. Choose focused verification before writing the final report.

## Documentation Procedure

### 1. Update Durable Context

Update only documents that the work actually changed or that future sessions need:

- `SESSION_LOG.md` for substantive work.
- `README.md` when navigation, usage, or folder structure changed.
- `SECURITY.md` when the work affected the security surface.

Do not turn every closeout into a broad documentation rewrite.

### 2. Write the Session Log Entry

Follow the format in `standards/repo-baseline.md`:

```markdown
## YYYY-MM-DD: <Short Title>

**Status:** Completed

**Files changed:** `<path>`, `<path>`

**Summary:**
<2 to 5 sentences describing what changed and why.>

**Decisions Made:**

- <Decision and rationale.>

**Verification:**

- <Check performed and result.>

**Next Steps:**

- <Concrete next action, or None.>
```

Record deferred items clearly. A future session should be able to see what was
intentionally left undone.

### 3. Validate

Run targeted checks based on the change:

- Code changes: lint, tests, render checks, or smoke checks.
- Markdown or documentation changes: `git diff --check`, structure checks.
- Security changes: scanner output, dependency audit, or manual evidence notes.

If a check cannot be run, state why.

### 4. Commit and Push Boundary

Before committing:

1. Review `git status --short --branch` and confirm no data files are staged
   (see `standards/data-handling.md`).
2. Review the staged diff or summarize it.
3. Stage only files that belong to the completed work.
4. Use a descriptive commit message.

Push only when requested or required. If pushed, report the commit hash and remote
branch.

## Final Report

End with:

- What changed.
- What was documented.
- Verification performed.
- Commit and push status.
- Remaining next steps.

Keep the final report brief and specific. Do not include a long transcript of command
output unless the user asked for it.

## Quality Checklist

- [ ] Durable docs were updated when needed.
- [ ] Deferred work and next steps were recorded.
- [ ] Validation matched the work.
- [ ] User changes outside the task were preserved.
- [ ] No data files were staged or committed.
- [ ] Commit and push followed explicit instruction or repository policy.
- [ ] Final report included current branch and clean or dirty status.
