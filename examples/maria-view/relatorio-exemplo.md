<!-- cover
{"lang": "pt-BR", "title": "Avaliação de UX — Maria.View — 10/10/2026",
 "eyebrow": "Avaliação de UX · exemplo", "product": "Maria.View",
 "subtitle": "Segunda varredura completa: entrada, mesa de trabalho, molécula, quadros, terminal, celular — com auditoria do sistema visual, da hierarquia e dos gráficos.",
 "meta": [["Data", "10/10/2026"], ["Modo", "Varredura completa"], ["Versão", "`9acb2c4`"], ["Avaliador", "UlissesXavier"]],
 "rule": "Todo achado traz evidência medida e uma fonte. Uma inspeção de especialista encontra uma fração dos problemas e não substitui teste com usuários; o que precisa ser confirmado com pessoas está no fim.",
 "labels": {"contents": "Conteúdo", "severity": "Severidade", "levels": ["Sem problema", "Cosmético", "Menor", "Maior", "Catástrofe"],
            "effort": "Esforço", "confidence": "Confiança", "suggestion": "Sugestão",
            "glossaryHint": "Termos com sublinhado pontilhado estão explicados no Guia de conceitos, no fim."}}
-->

# Maria.View

## Rápido e honesto com a origem dos dados, mas sem escala visual e com três caminhos para perder dados {#resumo .nobreak}

O Maria.View responde abaixo do limiar de Doherty em tudo o que foi medido e mostra de onde vem cada número. O que a segunda varredura revelou é que o sistema visual não tem escala, e que as três urgências de perda de dados da primeira rodada seguem abertas.

<!-- tiles
[{"value": "2,9", "unit": " / 5", "label": "nota média das 12 áreas percorridas"},
 {"value": "3,26", "unit": ":1", "label": "contraste do texto corrente no tema claro (mínimo AA: 4,5:1)"},
 {"value": "12 → 7", "label": "tamanhos de fonte na tela hoje → escala proposta"},
 {"value": "1", "label": "problema de severidade 4 (catástrofe) e 4 de severidade 3"}]
-->

> [!urgent] Mais urgente
> 1. **Apagar uma área de trabalho é um clique sem volta** — leva arquivo, medições e notas.
> 2. **Texto corrente a 3,26:1 no tema claro**, reprovado no WCAG 1.4.3 em todas as telas.
> 3. **A lixeira do registro e o teto de 20 medições** apagam dados do servidor sem aviso.

> [!strength] Maior força
> As vistas ligadas: clicar num ponto do perfil de energia troca o ciclo da molécula, e a linha da tabela seleciona o átomo — o acoplamento evidente de Baldonado [1].

<!-- chart bars
{"title": "Nota por área", "subtitle": "Escala de 1 (quebrado) a 5 (referência); a linha marca 4, \"bom\". Da pior para a melhor.",
 "caption": "Notas da seção 5.1 do método; \"o que falta para 5\" no capítulo 3. Avaliador único: as notas são hipóteses fortes a confirmar com usuários [2].",
 "max": 5, "ticks": [0, 1, 2, 3, 4, 5], "target": {"value": 4, "label": "bom"}, "sort": "asc", "labelWidth": 230,
 "items": [
  {"label": "Entrada (login, inicial)", "value": 3}, {"label": "Área vazia", "value": 2},
  {"label": "A mesa", "value": 3}, {"label": "A molécula e a seleção", "value": 4},
  {"label": "Quadros e vistas ligadas", "value": 3}, {"label": "Mapa de calor", "value": 2},
  {"label": "Montagem", "value": 3}, {"label": "Terminal e registro", "value": 3},
  {"label": "Configurações e tema", "value": 4}, {"label": "Espera e erro", "value": 4},
  {"label": "Celular (só layout)", "value": 2}, {"label": "Teclado e acessibilidade", "value": 2}]}
-->

<!-- chart matrix
{"title": "Onde começar: severidade × esforço", "subtitle": "Cada etiqueta é um problema do capítulo 2. O canto destacado é o que rende mais por hora de trabalho.",
 "caption": "Severidade de Nielsen (0–4), que combina frequência, impacto e persistência [3]; esforço estimado pela leitura do código.",
 "x": ["Esforço P (horas)", "Esforço M (um dia)", "Esforço G (dias)"],
 "y": ["4 · Catástrofe", "3 · Maior", "2 · Menor", "1 · Cosmético"],
 "first": {"x": 0, "y": 1, "label": "Fazer primeiro: severidade alta, esforço baixo"},
 "items": [{"id": "P1", "x": 0, "y": 0}, {"id": "P4", "x": 0, "y": 1}, {"id": "P2", "x": 0, "y": 1},
  {"id": "P3", "x": 1, "y": 1}, {"id": "P5", "x": 1, "y": 1},
  {"id": "N1", "x": 0, "y": 2}, {"id": "N2", "x": 0, "y": 2}, {"id": "N4", "x": 0, "y": 2}, {"id": "N7", "x": 0, "y": 2},
  {"id": "N3", "x": 1, "y": 2}, {"id": "N6", "x": 1, "y": 2}, {"id": "N8", "x": 0, "y": 3}, {"id": "N9", "x": 0, "y": 3}]}
-->

## Os cinco primeiros problemas cabem em poucas horas cada {#problemas}

Quatro dos cinco problemas de maior prioridade são de esforço P. Os cartões seguem a ordem de prioridade; P1–P5 vêm da primeira rodada e N1–N9 desta.

### P1 — Apagar uma área de trabalho é um clique sem volta {sev=4 effort=P confidence=alta fixed="Corrigido depois, em fa4f0ad"}

- Onde: Tela inicial, lixeira de cada linha do histórico (`src/pages/home/history.js`).
- Acontece: Um clique apaga o arquivo, as medições e as notas, sem confirmação nem desfazer.
- Evidência: Alvo de 15 × 15 px a cerca de 10 px do clique de abrir a mesma linha.
- Base: Nielsen #3, controle e liberdade, e #5, prevenção de erros [4]; Apple HIG: desfazer é quase sempre melhor que "Tem certeza?" [5]; WCAG 2.5.8, alvo ≥ 24 px [6].
- Sugestão: A linha some na hora e um aviso oferece "Desfazer" por alguns segundos; só depois o pedido vai ao servidor.

### P4 — Texto corrente a 3,26:1 no tema claro {sev=3 effort=P confidence=alta fixed="Corrigido depois: 7,4:1"}

- Onde: Toda tela no tema claro: o token `--scene-fg-text` vale `#32404f95`.
- Evidência: Razão de contraste calculada sobre o branco: 3,26:1; sobre o realce de hover, menos ainda.
- Base: WCAG 2.2, SC 1.4.3, contraste mínimo de 4,5:1 para texto [6].
- Sugestão: Alfa mínimo ~`b8`; texto corrente cheio e o secundário a 78%.

### P2 — A lixeira do registro apaga as medições do servidor {sev=3 effort=P confidence=alta fixed="Corrigido depois, em fa4f0ad"}

- Onde: Barra do terminal, ao lado do botão de baixar.
- Acontece: Limpa a transcrição e apaga do banco todas as medições do arquivo; a falha só aparece no console.
- Base: Shneiderman, reversão fácil [7]; Nielsen #9 [4].
- Sugestão: O mesmo padrão de desfazer do P1, e a falha visível na tela.

### N1 — "Valor (e)" vira "VALOR (E)": a unidade muda de sentido {sev=2 effort=P confidence=alta fixed="Corrigido depois, em fa4f0ad"}

- Onde: Cabeçalho das tabelas de carga (`src/panel/table.js`).
- Acontece: `text-transform: uppercase` troca *e*, a carga elementar, por *E*.
- Base: Nielsen #2, correspondência com o mundo real [4]; unidade é dado, não enfeite [8].
- Sugestão: A unidade num `<span>` com `text-transform: none`.

### N7 — O elemento químico só se distingue pela matiz {sev=2 effort=P confidence=alta}

- Onde: `src/scene/palette.js`. Decisão registrada: "o que distingue um elemento do outro é a matiz".
- Evidência: Em tons de cinza, N e O diferem 1,5 em L*, C e Br 0; F e Cl ficam a ΔE 14.
- Base: WCAG 1.4.1, cor não é o único meio [6]; Crameri et al., escalas de cor na ciência [9].
- Sugestão: Manter as cores lavadas e a matiz como identidade, escalonando a claridade só nos pares que se confundem.

## Quatro áreas abaixo de 3, todas pela mesma razão: o que não se vê não se usa {#notas}

| Área | Nota | Por quê | O que falta para 5 |
|---|---:|---|---|
| Área vazia | 2/5 | No teste do olho semicerrado nada sobrevive: o convite é texto de 11–12 px. | As três portas como alvos grandes no centro; um exemplo clicável ("cafeína"). |
| Mapa de calor | 2/5 | Sem legenda; neutro branco a 1:1 no tema claro. | Legenda viva; divergente perceptual com meio cinza [9]. |
| Celular | 2/5 | A vista guardada mostra a mesa vazia a 390 px. | Enquadrar a molécula ao abrir; testar o toque num aparelho. |
| Teclado e acessibilidade | 2/5 | Átomos fora do teclado; modal sem semântica; 1.4.3 reprovado. | Contraste; linhas de tabela focáveis; `role="dialog"`. |
| A mesa | 3/5 | Rápida e previsível; fichas indistinguíveis. | Quadro nasce proporcional à molécula; desfazer de arranjo, como no Figma. |
| A molécula e a seleção | 4/5 | Cursor bolha [10], anel e cota funcionam. | Elemento identificável sem matiz (N7). |

Tabela parcial neste exemplo; o relatório completo traz as 12 áreas e os 11 critérios.

## Doze tamanhos de fonte onde sete bastam {#sistema}

A cor é a dimensão mais disciplinada do app (dois valores de texto por tema). Tipo, raio, camada e ícone cresceram sem escala: cada valor solto é uma decisão que alguém terá de repetir de cabeça [11].

<!-- chart dumbbell
{"title": "Valores distintos em uso, hoje → escala proposta",
 "caption": "Contagem por `getComputedStyle` nos elementos visíveis das telas principais, nos dois temas. A escala proposta segue a escala modular de Tim Brown [12] e a grade de 8 do Material [13], em design tokens no formato do W3C [14].",
 "legend": ["Hoje (renderizado)", "Proposto (tokens)"], "ticks": [0, 5, 10, 15], "max": 15,
 "items": [{"label": "Tamanhos de fonte", "from": 12, "to": 7}, {"label": "Pesos", "from": 4, "to": 3},
  {"label": "Famílias", "from": 3, "to": 2}, {"label": "Raios", "from": 12, "to": 4},
  {"label": "Níveis de z-index", "from": 13, "to": 7}, {"label": "Durações", "from": 7, "to": 3},
  {"label": "Tamanhos de ícone", "from": 7, "to": 2}]}
-->

### A escala de tipo proposta

<!-- specimen
[{"token": "--text-display", "value": "64 / 300", "size": 44, "weight": 300, "sample": "Maria.View"},
 {"token": "--text-xl", "value": "24 / 400", "size": 24, "sample": "Entrar no Maria.View"},
 {"token": "--text-lg", "value": "15 / 400", "size": 15, "sample": "Descreva uma molécula ou anexe um arquivo"},
 {"token": "--text-md", "value": "13 / 400", "size": 13, "sample": "Cargas de Mulliken · Energia · Infravermelho"},
 {"token": "--text-sm", "value": "12 / 400", "size": 12, "sample": "C1–N5  1,387 Å   ciclo 30"},
 {"token": "--text-xs", "value": "11 / 400", "size": 11, "sample": "lido de MULLIKEN ATOMIC CHARGES · linha 13428"},
 {"token": "--text-caption", "value": "10 / 600", "size": 10, "weight": 600, "upper": true, "sample": "Por átomo · Ligações"}]
-->

A amostra de exibição está reduzida para caber na coluna.

### O texto que reprova, e o que passa

<!-- swatches
[{"color": "#32404f", "name": "#32404f", "note": "destaque · 10,6:1"},
 {"color": "#32404fe0", "name": "#32404fe0", "note": "corrente proposto · 7,4:1"},
 {"color": "#32404fc0", "name": "#32404fc0", "note": "secundário proposto · 5,1:1"},
 {"color": "#32404f95", "name": "#32404f95", "note": "corrente hoje · 3,26:1 ✕"}]
-->

## O que está bom, e não deve ser "consertado" {#bom .good}

- **Nenhuma sombra**: a borda faz o objeto existir; a regra se mantém em todas as telas.
- **A tabela de cargas**: números tabulares, à direita, casas iguais, com a linha do arquivo de onde vieram — Few [15] e Tufte [8].
- **Perfil ↔ ciclo ↔ barra**: o acoplamento entre vistas é evidente e consistente [1].
- **Uma família de ícones** com um ponto único de geração — a escala de ícones é o conserto de uma função.

### Método e escopo

Percorrido no Chrome, a 1440 px, 390 × 844 e 768 × 1024, nos temas claro e escuro, com um `.out` de otimização e frequências e uma molécula gerada. O toque ficou sem teste (exige aparelho). Avaliador único: segundo Nielsen e Landauer, um avaliador encontra uma fração dos problemas, e cinco usuários por rodada encontram a maioria [2].

**Nota deste exemplo:** reproduz parte do relatório de 10/10/2026. As etiquetas "Corrigido depois" foram acrescentadas para mostrar o que a equipe consertou na mesma semana.

## Guia de conceitos {#glossary}

- **limiar de Doherty** — Cerca de 400 ms: abaixo disso, pessoa e sistema não esperam um pelo outro, e o trabalho flui. Vem de um estudo da IBM (Doherty & Thadani, 1982).
- **heurísticas de Nielsen** (Nielsen #2; Nielsen #3; Nielsen #9) — Dez regras gerais de usabilidade (ex.: #3 "controle e liberdade do usuário", #9 "ajudar a se recuperar de erros"), usadas para inspecionar interfaces sem usuários [4].
- **WCAG** — As diretrizes de acessibilidade do W3C. Cada critério tem um número (1.4.3 é contraste) e um nível; AA é o exigido por lei em muitos países [6].
- **contraste** (razão de contraste) — Quanto o texto se destaca do fundo, de 1:1 (invisível) a 21:1 (preto no branco). O mínimo AA para texto comum é 4,5:1 [6].
- **severidade** — Nota de 0 a 4 para o quanto um problema atrapalha, combinando frequência, impacto e se a pessoa tropeça uma vez ou sempre [3].
- **vistas ligadas** (acoplamento) — Quando duas visualizações do mesmo dado reagem uma à outra: selecionar aqui destaca lá [1].
- **cursor bolha** — Técnica em que o clique pega o alvo mais próximo, e não só o que está exatamente sob o ponteiro; alvos pequenos ficam fáceis de acertar [10].
- **escala modular** — Tamanhos de fonte que crescem por uma razão fixa (ex.: ×1,2), em vez de valores escolhidos um a um [12].
- **design tokens** (tokens) — Nomes para as decisões visuais (`--text-sm`, `--radius-md`) usados em todo o código, para cada decisão ser tomada uma vez [14].
- **matiz** — O "nome" da cor (vermelho, azul), separado de quão clara ou saturada ela é. Distinguir coisas só pela matiz falha para quem tem daltonismo [9].
- **Tufte** — Edward Tufte, estatístico e designer, referência em gráficos de dados: mostrar o dado e tirar a tinta que não informa [8].
- **Baldonado** — Michelle Baldonado, autora das diretrizes para sistemas com várias vistas do mesmo dado [1].

## Referências {#references}

1. Baldonado, M., Woodruff, A. & Kuchinsky, A. (2000). Guidelines for using multiple views in information visualization. AVI '00, ACM.
2. Nielsen, J. & Landauer, T. (1993). A mathematical model of the finding of usability problems. INTERCHI '93. https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/
3. Nielsen, J. (1994). Severity ratings for usability problems. Nielsen Norman Group. https://www.nngroup.com/articles/how-to-rate-the-severity-of-usability-problems/
4. Nielsen, J. & Molich, R. (1990). Heuristic evaluation of user interfaces. CHI '90. https://www.nngroup.com/articles/ten-usability-heuristics/
5. Apple. Human Interface Guidelines. https://developer.apple.com/design/human-interface-guidelines/
6. W3C (2023). Web Content Accessibility Guidelines (WCAG) 2.2. https://www.w3.org/TR/WCAG22/
7. Shneiderman, B. The eight golden rules of interface design. https://www.cs.umd.edu/~ben/goldenrules.html
8. Tufte, E. (2001). The Visual Display of Quantitative Information, 2nd ed. Graphics Press.
9. Crameri, F., Shephard, G. & Heron, P. (2020). The misuse of colour in science communication. Nature Communications 11, 5444.
10. Grossman, T. & Balakrishnan, R. (2005). The bubble cursor. CHI '05, ACM.
11. Wathan, A. & Schoger, S. (2018). Refactoring UI. https://www.refactoringui.com/
12. Brown, T. (2011). More meaningful typography. A List Apart. https://alistapart.com/article/more-meaningful-typography/
13. Google. Material Design — spacing methods. https://m1.material.io/layout/metrics-keylines.html
14. W3C Design Tokens Community Group (2025). Design Tokens Format Module 2025.10. https://www.w3.org/community/reports/design-tokens/CG-FINAL-format-20251028/
15. Few, S. (2012). Show Me the Numbers, 2nd ed. Analytics Press.
