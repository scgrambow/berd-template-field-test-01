# BERD AI Repository Starter

Portable, clone-and-start repository scaffold for AI-assisted analysis projects.

If you cloned this repository and want to begin immediately, start at Quick Start Option A below.

This starter is intentionally generic:
- Works for new or existing projects.
- Works on macOS, Windows, and Linux.
- Does not depend on any one person's local machine setup.
- Uses repository-local instructions so each new session can recover context.

## Quick Start

### Option A: Start from this repository (recommended)

1. Clone the starter.

```bash
git clone <your-repo-url>
cd berd-ai-repo-starter
```

2. Open the folder in your editor.
3. Start your AI coding agent and send this prompt:

```text
Read BOOTSTRAP.md and follow it to set up this repository.
```

4. Answer the bootstrap interview questions.
5. Review generated files.
6. Commit and continue project work.

### Option B: Copy starter files into an existing repository

Copy everything from this repository root into your existing project root, then run the same bootstrap prompt.

macOS/Linux:

```bash
cp -R /path/to/berd-ai-repo-starter/. /path/to/your-project/
```

Windows PowerShell:

```powershell
Copy-Item -Path C:\path\to\berd-ai-repo-starter\* -Destination C:\path\to\your-project -Recurse -Force
```

Then open your project folder and send:

```text
Read BOOTSTRAP.md and follow it to set up this repository.
```

## Included Files

```text
.
├── BOOTSTRAP.md
├── AGENTS.md
└── standards/
    ├── data-handling.md
    ├── repo-baseline.md
    ├── security-audit.md
    ├── session-start.md
    └── session-wrap-up.md
```

## What Bootstrap Generates

Based on your interview answers and existing files, bootstrap creates or updates:
- README.md
- SESSION_LOG.md
- SECURITY.md
- .gitignore
- Standard folders (for example src or R, docs, output, data guidance)

Bootstrap is additive by design: it should not move, delete, or overwrite user files without confirmation.

Expected workflow: clone or copy starter files, run bootstrap, review generated baseline files, then begin project-specific work.

## Operating Model

- AGENTS.md is the operating contract for agent behavior in the repository.
- standards/ defines baseline file requirements, data handling rules, security review, and session start/wrap procedures.
- Session continuity comes from the repository files themselves, not model memory.

## Notes for Maintainers

If you change BOOTSTRAP.md or standards files, keep this README Quick Start in sync.
