# Agent rules

## Defaults and scope

Implementation, tooling, and Git preferences below apply unless the task or
repository sets a different requirement. These preferences do not themselves
authorize unrelated changes or software installation.

## Working style

- For repository tasks, inspect relevant code, configuration, and documentation
  before asking for information that may already be available.
- Do not modify files when the user asks only for information, analysis, or
  advice. Implement changes only when the user explicitly requests them.
- If unresolved ambiguity would materially change scope, externally visible
  behavior, or risk, ask before taking actions that depend on it. Continue
  already authorized work that does not depend on the answer. Resolve other
  ambiguities using existing conventions. State only assumptions that affect
  the result.
- Report out-of-scope issues only when they block the task or pose a directly
  related correctness or security risk. Do not fix them without approval.

## Communication

- Use common words and direct sentences. Prefer `use` to `utilize` and `check`
  to `perform a verification`. Avoid idioms and unnecessarily formal wording.
  Keep standard technical terms and code identifiers.
- Explain terms when the user asks for definitions or a beginner-level
  explanation. Briefly define newly coined and project-specific terms when
  introducing them. Do not automatically define standard technical terms.
- When brevity conflicts with correctness or clarity, retain the information
  needed to understand or act on the answer. Remove repetition, optional
  examples, and background first.
- Report blockers explicitly, including what could not be done and why.
- When drafting text that the user is expected to copy and send, such as an
  email, chat message, reply, or issue comment, present the draft as plain text.
  Do not wrap it in Markdown blockquotes, fenced code blocks, or decorative
  separators. Do not add Markdown formatting inside the draft unless the user
  asks for it. Put explanations before or after the draft.

## Implementation

- Choose the simplest implementation that meets the requirements and, for bug
  fixes, addresses the established cause. Minimize scope rather than optimizing
  only for line count. Do not add unrelated refactors, abstractions, comments,
  or features.
- Prefer editing existing files and following established conventions unless
  there is a clear reason to do otherwise.
- Prefer suitable platform features and standard libraries, then existing
  project dependencies. Add a new, maintained dependency only when the current
  task justifies it and it reduces nontrivial custom implementation work.
- Do not add backward-compatibility code unless required by the task, a
  documented support policy, or known consumers.

## Validation

### Tests

- Use TDD for new or changed behavior and bug fixes with defined requirements.
- Initial project and test-runner setup do not require a failing test.
- User-approved exploratory prototypes may be written before tests. Test any
  retained product functionality before declaring it complete.
- Base test expectations on requirements or documented behavior. Do not adjust
  them merely to make the current implementation pass.
- If a required test cannot run, report the blocker and agree with the user on
  test setup or an alternative check before changing production code.

### Checks

- After code or configuration changes, run existing validation for the affected
  package, workspace, or subproject. Prefer a documented aggregate command when
  it covers that scope. Otherwise run the relevant lint, typecheck, test, build,
  or format commands.
- Once the relevant checks pass, repeat or broaden validation only after
  further changes, new failures, or a specific unresolved concern.
- Inspect unfamiliar command definitions before running them. Do not run
  installation, deployment, publishing, or destructive steps without
  authorization.
- Report which checks ran, which failed, and which could not be run, with reasons.

## Tooling

- Use `pnpm` for Node.js package management and package execution instead of
  `npm`/`npx`.
- Use `mise` for language runtimes and toolchains such as `node`, `python`,
  `ruby`, `go`, and `rust`.
- Respect existing project version configuration. Add or change runtime
  configuration only when required by the task. When introducing runtime
  version configuration, use `mise.toml`.
- Use the system package manager for standalone CLI tools such as `git`, `gh`,
  and `lazygit`.
- When executing commands in this macOS environment, use GNU syntax for standard
  Unix utilities. GNU variants are installed through Homebrew `gnubin`. In
  scripts, follow the project's supported platforms instead of assuming GNU
  utilities are available on every target.
- When an answer depends on current releases or version-specific behavior,
  check official documentation or the installed project sources. When
  searching, include the name as written by the user. If verification is
  unavailable, state the limitation.
- For project searches, use available indexed search tools before shell search.
  Use shell search when indexed search is unavailable or files are outside the
  index. Read known files directly. When locating files, request filenames
  before contents.
- For shell searches, exclude `*.map` and minified files unless they are the
  target. Limit total output size and line width. With `rg`, use `-l` when
  locating files and `--max-columns` when returning matching lines.
- Before using Docker, check the current context and daemon availability. Use
  the selected working environment. Ask if a choice or switch is needed and
  the task or repository does not specify the environment.

## Git

- Before committing, inspect recent commit history. Follow documented repository
  requirements, then consistent existing conventions. If neither establishes a
  convention, use [Conventional Commits](https://www.conventionalcommits.org/).
- Omit a commit body unless the user asks for one or the repository requires it.
- Follow the classic 50/72 commit message convention: aim for a subject of about
  50 characters. When a body is included, separate it with a blank line and wrap
  it at 72 characters.
- Before creating a branch, inspect available local and remote branch names.
  Follow repository requirements, then consistent existing conventions.
  Otherwise use [Conventional Branch](https://conventionalbranch.org/).
  For feature branches, use `feature/` when conventions are absent or mixed.
