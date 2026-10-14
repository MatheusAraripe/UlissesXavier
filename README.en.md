<div align="center">

# `/ulissesxavier:ux-evaluate`

### UlissesXavier 🤓 — *your UX nerd*

**A UX/UI evaluator for Claude Code that doesn't give opinions: it measures and cites.**

[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-D97757)](https://code.claude.com/docs/en/plugins)
[![Version](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2FMatheusAraripe%2FUlissesXavier%2Fmain%2Fplugins%2Fulissesxavier%2F.claude-plugin%2Fplugin.json&query=%24.version&label=version&color=2f6fd6)](CHANGELOG.md)
[![MIT license](https://img.shields.io/badge/license-MIT-555)](LICENSE)

[Versão em português](README.md)

<img src="docs/images/01-capa.png" alt="Cover of the PDF report: UlissesXavier 🤓 evaluating Maria.View" width="49%" valign="top">&nbsp;<img src="docs/images/02-resumo.png" alt="Report summary: average score, contrast, font sizes, the urgent items, the biggest strength, score by area and the severity × effort matrix" width="49%" valign="top">

<sub>The example report is in Portuguese — UlissesXavier writes in the language it is called in.</sub>

</div>

UlissesXavier is an agent for [Claude Code](https://code.claude.com). It
opens your web app in Chrome, walks every screen and gesture, tries to break
it, measures what can be measured, and delivers a report with 1–5 scores per
area, problems by priority and, for every score, **what it takes to reach
5**. It comes as markdown, for you to refine with your own Claude, and as a
designed PDF, to read and send to your team.

The rule that defines it: **no source, no finding.** Every claim comes with
the evidence (what it did, the number it measured, the screenshot) and the
basis (the principle, with its reference): standards and peer-reviewed
research (WCAG 2.2, CHI, IEEE VIS), the published guidelines of the field's
major references (Apple HIG, Google's Material and web.dev, Figma, Canva,
Nielsen Norman Group, Baymard, GOV.UK) and the psychology of the people who
use the product. What it suspects but cannot ground does not become a
problem: it becomes a question to test with users.

## Start in a minute

Requirements: [Claude Code](https://code.claude.com) and the
[Claude in Chrome](https://code.claude.com/docs/en/chrome) extension
connected.

```
/plugin marketplace add MatheusAraripe/UlissesXavier
/plugin install ulissesxavier@ulissesxavier
```

Then, in your project:

```
/ulissesxavier:ux-profile          ← once: who uses your product
/ulissesxavier:ux-evaluate         ← the full evaluation
/ulissesxavier:ux-evaluate mobile only
```

Turn on [automatic updates](#automatic-updates) to get new versions by
themselves.

## What you get

A report that follows the principles it demands from others: the essentials
in the first two pages, each problem on a card with its evidence and source,
charts drawn from the measured numbers, and a guide that explains every
concept to readers outside the field.

<table>
<tr>
<td width="33%" valign="top"><img src="docs/images/03-problemas.png" alt="Problem cards with severity, effort, confidence, where, evidence, basis and suggestion"></td>
<td width="33%" valign="top"><img src="docs/images/04-sistema-visual.png" alt="Visual system: values in use today against the proposed scale, the type scale and the colors that fail contrast"></td>
<td width="33%" valign="top"><img src="docs/images/05-guia-de-conceitos.png" alt="Concept guide: every cited term explained in plain words"></td>
</tr>
<tr>
<td valign="top"><b>Problems by priority.</b> Severity by shape, word and color; where it happens, the measured evidence, the basis with its source, and the suggestion.</td>
<td valign="top"><b>The visual system.</b> How many sizes, weights, radii and layers the app really uses, and the proposed scale as tokens.</td>
<td valign="top"><b>Concept guide.</b> Every term, theory and author cited, in plain words; in the PDF, the first mention links to its entry.</td>
</tr>
</table>

See the [full example PDF](examples/maria-view/relatorio-exemplo.pdf) and
the [markdown it was built from](examples/maria-view/relatorio-exemplo.md).

## What it evaluates

| Area | How | Basis |
|---|---|---|
| Usability | each persona's real tasks, heuristics, the novice's cognitive walkthrough | Nielsen & Molich; Shneiderman; Wharton et al. |
| Psychology and emotion | what people expect, what they miss, what they must keep in mind, what they feel (first impression, trust, waiting, the worst moment and the end of each task) and what pushes their decisions | Norman (*Emotional Design*); Lindgaard et al.; Tuch et al. (Google); Fogg et al. (Stanford); Pirolli & Card; Cowan; Kahneman; Peters, Calvo & Ryan; W3C COGA |
| Effort | steps and predicted time per task | Keystroke-Level Model (Card, Moran & Newell) |
| Perceived speed | LCP, INP, CLS and long tasks measured in the browser | Core Web Vitals (web.dev) |
| The five states | ideal, empty, error, partial, loading, with slow and failing network simulated | UI Stack (Hurff); NN/g |
| Accessibility | contrast, targets, keyboard, focus, reflow at 320 px, text spacing, 200% zoom | WCAG 2.2; WAI-ARIA APG |
| Color blindness | the screen filtered by physiological simulation | Machado, Oliveira & Fernandes (IEEE TVCG 2009) |
| Visual system | sizes, weights, spacing, radii, colors, durations, icons, and the proposed scale as tokens | modular scale; 8-pt grid; W3C Design Tokens |
| Hierarchy | squint and grayscale tests | Treisman; Healey & Enns; NN/g |
| Charts and tables | channel × data type, ink, lie factor, color scale | Bertin; Mackinlay; Munzner; Tufte; Few |
| Forms and words | validation, labels, error messages | Baymard; Wroblewski; GOV.UK; NN/g |
| Ethics | deceptive patterns in sign-up, consent, plans and cancellation | Gray et al. (CHI 2018); Mathur et al. (CSCW 2019) |
| Translation | pseudo-localization: what clips when text grows | W3C i18n; Microsoft |
| AI features | calibrated trust, provenance, manual override | Google PAIR |

## How to use it

**1. First time in a project: the profile.** The evaluator needs to know who
uses the product. Run `/ulissesxavier:ux-profile`: the skill scans the
repository (README, routes, sign-up fields, copy, locales), shows its
hypothesis about the audience and asks **a few short questions** to fill
what the code cannot tell — the main user, their experience, device, the
task that must be effortless, what is at stake for them, what the evaluator
must never touch. You answer in the chat, as multiple choice (with a free
field), and everything goes to `.claude/ux-profile.md`, plain markdown you
can edit. Skip this step and the first evaluation drafts the profile and
returns the questions.

**2. The evaluation**, with the command, with or without a focus:

```
/ulissesxavier:ux-evaluate
/ulissesxavier:ux-evaluate the checkout only
/ulissesxavier:ux-evaluate only what changed in this branch
```

or in plain words: *"use the ulissesxavier agent to evaluate the app"*. It
answers **in the language it was called in** and keeps everything in a
folder made to be browsed:

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

**3. The PDF.** A full sweep exports it by itself; in focused modes, ask
"and export it as PDF". Chrome or Edge renders it headless; nothing to
install. For an existing report: `/ulissesxavier:ux-report-pdf`.

### When it gets stuck, it asks

The agent runs in the background and does not talk to you directly, but it
does not give up on a blocker — a missing password, a server that won't
start, a choice only you can make. It moves on with what the blocker allows,
saves its progress in the draft and hands the question to the main Claude,
which asks you in the chat and **resumes the same agent** with your answer.
Only your "skip it" ends a part, and the report says what was left out and
why.

### Automatic updates

Claude Code updates a plugin by itself only when auto-update is on for its
marketplace, and for third-party marketplaces it starts **off**. Turn it on
once: `/plugin` → **Marketplaces** → **ulissesxavier** → **Enable
auto-update**. After the first message of each session, Claude Code checks
for new versions in the background and tells you
`Plugin updated: ulissesxavier · Run /reload-plugins to apply`. To update by
hand: `/plugin marketplace update ulissesxavier`. What changed in each
version is in the [CHANGELOG](CHANGELOG.md).

## What it doesn't do

- **It doesn't edit your code.** It evaluates, measures and proposes.
- **It doesn't replace testing with people.** One expert finds a fraction of
  the problems (Nielsen & Landauer, 1993), and a language model is not a
  user (NN/g, *Synthetic Users*). It never states what users feel: it points
  out the risk, with the mechanism and the source, and every report ends
  with what must be confirmed with real people.
- **It leaves no trace.** It starts the app's servers itself (each command
  lives in the profile), reuses whatever you already had running without
  closing it and, at the end, stops only what it started. Logs and PIDs go
  to a temporary folder outside the repository.
- **It only logs in with the test account you give it.** The natural way is
  to say it in the chat: *"evaluate with login qa@example.com and password
  …"*. It never creates accounts and never writes the password into a file,
  report or reply.
- **It doesn't delete real data.** Destructive flows are tested by
  intercepting the page's `fetch`, with the data left intact.

## Cost

A full sweep is long: it walks the whole app with screenshots. To spend less
without losing analysis, the agent measures with a ready kit injected into
the page (short JSON instead of code written for every screen), prefers text
to images, writes the report once (the markdown is the PDF's source), looks
up the bibliography by search instead of loading it, and does not load the
evaluated project's `CLAUDE.md` — it greps the decisions it needs. For
day-to-day work, prefer a focus ("only typography and spacing") or
regression mode ("only what changed in this branch").

## Where it came from

[`examples/maria-view/`](examples/maria-view/) holds the profile of the
project where the agent was born: Maria.View, a web app that reads quantum
chemistry output and draws the molecule in 3D. Its first two sweeps found
three ways to lose data with no undo, body text at 3.26:1 (below AA) and a
visual system with 12 font sizes, 12 radii and 13 `z-index` levels. The
first three were fixed the same week.

## License

[MIT](LICENSE) © Matheus Araripe
