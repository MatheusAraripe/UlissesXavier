---
name: ux-report-pdf
description: The UlissesXavier report format and its PDF export — how to write the markdown report (cards, charts, tiles, concept guide, numbered references) so that one file is both the readable report and the source of a designed PDF, and the one command that builds the PDF with headless Chrome. Use before writing a UlissesXavier report, or when the user asks for an existing UX report as a PDF.
---

# The report: one markdown file, one command

The markdown report is the **only** thing written. `build.sh` puts it inside
the template, the template renders it (cover, contents, cards, charts,
concept guide, references) and headless Chrome prints the PDF. Never write
HTML by hand: it would be the same report written twice.

Files here: `build.sh`, `template.html` (do not edit), `references.md` and
`glossary.md` (grep them; do not read them whole).

## 1. Conventions

Plain markdown reads well anywhere; the extras below are either HTML
comments (invisible on GitHub) or attributes in `{ }` at the end of a
heading.

**Cover — first thing in the file.** All visible labels come from here, in
the report's language. The evaluator is always named with its tagline:
**UlissesXavier 🤓 — O seu nerdzinho de UX** (in English, "Your UX nerd";
in other languages, a faithful translation in `labels.tagline`). The
template puts 🤓, the name and the tagline at the top of the cover and the
name in the footer.

```
<!-- cover
{"lang":"pt-BR","title":"Avaliação de UX — Produto — 2026-10-13",
 "eyebrow":"Avaliação de UX","product":"Produto","subtitle":"O que foi avaliado, numa frase.",
 "meta":[["Data","13/10/2026"],["Modo","Varredura completa"],["Versão","`abc1234`"],["Avaliador","UlissesXavier 🤓 — O seu nerdzinho de UX"]],
 "rule":"Todo achado traz evidência e fonte; uma inspeção de especialista não substitui teste com usuários.",
 "labels":{"contents":"Conteúdo","severity":"Severidade","levels":["Sem problema","Cosmético","Menor","Maior","Catástrofe"],
   "effort":"Esforço","confidence":"Confiança","suggestion":"Sugestão",
   "glossaryHint":"Termos com sublinhado pontilhado estão explicados no Guia de conceitos.",
   "tagline":"O seu nerdzinho de UX"}}
-->
```

**Structure.** `# Product` (optional). Every `##` is a chapter on a new page
and an entry in the contents — `{.nobreak}` keeps it on the current page
(use it for the summary, and for any chapter shorter than a third of a
page). `###` is a section, `####` a sub-section. `{#id}` sets the anchor.

**Problem cards** — a `###` with `sev`, followed by `Label: text` items:

```
### P1 — Apagar uma área é um clique sem volta {sev=4 effort=P confidence=alta}
- Onde: Tela inicial, lixeira da linha (`src/pages/home/history.js`).
- Acontece: Um clique apaga arquivo, medições e notas.
- Evidência: Alvo de 15 × 15 px a 10 px do clique de abrir. ![Lixeira](img/p1.png)
- Base: Nielsen #3 e #5 [4]; desfazer em vez de confirmar [5].
- Sugestão: A linha some e um aviso oferece "Desfazer" por alguns segundos.
```

`fixed="…"` adds a green badge. The item whose label equals
`labels.suggestion` is set in bold. **Idea cards**: `### I1 — Title {.idea}`
with the same `Label: text` items.

**Callouts** (summary): `> [!urgent] Mais urgente`, `> [!strength] Maior
força`, `> [!note] …` followed by `> ` lines; consecutive callouts sit side
by side.

**Tables**: standard pipes; `---:` right-aligns a numeric column. A cell
that is exactly `3/5` becomes a score pill; cells starting with `✓`, `–`
or `✕` become state cells (the five-states matrix).

**Citations**: `[4]` or `[4, 9]` after the claim → superscript link to
reference 4. Number references in order of first citation.

**Tiles** (summary, at most four): `<!-- tiles [{"value":"2,9","unit":" / 5","label":"nota média das 12 áreas"}] -->`

**Charts**: `<!-- chart TYPE {json} -->`, every one with `title`, `subtitle`
(unit and what is good) and `caption` (method and source, may cite `[n]`).

| Type | For | Data |
|---|---|---|
| `bars` | scores by area/criterion; problems per severity | `max`, `ticks`, `decimals`, `unit`, `target {value,label}`, `sort` asc/desc, `labelWidth`, `items [{label, value, tone?}]` — `tone` `sev-4`…`sev-1`/`good` only for severity counts, with the word in the label |
| `dumbbell` | visual system today → proposed | `legend [today, proposed]`, `ticks`, `max`, `items [{label, from, to}]` |
| `bullet` | Core Web Vitals, any good/poor threshold (lower is better) | `items [{label, value, unit, good, poor, max, decimals}]` |
| `paired` | KLM seconds now vs proposed, any before/after | `legend [now, proposed]`, `unit`, `decimals`, `items [{label, a, b}]` |
| `matrix` | priority: severity × effort | `x [effort labels]`, `y [severity labels, highest first]`, `first {x, y, label}`, `items [{id, x, y}]` (0-based) |

A chart only when it beats a sentence or a table; fewer than three numbers is
a tile or a sentence. Numbers in the JSON are the report's numbers, exactly.

**Visual system**: `<!-- specimen [{"token":"--text-sm","value":"12 / 400","size":12,"weight":400,"upper":false,"sample":"…"}] -->`
and `<!-- swatches [{"color":"#32404f","name":"--fg","note":"10,6:1"}] -->`.

**Code / tokens**: a fenced block (```` ```json ````) is printed as is.

**Images**: `![alt that says what it proves](img/file.png)` — the `img/`
folder sits next to the report, in the run folder; copy screenshots there
and crop to the region that proves the point.

## 2. The concept guide — mandatory

Readers are not all specialists. Every technical term, theory, metric,
standard or author the report relies on goes into a chapter
`## Guia de conceitos {#glossary}` (title in the report's language, id
always `glossary`), placed before the references:

```
- **limiar de Doherty** (Doherty) — Cerca de 400 ms: abaixo disso, pessoa e sistema não esperam um pelo outro [3].
```

- Bold term, optional aliases in parentheses separated by `;`, a dash, then
  one or two plain sentences: what it is and, when useful, why it matters
  here. Cite when the definition comes from a source.
- The renderer links the **first mention** of each term (or alias) in the
  body to its entry, with a dotted underline, and adds the hint under the
  contents. Use the term in the body exactly as written in the entry.
- Start from `glossary.md` (grep the terms you used) and write the entries
  in the report's language. Include only terms the report uses — typically
  10–25. Explain authors as people ("Edward Tufte, estatístico…").

## 3. References

`## Referências {#references}` (id always `references`) is a numbered list
in order of first citation, each item ending with its URL when it has one:

```
1. Nielsen, J. & Molich, R. (1990). Heuristic evaluation of user interfaces. CHI '90, ACM. https://www.nngroup.com/articles/ten-usability-heuristics/
```

Copy the lines from `references.md` (grep by short name). A source not there
must be verified before it is cited, and added to the list in this format.

## 4. Build and check

```bash
bash "${CLAUDE_SKILL_DIR}/build.sh" "<run folder>/ulissesxavier-YYYY-MM-DD-vN.md" --proof
```

It writes only the PDF next to the report (the HTML it renders from is
temporary) and prints the PDF path, the page count, the number of render
errors with the first messages, and (with `--proof`) a single screenshot of
every chart, tile and callout. Then:

1. **Render errors > 0** → fix the markdown at the reported block and build
   again.
2. **Look at the proof image once** — labels clipped or colliding, a chart
   that does not say what the text says.
3. Read the PDF itself only if the user asks to review the layout, or the
   proof showed a problem you cannot judge without the page.

If no Chromium browser exists, the script keeps the HTML next to the report
and says how to print it; report that.
