---
name: ux-evaluate
description: Run a UlissesXavier UX/UI evaluation of the app in this project — the full sweep, or a focus such as "only the dashboard", "only typography and spacing", "only mobile", "only what changed in this branch". Delegates to the ulissesxavier agent and relays its questions to you until the report and PDF are done.
argument-hint: "[focus]"
disable-model-invocation: true
---

# Run a UlissesXavier evaluation

You are the **main session**. The evaluation itself runs in the
`ulissesxavier` agent (a subagent, so its screenshots and measurements stay
out of this conversation). Your job is to start it, answer its questions
through the developer, and hand back the result. Speak to the developer in
the language they are using.

Focus requested: `$ARGUMENTS` (empty means the full sweep).

## 1. Before delegating

- **Profile.** If `.claude/ux-profile.md` does not exist, tell the developer
  in one line and offer to run the `ux-profile` skill first (a short
  interview, recommended). If they decline, delegate anyway: the agent's
  first run becomes a discovery run that drafts the profile and returns
  questions.
- **Test account.** If the profile says the credentials are "given in the
  chat" and the developer has not given them, ask once. Never write a
  password to a file, a memory or a commit; pass it only in the delegation
  prompt.

## 2. Delegate

Start the agent with the Agent tool, `subagent_type: "ulissesxavier:ulissesxavier"`
(or `"ulissesxavier"` when it is installed in the project, not as a plugin).
It does not see this conversation **nor the project's `CLAUDE.md`**, so the
prompt must stand on its own:

- the focus (or "full sweep"), and the language to write in;
- the test-account credentials, if given;
- anything the developer said in this conversation that the evaluation
  needs — a recent change to check, a screen to skip, a decision to respect
  (quote it, with the file where it is recorded).

## 3. While it runs: `NEEDS INPUT`

If the agent's reply starts with **`NEEDS INPUT`**, the evaluation is
paused, not finished:

1. Ask the developer its questions with **AskUserQuestion** — at most four
   per call, with the options the agent listed (recommended first).
2. **Resume the same agent** with SendMessage (`to` = its id or name),
   passing the answers. Do not start a new agent: the paused one keeps its
   progress.
3. Repeat until it returns a finished report. If the developer gives up,
   tell the agent so it can stop the servers it started (`serve.sh down`).

## 4. Hand back

Give the developer, briefly: the run folder (`feedback/<date>/vN-<focus>/`),
the paths of the report (`.md`) and the PDF,
the headline, the most urgent problems, and what the agent said it could not
verify. Do not paste the report.
