# Concept guide — base definitions

Grep the terms the report uses (`grep -i "doherty" glossary.md`) instead of
reading the file. Write each entry in the report's language, in plain words,
for someone who has never studied HCI: what it is in one sentence, and — when
it helps — why it matters, with the citation number. Add any term the report
uses that is missing here, with the same care. Short names in parentheses
are aliases: list them the same way in the report so their first mention is
linked too.

## People and works
- **Nielsen** (heuristics; Nielsen #1…#10) — Jakob Nielsen; his ten heuristics are general rules for spotting usability problems by inspection (e.g. #1 visibility of system status, #3 user control and freedom, #9 help users recover from errors).
- **Shneiderman** (golden rules; mantra) — Ben Shneiderman; eight rules of interface design (consistency, easy reversal, feedback…) and the visualization mantra "overview first, zoom and filter, details on demand".
- **Norman** — Don Norman; *The Design of Everyday Things*: affordances, signifiers, feedback, and the gaps between what people want and what the interface lets them do.
- **Tufte** — Edward Tufte; statistician and designer; show the data, remove ink that carries no information, never distort the scale.
- **Bertin** — Jacques Bertin; cartographer who catalogued the visual variables (position, size, value, color, shape…) and what each can express.
- **Mackinlay** — Jock Mackinlay; a chart must show all the facts and only them (expressiveness) using what the eye reads most precisely (effectiveness).
- **Munzner** — Tamara Munzner; visualization design as nested decisions: who and what for, which data, which picture, which algorithm.
- **Cleveland & McGill** — the experiment showing people read position on a common scale far more accurately than angle, area or color.
- **Few** — Stephen Few; practical rules for tables and charts in business reports.
- **Fitts** (Fitts's law) — the time to hit a target grows with its distance and shrinks with its size; small, far buttons are slow and error-prone.
- **Hick** (Hick's law) — the time to decide grows with the number of options.
- **Jakob's law** — people spend most of their time in other products, so they expect yours to work like those.
- **Tesler** (conservation of complexity) — some complexity cannot be removed, only moved; better the system absorbs it than the user.
- **Baldonado** — Michelle Baldonado; guidelines for systems showing the same data in several linked views.
- **Treisman** (preattentive) — Anne Treisman; some visual features (color, size, motion) are noticed in a glance, before conscious search.
- **Machado et al.** — a model that simulates how screens look to people with each type of color blindness.
- **Baymard** — Baymard Institute; large-scale usability research on forms and checkout.

## Measures and thresholds
- **Doherty threshold** (limiar de Doherty) — about 400 ms; below it, person and computer stop waiting for each other and work flows (IBM study, 1982).
- **response time limits** (0.1 s; 1 s; 10 s) — 0.1 s feels instant, 1 s keeps the train of thought, 10 s is the limit of attention; beyond 1 s show progress.
- **Core Web Vitals** — Google's three measures of how a page feels: LCP, INP and CLS, judged at the 75th percentile of visits.
- **LCP** (Largest Contentful Paint) — time until the main content appears; good ≤ 2.5 s.
- **INP** (Interaction to Next Paint) — delay between a click or key and the screen responding; good ≤ 200 ms.
- **CLS** (Cumulative Layout Shift) — how much the layout jumps while loading; good ≤ 0.1.
- **long task** — a block of script work over 50 ms during which the page cannot respond.
- **KLM** (Keystroke-Level Model) — predicts how long an expert takes for a task by adding standard times for each keystroke, pointing and moment of thought.
- **contrast ratio** (contrast) — how much text stands out from its background, from 1:1 (invisible) to 21:1 (black on white); WCAG AA asks 4.5:1 for body text.
- **severity** — Nielsen's 0–4 rating of how much a problem hurts, combining how often it happens, how bad it is and whether people keep hitting it.
- **SUS** (System Usability Scale) — a ten-question questionnaire that gives a 0–100 usability score; about 68 is average.
- **HEART** — Google's framework for product metrics: Happiness, Engagement, Adoption, Retention, Task success.

## Accessibility
- **WCAG** — the W3C's accessibility guidelines; each success criterion has a number (1.4.3 is contrast) and a level (A, AA, AAA); AA is the usual legal requirement.
- **target size** — the clickable area of a control; WCAG 2.5.8 asks at least 24 × 24 CSS pixels.
- **focus visible** — the outline that shows which element the keyboard is on; without it keyboard users are lost.
- **reflow** — content must work at 320 px wide without scrolling sideways (WCAG 1.4.10).
- **screen reader** — software that reads the interface aloud; it depends on every control having a name and a role.
- **color vision deficiency** (color blindness; daltonism) — reduced ability to tell some colors apart; about 8% of men of northern European descent have red–green deficiency.

## Interface and visual design
- **affordance** (signifier) — what an object suggests you can do with it; a signifier is the visible hint (a raised button looks pressable).
- **progressive disclosure** — show the essentials first and the rest on request, with an obvious path to it.
- **mode** (quasimode) — a state where the same action does something different; modes cause errors, quasimodes (held keys like Shift) don't.
- **undo** — reversing an action after the fact; safer and faster than asking "Are you sure?" before it.
- **empty state** — what a screen shows when there is nothing in it yet; it should explain and invite the first action.
- **skeleton screen** — grey shapes standing in for content while it loads.
- **information hierarchy** (hierarchy) — the order in which the eye reads a screen; the most important thing should weigh the most.
- **squint test** — blurring the screen to see what still stands out; that is what the eye reads first.
- **modular scale** — font sizes that grow by a fixed ratio (e.g. ×1.2) instead of chosen one by one.
- **8-point grid** — spacing in multiples of 8 (with 4 for fine steps), so the layout has a steady rhythm.
- **design tokens** (tokens) — named design decisions (`--text-sm`, `--radius-md`) used across the code, so each choice is made once.
- **hue** — the "name" of a color (red, blue), apart from how light or saturated it is.
- **data-ink ratio** — the share of a chart's ink that shows data; the rest should be minimal.
- **lie factor** — how much bigger an effect looks in a chart than it is in the data; should be about 1.
- **small multiples** — the same small chart repeated with the same axes, to compare at a glance.
- **linked views** (coupling) — several views of the same data reacting to each other: select here, highlight there.
- **bubble cursor** — the click takes the nearest target, not only the one exactly under the pointer.
- **pseudo-localization** — replacing text with longer, accented fake text to find what breaks when the interface is translated.
- **dark pattern** (deceptive pattern) — a design that pushes people into choices they would not make if informed (hidden costs, hard-to-cancel, pre-checked consent).
- **cognitive walkthrough** — stepping through a task as a first-time user, asking at each step whether they would know what to do and see that it worked.
- **heuristic evaluation** — experts inspecting an interface against a set of principles, without users.

## Psychology and emotion
- **mental model** — the picture a person has in their head of how a product works, built from the products they already use; when the interface matches it, things feel obvious.
- **information scent** (Pirolli & Card) — how well a label or link predicts what is behind it; strong scent leads people straight there, weak scent makes them guess and come back.
- **satisficing** (Simon) — choosing the first option that seems good enough instead of comparing them all; on screens, people click the first plausible thing.
- **paradox of the active user** (Carroll & Rosson) — people start using a product right away instead of reading instructions, and keep the first way that works even when a better one exists.
- **inattentional blindness** — failing to see something in plain view because attention is on something else (the famous gorilla video by Simons & Chabris).
- **change blindness** — failing to notice that something on the screen changed, especially during a reload, a transition or away from where one is looking.
- **banner blindness** — the habit of skipping anything that looks like an advertisement, even when it is useful content.
- **habituation** — the brain's response weakens when the same signal repeats; a warning that always looks the same stops being read.
- **working memory** — the small mental space where we hold what we are using right now; it keeps about four items at once (Cowan).
- **cognitive load** (Sweller) — the mental effort a task demands; the part caused by the interface instead of the task itself is waste.
- **visceral, behavioral and reflective levels** (Norman's three levels) — three layers of emotional response to a product: the instant reaction to its look, the feeling of using it, and what it means to us afterwards.
- **first impression** (50 ms) — people judge how appealing a screen is in about 50 milliseconds, before reading anything (Lindgaard et al.).
- **visual complexity and prototypicality** — how busy a screen looks, and how much it looks like what people expect for that kind of site; simple and typical screens are liked most at first sight (Tuch et al.).
- **credibility** — how much people believe a product and trust it with their data or money; for non-experts it depends heavily on how the product looks (Fogg et al.).
- **peak-end rule** (Kahneman) — people remember an experience mostly by its worst (or best) moment and by how it ended, not by its total length.
- **perceived waiting time** — how long a wait feels, which is not how long it is: unexplained, uncertain and empty waits feel longer (Maister).
- **sense of agency** — the feeling of being the one who makes things happen; it needs immediate, predictable responses and weakens when the system acts on its own.
- **computers are social actors** (CASA; Nass & Moon) — people react to software with the same social rules they use with people, so tone, politeness and blame matter.
- **default effect** — the option that comes pre-selected is chosen far more often than it would be picked freely.
- **framing** (Kahneman & Tversky) — the same choice described as a gain or as a loss leads to different decisions; losses weigh more than equal gains (loss aversion).
- **choice overload** — too many options can make people delay, decide worse or regret, mainly when the choice is hard, the options are complex or they don't know what they want.
- **goal-gradient effect** — people speed up as they get closer to a goal; showing progress (even a head start) keeps them going.
- **self-determination theory** (autonomy, competence, relatedness; METUX) — people stay motivated and well when they feel in control, capable and connected; interfaces can support or frustrate these needs.
- **pragmatic and hedonic quality** (AttrakDiff; Hassenzahl) — whether a product helps get things done (pragmatic) and whether it is stimulating and says something about us (hedonic); both shape how good it feels.
- **cognitive accessibility** (W3C COGA) — making products usable by people with cognitive and learning disabilities — and, in practice, by anyone tired, stressed or distracted.
- **SAM** (Self-Assessment Manikin) — a picture scale where people rate how pleasant, how intense and how in control a moment felt; quick and language-light.
- **PANAS** — a short questionnaire that measures positive and negative feelings separately.
