# UlissesXavier

**Um avaliador de UX/UI para o Claude Code que não opina: mede e cita.**

[English version](README.en.md)

O UlissesXavier abre o seu app web no Chrome, percorre todas as telas e
gestos, tenta quebrar, mede o que dá para medir e escreve um relatório com
notas de 1 a 5 por área, problemas por prioridade e, para cada nota, **o que
falta para chegar a 5**.

A regra que o define: **sem fonte, não há achado.** Toda afirmação traz a
evidência (o que ele fez, o número que mediu, a captura) e a base (o
princípio, com a referência). As referências são normas e pesquisa revisada
por pares (WCAG 2.2, CHI, IEEE VIS) e as diretrizes publicadas dos grandes
nomes da área (Apple HIG, Material e web.dev do Google, Figma, Canva,
Nielsen Norman Group, Baymard, GOV.UK). O que ele suspeita e não consegue
fundamentar não vira problema: vira pergunta para testar com usuários.

## O que ele avalia

| Área | Como | Base |
|---|---|---|
| Usabilidade | as tarefas reais de cada persona, heurísticas, percurso cognitivo do novato | Nielsen & Molich; Shneiderman; Wharton et al. |
| Esforço | passos e tempo previsto por tarefa | Keystroke-Level Model (Card, Moran & Newell) |
| Velocidade percebida | LCP, INP, CLS e tarefas longas medidos no navegador | Core Web Vitals (web.dev) |
| Os cinco estados | ideal, vazio, erro, parcial, carregando, com rede lenta e falha simuladas | UI Stack (Hurff); NN/g |
| Acessibilidade | contraste, alvos, teclado, foco, reflow a 320 px, espaçamento de texto, zoom 200% | WCAG 2.2; WAI-ARIA APG |
| Daltonismo | a tela filtrada por simulação fisiológica | Machado, Oliveira & Fernandes (IEEE TVCG 2009) |
| Sistema visual | tamanhos, pesos, espaçamentos, raios, cores, durações, ícones, e a escala proposta como tokens | escala modular; grade de 8; W3C Design Tokens |
| Hierarquia | testes do olho semicerrado e dos tons de cinza | Treisman; Healey & Enns; NN/g |
| Gráficos e tabelas | canal × tipo de dado, tinta, fator de mentira, escala de cor | Bertin; Mackinlay; Munzner; Tufte; Few |
| Formulários e textos | validação, rótulos, mensagens de erro | Baymard; Wroblewski; GOV.UK; NN/g |
| Ética | padrões enganosos no cadastro, consentimento, planos e cancelamento | Gray et al. (CHI 2018); Mathur et al. (CSCW 2019) |
| Tradução | pseudo-localização: o que corta quando o texto cresce | W3C i18n; Microsoft |
| Recursos de IA | confiança calibrada, procedência, saída manual | Google PAIR |
| Psicologia e emoção | o que a pessoa espera, o que ela deixa de ver, o que precisa guardar de cabeça, o que sente (primeira impressão, confiança, espera, o pior momento e o fim de cada tarefa) e o que empurra as decisões | Norman (*Emotional Design*); Lindgaard et al.; Tuch et al. (Google); Fogg et al. (Stanford); Pirolli & Card; Cowan; Kahneman; Peters, Calvo & Ryan; W3C COGA |

## Instalação

Requisitos: [Claude Code](https://code.claude.com) e a extensão
[Claude in Chrome](https://code.claude.com/docs/en/chrome) conectada.

```
/plugin marketplace add MatheusAraripe/UlissesXavier
/plugin install ulissesxavier@ulissesxavier
```

### Atualizações automáticas

O Claude Code só atualiza sozinho plugins de marketplaces em que a
atualização automática está ligada, e para marketplaces de terceiros ela vem
**desligada**. Ligue uma vez:

1. No Claude Code, digite `/plugin`.
2. Abra **Marketplaces** e escolha **ulissesxavier**.
3. Selecione **Enable auto-update**.

A partir daí, depois que você manda a primeira mensagem de uma sessão, o
Claude Code procura versões novas em segundo plano e avisa
`Plugin updated: ulissesxavier · Run /reload-plugins to apply`. A versão nova
vale com `/reload-plugins` ou na próxima sessão. O que mudou em cada versão
está no [CHANGELOG](CHANGELOG.md).

Para atualizar à mão, sem a atualização automática:

```
/plugin marketplace update ulissesxavier
```

## Uso

**1. Primeira vez no projeto: o perfil.** O avaliador precisa saber quem usa
o produto. Rode:

```
/ulissesxavier:ux-profile
```

A skill varre o repositório (README, rotas, campos do cadastro, textos,
idiomas), mostra a hipótese dela sobre o público e faz **poucas perguntas
curtas** para completar o que o código não diz: quem é o usuário principal,
a experiência dele, o dispositivo, a tarefa que precisa ser fácil, o que o
avaliador nunca pode tocar.

**Onde você responde:** no próprio chat do Claude Code, em perguntas de
múltipla escolha (com campo livre). Há três caminhos, e todos terminam no
mesmo arquivo, `.claude/ux-profile.md`:

| Caminho | O que acontece |
|---|---|
| `/ulissesxavier:ux-profile` | A skill pergunta direto, no chat, e grava o perfil. |
| Chamar o agente sem perfil | O agente roda em segundo plano e não fala com você: ele varre o projeto, grava um rascunho e devolve as perguntas ao Claude principal, que as faz no chat e chama o agente de novo com as respostas. |
| Editar o arquivo | `.claude/ux-profile.md` é markdown comum; o que estiver escrito ali vale mais que qualquer inferência. |

**2. Peça a avaliação** — pelo comando, com ou sem foco:

```
/ulissesxavier:ux-evaluate
/ulissesxavier:ux-evaluate só a tela de checkout
```

ou em linguagem comum:

```
Use o agente ulissesxavier para avaliar o app.
Use o ulissesxavier só na tela de checkout.
Use o ulissesxavier só no celular.
Use o ulissesxavier só no que mudou nesta branch.
```

Se ele travar em algo (senha, servidor, uma escolha sua), pergunta no chat
e continua de onde parou. Ele responde **no idioma em que foi chamado** e
guarda tudo numa pasta feita para navegar sem ajuda:

```
feedback/
  README.md                          índice: uma linha por varredura, com nota e link
  2026-10-14/
    v1-varredura-completa/
      ulissesxavier-2026-10-14-v1.md   o relatório (para ajustar com o seu Claude)
      ulissesxavier-2026-10-14-v1.pdf  o mesmo relatório diagramado (para ler e enviar)
      img/                             capturas citadas no relatório
    v2-mobile/                       segunda varredura do mesmo dia
```

A pasta pode ter outro nome; basta indicar no perfil.

**3. O relatório em PDF.** Numa varredura completa ele também exporta um PDF
diagramado (nos modos com foco, peça: "e exporte em PDF"). O documento
segue os princípios que o próprio relatório cobra: o essencial nas duas
primeiras páginas (capa, nota média, as três urgências, a maior força), os
problemas em cartões com a severidade por forma, palavra e cor, gráficos
desenhados a partir dos números do relatório (nota por área, matriz
severidade × esforço, sistema visual hoje → proposto, Core Web Vitals,
tempo por tarefa) e as referências numeradas no fim. Um **guia de
conceitos** explica em linguagem simples cada termo, teoria e autor citado
(o limiar de Doherty, as heurísticas de Nielsen, o WCAG…), e a primeira
menção de cada um no texto fica sublinhada com pontilhado, ligada ao
verbete. O relatório é escrito uma vez só, em markdown; o próprio modelo do
PDF o lê e diagrama. Quem gera é o Chrome ou o Edge em modo sem janela, sem
instalar nada. Também dá para gerar depois,
de um relatório que já existe: `/ulissesxavier:ux-report-pdf`.
Veja [o exemplo](examples/maria-view/relatorio-exemplo.pdf).

## Quando ele trava, ele pergunta

O agente roda em segundo plano e não fala direto com você, mas não desiste
da avaliação por causa de um bloqueio: uma senha que falta, um servidor que
não sobe, uma escolha que só você pode fazer. Ele avança no que o bloqueio
não impede, salva o progresso no rascunho do relatório e devolve ao Claude
principal uma pergunta pronta. O Claude te pergunta no chat e **retoma o
mesmo agente** com a sua resposta; ele continua de onde parou, com tudo o que
já tinha visto. Só um "pode pular" seu encerra uma parte, e o relatório diz
o que ficou de fora e por quê.

## O que ele não faz

- **Não edita o seu código.** Avalia, mede e propõe.
- **Não substitui teste com pessoas.** Um avaliador especialista encontra uma
  fração dos problemas (Nielsen & Landauer, 1993), e um modelo de linguagem
  não é usuário (NN/g, *Synthetic Users*). Todo relatório termina com o que
  precisa ser confirmado com gente de verdade.
- **Não deixa rastro.** Ele mesmo sobe os servidores do app (o comando de
  cada um fica no perfil), reaproveita o que você já tinha rodando sem
  fechá-lo e, no fim, derruba só o que subiu, com a árvore de processos
  inteira. Logs e PIDs ficam numa pasta temporária fora do repositório.
- **Só entra com a conta de teste que você der.** O jeito natural é dizer no
  chat: *"use o ulissesxavier com o login qa@exemplo.com e a senha …"*.
  Também dá para anotar o login no perfil, com a senha numa variável de
  ambiente. Sem conta, ele avalia o que não exige login e pede uma antes
  das telas com sessão. Ele nunca cria conta e nunca escreve a senha em
  arquivo, relatório ou resposta.
- **Não apaga dado real.** Fluxos destrutivos são testados interceptando o
  `fetch` da página, com os dados intactos.

## Custo

Uma varredura completa é longa: percorre o app inteiro com capturas de tela.
O que o agente faz para gastar menos sem perder análise:

- **Mede com um kit pronto** (`ux-audit`): um script injetado uma vez por
  página devolve alvos, contraste e o inventário visual de uma tela em JSON
  curto, em vez de o agente escrever código de medição a cada tela.
- **Texto antes de imagem**: capturas em meia escala, com teto por
  varredura; o que se responde com texto não vira captura.
- **Escreve o relatório uma vez**: o markdown é a fonte do PDF; nada é
  escrito duas vezes.
- **Consulta, não lê**: a bibliografia e o guia de conceitos-base ficam em
  arquivos que ele busca por palavra, fora do prompt fixo.
- **Confere o PDF por uma imagem**: uma captura com todos os gráficos, em
  vez de ler o documento página por página.

Para o dia a dia, prefira um foco ("só tipografia e espaçamento") ou o modo
regressão ("só o que mudou nesta branch").

## Exemplo

[`examples/maria-view/`](examples/maria-view/) traz o perfil do projeto
onde o agente nasceu: o Maria.View, um app web que lê saídas de química
quântica e desenha a molécula em 3D. As duas primeiras varreduras acharam
três caminhos de perda de dado sem desfazer, texto a 3,26:1 (abaixo do AA)
e um sistema visual com 12 tamanhos de fonte, 12 raios e 13 níveis de
`z-index`. Os três primeiros foram corrigidos na mesma semana.

## Licença

[MIT](LICENSE)
