---
name: advisor
description: "Get guidance while forming a consequential plan, reconciling findings at an integration point, or deciding whether verification is sufficient. Also use when repeated debugging attempts stall or new evidence undermines the approach. Consult when advice could change the next action. Skip routine changes and directly verifiable checks."
---

# Advisor

Spawn one subagent in a fresh context for a focused second opinion. The executor owns the task and makes the decision.

When invoked explicitly with `$advisor`, consult immediately using the question supplied or the current decision. Honor an optional leading `medium`, `high`, or `xhigh` as the effort override.

For automatic use, consult after initial read-only investigation when advice could change the next action on a consequential decision. Consult early enough to shape the plan. Reassess when findings from separate parts of the work must be reconciled, debugging stalls, or a specific verification gap could change the rollout or completion decision. Use one consultation per consequential decision. Later decisions in the same task can each warrant a call. Revisit the same decision only when new evidence materially changes the question.

Choose the advisor from the session's available subagent models. Prefer a clearly stronger model for the question, using the catalog's capability descriptions and any explicitly listed successor. Treat model names, version numbers, catalog order, and effort ceilings as insufficient evidence of capability.

When using a stronger model, match the effort to the question.

- `medium` for a bounded uncertainty where one check could settle it.
- `high` for a consequential choice between plausible approaches or a failure that spans components.
- `xhigh` for a consequential choice with conflicting evidence or interacting constraints that require deeper analysis.

If no available model is clearly stronger, use a fresh instance of the executor's model. For this fallback, take the highest supported single-agent effort (`max` when offered), even for a bounded question. Exclude `ultra` from consultations.

Treat an explicit effort override as a ceiling for either route. Use the requested effort when eligible, or the highest eligible supported effort below it. Use the session's active effort if surfaced or explicitly supplied by the user. With a known active effort, make a same-model call only at a higher effort. Otherwise, take the same-model pass as an independent check.

Pass the selected model and `reasoning_effort` explicitly to the subagent tool. If no eligible consultation can run, continue from the available evidence. For a manual invocation, report the model and effort that actually ran or briefly explain why there was no separate consultation.

Give the advisor one decision, the relevant constraints, and the primary evidence or pointers needed to start investigating. Include relevant code, contracts, traces, or test output. When workers disagree, include the evidence behind their findings. Include counterevidence that could overturn the executor's current view.

While forming a plan, ask for viable approaches, the constraint that determines the choice, and the first check that would narrow the options. When evaluating a proposed action, ask for a recommendation, its strongest objection, and one check that could disprove it.

Tell the advisor it can choose and use any available tools to investigate within the task's scope and existing permissions. It can inspect the workspace, run tests or diagnostic commands, and search documentation and public community discussions. Ask it to report the evidence it gathered and any remaining uncertainty. The executor owns implementation.

Wait for the advisor's completed result before committing to the decision. If a wait returns while the advisor is still running, wait again for the same agent. If the consultation fails, continue from the available evidence. Verify the advisor's claims and use the result to choose the next action.
