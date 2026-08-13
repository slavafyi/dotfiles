# Agent rules

## Working style

- Be proactive: inspect the code base and available commands before asking
  obvious questions.
- Do not modify files when the user asks only for information, analysis, or
  advice. Implement changes only when the user explicitly requests them.
- Fix root causes, not symptoms.
- State assumptions and ambiguities explicitly. If multiple reasonable
  interpretations exist, ask or present options instead of choosing silently.
- Keep changes as small as possible. Do not add refactors, abstractions,
  comments, or extra features unless they are requested or clearly necessary.
- Suggest best practices, even if they require refactoring. Do not make
  unrelated refactors without approval.
- Prefer editing existing files and following established conventions unless
  there is a clear reason to do otherwise.
- Be direct and technically accurate. Report blockers clearly.

## Communication

For technical explanations, prefer the principles of ASD-STE100 Simplified
Technical English: clear structure, direct language, and established technical
terminology.

Prefer familiar software engineering terms over newly coined terminology.
Introduce a new term or abstraction only when it helps make the explanation
more precise or easier to discuss.

For general prose and non-technical explanations, prefer the principles of ISO
24495-1 Plain Language: make the main point easy to find, use familiar words,
and avoid unnecessary complexity.

In general, optimize writing for:

1. Accuracy.
2. Clarity.
3. Concision.
4. Established terminology.

Prefer the simplest wording that preserves the important technical detail.

## Implementation

- Choose the simplest implementation that fully meets the current requirements.
- Prefer established, well-maintained libraries and platform features over
  custom implementations. Do not add a dependency for trivial functionality.
- Do not add backward-compatibility code unless required by the task, a
  documented support policy, or known consumers.

## Validation

- After code changes, run the relevant existing validation commands for the
  changed package, workspace, or subproject. Prefer an aggregate existing
  command such as `check`, `ci`, or `validate` when one exists. Otherwise run
  the relevant lint, typecheck, test, build, or format commands. If anything
  remains broken, report the blocker clearly.
- For bug fixes, prefer a failing test or concrete reproducer before changing
  code, when practical.

## Formatting

- For prose in Markdown and other plain-text files, wrap paragraphs at 80
  columns.
- Follow project-specific formatting settings for source code.
- Do not wrap code blocks, tables, URLs, or other format-sensitive content.

## Tooling

- Use `pnpm` for Node.js by default. Translate `npm`/`npx` commands to the
  `pnpm` equivalent unless the project explicitly requires another package
  manager.
- Use `mise` for language runtimes and toolchains such as `node`, `python`,
  `ruby`, `go`, and `rust`.
- Use the system package manager for standalone CLI tools such as `git`, `gh`,
  and `lazygit`.
- For project-specific language versions, add `mise.toml` and run
  `mise install`.

## Environment

- Avoid explicit `bash -lc` or `zsh -lc` wrappers unless a task specifically
  requires those shells. Prefer running commands directly and avoid depending
  on interactive shell setup files when invoking tools.
- On macOS, use OrbStack as the Docker runtime.

## Git

- Use [Conventional Commits](https://www.conventionalcommits.org/).
- Before committing, inspect recent commit history and follow established
  repository-specific scope and subject conventions.
- Do not add a commit body unless asked.
- Follow the classic 50/72 commit message convention: aim for a subject of about
  50 characters. When a body is included, separate it with a blank line and wrap
  it at 72 characters.
- Do not add `Co-authored-by` trailers.
- Use [Conventional Branch](https://conventionalbranch.org/) for branch names.
- Prefer the `feature/` prefix over `feat/`. Before creating a branch, inspect
  available local and remote branch history. Use `feat/` only when the
  repository consistently uses it; when conventions are absent or mixed, use
  `feature/`.
