# Changelog

Every release of the UlissesXavier plugin, newest first. The version is the
one in `plugins/ulissesxavier/.claude-plugin/plugin.json`; Claude Code
delivers an update only when that number changes. Versions follow
[Semantic Versioning](https://semver.org): **major** when something you
relied on stops working the same way (a command renamed, the report folder
moved, a profile field changed meaning), **minor** for new capabilities,
**patch** for fixes and wording.

## [1.0.0] — 2026-10-14

First public release.

- `ulissesxavier` agent: walks the running web app in Chrome, measures it
  (WCAG 2.2 contrast and target size, Core Web Vitals, type, spacing, radius
  and color inventory, keystrokes per task), judges charts by visualization
  theory, and writes a prioritized report with 1–5 scores and "what it takes
  to reach 5". Every finding cites research, a standard or a major player's
  published guidelines.
- `/ulissesxavier:ux-evaluate [focus]`: starts an evaluation, relays the
  agent's questions (login, servers, choices) and resumes it where it
  stopped.
- `/ulissesxavier:ux-profile`: short interview that writes the project's
  `.claude/ux-profile.md`.
- `ux-serve`: starts the app's servers for the evaluation and stops only
  what it started.
- `ux-audit`: in-page measurement kit (contrast, targets, visual-system
  inventory, Core Web Vitals, color-blindness, zoom, text spacing,
  pseudo-localization, slow/offline network, phone and tablet viewports).
- `ux-report-pdf`: one markdown report and a designed PDF with charts, a
  plain-language concept guide and numbered references.
- Reports go to `feedback/<date>/vN-<focus>/` (only the `.md`, the `.pdf`
  and `img/`), with an index in `feedback/README.md`.
- Psychology and emotion: every top task is also walked through what the
  person expects, notices, must remember, feels and is pushed to decide, with
  the task's worst moment and its end marked; a new "psychological fit"
  score; 36 peer-reviewed, standard and major-player sources (Norman,
  Lindgaard, Tuch/Google, Fogg/Stanford, Pirolli & Card, Cowan, Kahneman,
  self-determination theory, W3C COGA, Material 3 Expressive research…) and
  their plain-language entries in the concept guide. What only real people
  can confirm becomes a user-testing question with SAM, PANAS or AttrakDiff.
- The agent does not load the evaluated project's `CLAUDE.md` (it greps the
  decisions it needs), which cut its starting context per call by about
  two thirds on a large project.
