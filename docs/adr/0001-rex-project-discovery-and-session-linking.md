# ADR-0001: Discover Rex projects live and persist session links

Date: 2026-11-18

Status: accepted

## Context

Rex Projects needs to find local checkouts and reopen their sessions. The previous picker registered one action per directory from a cache, so discovery changes required a refresh and config reload. A session's visible name and a terminal pane's current directory can both change while the session is open.

## Decision

**Open Project** reads the ranked directory list from zoxide when the picker opens and asks Git for worktrees after a project is selected. Rex provides the picker and filters the supplied rows. Project discovery has no separate cache.

Loading `projects.lua` registers the picker with no required setup. By default, Projects accepts zoxide directories outside `~/.rex/worktrees`. The caller can narrow this list with `setup { roots = { ... }, bookmarks = { ... } }`. Roots include their descendants and bookmarks match exact directories. The Rex config supplies its preferred locations in `init.lua`, keeping those choices out of the picker logic.

The checkout's absolute path identifies the work, and the Rex session ID identifies the session to reopen. Projects stores one session ID per checkout in `$XDG_STATE_HOME/rex/project-sessions.json`, defaulting to `~/.local/state/rex/project-sessions.json`. Each session is eligible to link to one checkout, even when it contains panes in several checkouts.

## Alternatives considered

- **Cache discovery and generate palette actions.** This kept opening fast at the cost of a refresh command and reload whenever the list changed.
- **Match by session name or pane directory alone.** Names can collide or change. A pane directory can help find a session once, but relying on it for every selection makes a simple `cd` change which session Projects finds.

## Consequences

- Session links survive session renames and pane directory changes. Closing a session leaves a stale ID, which is replaced when the checkout is linked again.
- A session already linked to one checkout is excluded when linking a different checkout. A workspace with several worktrees therefore has only one checkout associated with it in Projects.

## How to apply this

- Reuse a saved session ID when it is still open. Otherwise, look for an unlinked session with a local terminal whose foreground process is at the exact checkout root. Link a sole match automatically and ask which one to use if several match.
- With zero matches and at least one unlinked session, offer **Create session** and **Link existing session**. Linking switches to the selected session with its panes as they are. For example, linking a checkout named `experiment` to a session whose pane is in `test` opens that pane in `test`. Creating a session starts a shell at the selected checkout root.

## Revisit when

- Rex exposes durable checkout metadata on sessions, or Projects needs to target individual panes in a session shared by several checkouts.

## Links

- [Rex Projects configuration](../../configs/rex/.config/rex/projects.lua)
- [Rex configuration and project locations](../../configs/rex/.config/rex/init.lua)
