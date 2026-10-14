# UlissesXavier

**A UX/UI evaluator for Claude Code that doesn't give opinions: it measures and cites.**

[Versão em português](README.md)

UlissesXavier opens your web app in Chrome, walks every screen and gesture,
tries to break it, measures what can be measured, and writes a report with
1–5 scores per area, problems ranked by priority and, for every score,
**what it takes to reach 5**.

The rule that defines it: **no source, no finding.** Every claim carries the
evidence (what it did, the number it measured, the screenshot) and the basis
(the principle, with its reference). References are standards and
peer-reviewed research (WCAG 2.2, CHI, IEEE VIS) and the published guidelines
of the field's major players (Apple HIG, Google's Material and web.dev,
Figma, Canva, Nielsen Norman Group, Baymard, GOV.UK). What it suspects but
cannot ground does not become a problem: it becomes a question for user
testing.

## What it evaluates

| Area | How | Basis |
|---|---|---|
| Usability | each persona's real tasks, heuristics, a novice's cognitive walkthrough | Nielsen & Molich; Shneiderman; Wharton et al. |
| Effort | steps and predicted time per task | Keystroke-Level Model (Card, Moran & Newell) |
| Perceived speed | LCP, INP, CLS and long tasks measured in the browser | Core Web Vitals (web.dev) |
| The five states | ideal, empty, error, partial, loading — with slow network and failures simulated | UI Stack (Hurff); NN/g |
| Accessibility | contrast, targets, keyboard, focus, reflow at 320 px, text spacing, 200% zoom | WCAG 2.2; WAI-ARIA APG |
| Color vision | the screen through a physiological CVD simulation | Machado, Oliveira & Fernandes (IEEE TVCG 2009) |
| Visual system | sizes, weights, spacing, radii, colors, durations, icons — and the proposed scale as tokens | modular scale; 8-pt grid; W3C Design Tokens |
| Hierarchy | squint and grayscale tests | Treisman; Healey & Enns; NN/g |
| Charts and tables | channel × data type, ink, lie factor, color scales | Bertin; Mackinlay; Munzner; Tufte; Few |
| Forms and copy | validation, labels, error messages | Baymard; Wroblewski; GOV.UK; NN/g |
| Ethics | deceptive patterns in sign-up, consent, plans and cancellation | Gray et al. (CHI 2018); Mathur et al. (CSCW 2019) |
| Translation | pseudo-localization: what clips when text grows | W3C i18n; Microsoft |
| AI features | calibrated trust, provenance, manual override | Google PAIR |
| Psychology and emotion | what people expect, what they miss, what they must keep in mind, what they feel (first impression, trust, waiting, the worst moment and the end of each task) and what pushes their decisions | Norman (*Emotional Design*); Lindgaard et al.; Tuch et al. (Google); Fogg et al. (Stanford); Pirolli & Card; Cowan; Kahneman; Peters, Calvo & Ryan; W3C COGA |

## Install

Requires [Claude Code](https://code.claude.com) and the
[Claude in Chrome](https://code.claude.com/docs/en/chrome) extension connected.

```
/plugin marketplace add MatheusAraripe/UlissesXavier
/plugin install ulissesxavier@ulissesxavier
```

### Automatic updates

Claude Code updates a plugin by itself only when auto-update is on for its
marketplace, and for third-party marketplaces it starts **off**. Turn it on
once:

1. In Claude Code, type `/plugin`.
2. Open **Marketplaces** and choose **ulissesxavier**.
3. Select **Enable auto-update**.

From then on, after the first message of a session, Claude Code checks for
new versions in the background and tells you
`Plugin updated: ulissesxavier · Run /reload-plugins to apply`. The new
version applies after `/reload-plugins` or in your next session. What
changed in each version is in the [CHANGELOG](CHANGELOG.md).

To update by hand, without auto-update:

```
/plugin marketplace update ulissesxavier
```

## Use

**1. First time in a project: the profile.** The evaluator needs to know who
uses the product. Run:

```
/ulissesxavier:ux-profile
```

The skill scans the repository (README, routes, sign-up fields, copy,
locales), shows its hypothesis about the audience and asks **a few short
questions** for what the code cannot tell: the main user, their experience,
device, the task that must be effortless, what the evaluator must never
touch.

**Where you answer:** in the Claude Code chat itself, as multiple-choice
questions (with a free-text option). Three paths, all ending in the same
file, `.claude/ux-profile.md`:

| Path | What happens |
|---|---|
| `/ulissesxavier:ux-profile` | The skill asks you directly in the chat and writes the profile. |
| Calling the agent with no profile | The agent runs in the background and can't talk to you: it scans the project, drafts the profile and hands the questions to the main Claude session, which asks them in the chat and calls the agent again with your answers. |
| Editing the file | `.claude/ux-profile.md` is plain markdown; what is written there wins over any inference. |

**2. Ask for the evaluation** — with the command, with or without a focus:

```
/ulissesxavier:ux-evaluate
/ulissesxavier:ux-evaluate the checkout only
```

or in plain words:

```
Use the ulissesxavier agent to evaluate the app.
Use ulissesxavier on the checkout only.
Use ulissesxavier on mobile only.
Use ulissesxavier on what changed in this branch only.
```

If something blocks it (a password, a server, a choice only you can make),
it asks you in the chat and carries on where it stopped. It answers **in the
language it was called in** and keeps everything in a folder made to be
browsed:

```
feedback/
  README.md                          index: one row per run, with score and link
  2026-10-14/
    v1-full-sweep/
      ulissesxavier-2026-10-14-v1.md   the report (to refine with your own Claude)
      ulissesxavier-2026-10-14-v1.pdf  the same report, laid out (to read and share)
      img/                             screenshots the report shows
    v2-mobile/                       a second run on the same day
```

The folder can have another name; set it in the profile.

**3. The report as a PDF.** On a full sweep it also exports a designed PDF
(in focused modes, ask: "and export it as PDF"). The document follows the
principles the report itself demands: the essentials in the first two pages
(cover, average score, the three urgencies, the biggest strength), problems
as cards with severity by shape, word and color, charts drawn from the
report's numbers (score by area, severity × effort matrix, visual system
today → proposed, Core Web Vitals, time per task) and numbered references at
the end. A **concept guide** explains in plain words every term, theory and
author cited (the Doherty threshold, Nielsen's heuristics, WCAG…), and the
first mention of each in the text gets a dotted underline linking to its
entry. The report is written once, in markdown; the PDF template reads and
lays it out. Chrome or Edge renders it headless; nothing to install. You can
also export an existing report later: `/ulissesxavier:ux-report-pdf`.
See [the example](examples/maria-view/relatorio-exemplo.pdf) (in Portuguese).

## When it gets stuck, it asks

The agent runs in the background and can't talk to you directly, but it
does not give up on a blocker — a missing password, a server that won't
start, a choice only you can make. It finishes what the blocker doesn't
stop, saves its progress in the report draft, and hands the main Claude
session a ready-made question. Claude asks you in the chat and **resumes
the same agent** with your answer; it carries on where it stopped, with
everything it had already seen. Only your "skip it" ends a part, and the
report says what was left out and why.

## What it doesn't do

- **It doesn't edit your code.** It evaluates, measures and proposes.
- **It doesn't replace testing with people.** One expert inspector finds a
  fraction of the problems (Nielsen & Landauer, 1993), and a language model
  is not a user (NN/g, *Synthetic Users*). Every report ends with what must
  be confirmed with real people.
- **It leaves no trace.** It starts the app's servers itself (each command
  lives in the profile), reuses whatever you already had running without
  closing it, and at the end stops only what it started, whole process tree
  included. Logs and PIDs live in a temp folder outside the repository.
- **It only logs in with the test account you give it.** The natural way is
  to say it in the chat: *"use ulissesxavier with login qa@example.com and
  password …"*. You can also note the login in the profile, with the
  password in an environment variable. With no account, it evaluates what
  needs no login and asks for one before the authenticated screens. It never
  creates accounts and never writes the password into a file, report or
  reply.
- **It doesn't delete real data.** Destructive flows are tested by
  intercepting the page's `fetch`, with the data intact.

## Cost

A full sweep is long: it walks the whole app with screenshots. What the
agent does to spend less without weakening the analysis:

- **Measures with a ready kit** (`ux-audit`): one script injected per page
  returns targets, contrast and a screen's visual inventory as short JSON,
  instead of the agent writing measuring code for every screen.
- **Text before images**: half-scale screenshots with a cap per sweep;
  what text can answer never becomes a screenshot.
- **Writes the report once**: the markdown is the PDF's source.
- **Looks things up instead of loading them**: the bibliography and the base
  concept guide live in files it searches by keyword, outside the fixed
  prompt.
- **Checks the PDF with one image**: a single capture of every chart,
  instead of reading the document page by page.

Day to day, prefer a focus ("typography and spacing only") or regression
mode ("only what changed in this branch").

## Example

[`examples/maria-view/`](examples/maria-view/) holds the profile of the
project where the agent was born: Maria.View, a web app that reads quantum
chemistry outputs and draws the molecule in 3D. Its first two sweeps found
three data-loss paths with no undo, body text at 3.26:1 (below AA) and a
visual system with 12 font sizes, 12 radii and 13 `z-index` levels. The
first three were fixed the same week.

## License

[MIT](LICENSE)
