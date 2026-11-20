---
name: advisor
description: "Seek a second opinion before a consequential decision, when repeated debugging attempts stop narrowing the cause, or when new evidence undermines the current approach. Reconsider during the task if conflicting evidence appears. Use when the advice could change the next action. Skip routine changes and directly verifiable checks."
---

# Advisor

Spawn one subagent in a fresh context for a focused second opinion. The executor owns the task and makes the decision.

When invoked explicitly with `$advisor`, consult immediately using the question supplied or the current decision. Honor an optional leading `medium`, `high`, or `xhigh` as the effort override. For automatic use, consult as soon as initial read-only investigation identifies a consequential decision that advice could change. Reassess when new evidence invalidates a working assumption, debugging stalls, or a specific acceptance criterion remains uncertain after verification. Use one automatic consultation per task, with a second if new evidence materially changes the question.

Choose the advisor from the session's available subagent models. Prefer a clearly stronger model for the question, using the catalog's capability descriptions and any explicitly listed successor. Treat model names, version numbers, catalog order, and effort ceilings as insufficient evidence of capability.

When using a stronger model, match the effort to the question.

- `medium` for a bounded uncertainty where one check could settle it.
- `high` for a consequential choice between plausible approaches or a failure that spans components.
- `xhigh` for a consequential choice with conflicting evidence or interacting constraints that require deeper analysis.

If no available model is clearly stronger, use a fresh instance of the executor's model. For this fallback, take the highest supported single-agent effort (`max` when offered), even for a bounded question. Exclude `ultra` from consultations.

Treat an explicit effort override as a ceiling for either route. Use the requested effort when eligible, or the highest eligible supported effort below it. Use the session's active effort if surfaced or explicitly supplied by the user. With a known active effort, make a same-model call only at a higher effort. Otherwise, take the same-model pass as an independent check.

Pass the selected model and `reasoning_effort` explicitly to the subagent tool. If no eligible consultation can run, continue from the available evidence. For a manual invocation, report the model and effort that actually ran or briefly explain why there was no separate consultation.

Give the advisor the decision, relevant constraints, the strongest evidence for and against the current approach, and enough excerpts to reason independently. Ask for a recommendation, its strongest objection, and one check that could disprove it. Tell the subagent to advise from the supplied evidence without editing files, running commands, or spawning more agents. Wait for the advice before committing to the decision. Verify its claims against the available evidence and use the result to choose the next action.
