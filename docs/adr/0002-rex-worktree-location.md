# ADR-0002: Store new Rex worktrees under ~/.rex/worktrees

Date: 2026-11-18

Status: accepted

## Context

Projects needs a predictable place to create linked worktrees. Zoxide can learn those directories as they are visited. When a worktree lives under any configured project root, it can appear in both project and worktree pickers.

## Decision

Create worktrees at `~/.rex/worktrees/<name>/<branch>`. This gives linked checkouts a short, dedicated path that the first picker can exclude regardless of its configured roots.

Use the selected checkout's linked Rex session name when that session is open, then the main checkout's linked session name if available. Otherwise, use the name from Git's `origin`, falling back to the selected directory name. Convert slashes in the name component to hyphens. Slashes in branch names form path components.

Git records the location of every worktree. Projects uses that list to open existing worktrees, including those created outside this directory. It needs no persistent repo-to-folder mapping.

## Alternatives considered

- **Place worktrees beside or inside the repo.** Sibling directories separate repositories by their paths, but add clutter to discovery roots. Nested directories also need care to keep project scanners out of the linked checkouts.
- **Put the central directory under `~/.local/share/rex/worktrees`.** This would also keep linked checkouts out of project discovery. We chose the shorter path because worktree paths are used directly at the shell.
- **Mirror the repo's full location or persist a folder alias per repo.** Either gives each repo a stable folder, at the cost of longer paths or an extra mapping to maintain.

## Consequences

- Projects excludes `~/.rex/worktrees` from the first picker even if zoxide has learned those paths. Git makes them visible in the worktree picker.
- Changing or closing a linked session can change the folder used for future worktrees of the same repo. Git continues to find earlier worktrees where they were created. Repositories with the same resolved name can target the same directory, and Git can reject a conflicting destination.

## How to apply this

- When a branch already has a worktree, open the registered path. When a local branch exists without a worktree, check it out at the new path. Create a branch from the selected checkout's `HEAD` only when the branch name is new.

## Revisit when

- Destination collisions become common, or a predictable shared folder per repo becomes more important than deriving it from the current session.

## Links

- [Rex Projects configuration](../../configs/rex/.config/rex/projects.lua)
- [ADR-0001 on project discovery and session linking](0001-rex-project-discovery-and-session-linking.md)
