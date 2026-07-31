---
type: strategy
subtype: skill-prompt
title: "Session Start"
description: "Portable skill prompt for restoring repository context at the beginning of an AI-assisted work session."
status: active
version: "1.0"
review_owner: BERD AI Pilot Team
last_updated: 2026-07-08
---

# Skill: Session Start

## Purpose

Use this skill at the beginning of a repository work session. The goal is to restore
current context from durable project files before making claims, proposing plans, or
editing files.

## Required Inputs

Gather what is available in the repository:

- `AGENTS.md` or equivalent agent instructions.
- `README.md`.
- `SESSION_LOG.md` or equivalent work log.
- Relevant standards, protocols, or task notes (see `standards/`).
- Current branch and working-tree status.

If a required file is absent, note the gap instead of inventing repository rules.

## Preflight

1. Confirm the repository path and current branch.
2. Inspect working-tree status before pulling, editing, or running broad commands.
3. If the user asked for a clean checkout or remote sync, run the appropriate git
   command only when it is safe and permitted.
4. Preserve uncommitted user changes. Do not reset, discard, or overwrite them.
5. Use the workstation's local date for dates unless a timestamp is explicitly UTC.

## Procedure

### 1. Read Orientation Files

Read the repository's operating files in this order when present:

1. Agent instructions (`AGENTS.md`).
2. README.
3. Top session-log entry.
4. Task-specific standards or protocol documents.

Do not rely on memory if current repository files are available.

### 2. Summarize Current State

Prepare a short working summary before acting:

- Repository purpose and declared pilot tier.
- Current branch and sync status.
- Dirty or clean working tree.
- Latest logged work.
- Pending next steps.
- Known constraints, including the data-handling rules in `standards/data-handling.md`.

### 3. Identify the Task Boundary

Restate only the actionable task boundary, not the entire user prompt. If the user
asked for implementation, proceed after the scan. If the user asked for a scan first,
report findings before editing.

### 4. Select Verification

Choose verification based on the likely work:

- Code changes: project tests, lint, render checks, or smoke tests.
- Markdown or documentation changes: `git diff --check`, link and structure checks.
- Security or dependency work: the checks in `standards/security-audit.md`.

Do not run expensive, networked, or destructive commands unless they are required and
permitted.

## Output

Return a concise session-start note:

```markdown
**Session Context**
Repository: <path>
Branch: <branch and sync status>
Working tree: <clean or summary of changes>
Latest log: <top session-log entry title or gap>
Task boundary: <what will be done now>
Constraints: <most relevant rules>
Verification plan: <targeted checks>
```

## Quality Checklist

- [ ] Current repository files were read before action.
- [ ] Working-tree status was checked.
- [ ] User changes were preserved.
- [ ] Pending items from the latest log were identified.
- [ ] Missing evidence was named as a gap.
- [ ] Verification was matched to the actual task.
