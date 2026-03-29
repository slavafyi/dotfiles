# Agent skills workspace

- This directory is an authoring workspace for portable open-format skills.
- Keep each skill self-contained under `skills/<name>`.
- A copied skill should still work outside this repo with only its own files.
- Put runtime dependencies and standalone scripts in the skill package, not the workspace root.
- Keep root `package.json`, `eslint.config.ts`, and `tsconfig.json` limited to shared authoring tooling.
- Prefer plain Node scripts with native TypeScript stripping and avoid repo-relative imports from skills.
