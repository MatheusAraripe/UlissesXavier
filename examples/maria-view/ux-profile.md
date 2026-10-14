# Perfil de UX — Maria.View

## Produto
App web que lê saídas de química quântica do ORCA (`.out`/`.log`) e arquivos
cristalográficos (`.cif`), ou gera estruturas a partir de um nome, SMILES ou
descrição, e as mostra em 3D numa mesa de trabalho infinita (estilo
Figma/Stitch) com gráficos de energia e IR, tabelas de carga e de ligação,
medições de distância/ângulo/diedro e notas. Domínio: química computacional,
no ensino e na pesquisa.

## Usuários e tarefas
| Persona | Experiência | Dispositivo | Frequência | Tarefas principais (em ordem) |
|---|---|---|---|---|
| Pesquisador | usa ORCA/Gaussian e visualizadores (Avogadro, GaussView, Chemcraft) | desktop | semanal | abrir um `.out`, saber se a otimização convergiu, achar a carga de um grupo, comparar Mulliken com Löwdin, medir distância e diedro, ler o IR, exportar figura para artigo |
| Professor | conhece química, nem sempre o software | desktop / projetor | semanal | montar uma molécula conhecida ("cafeína"), deixá-la grande e legível, mostrar uma propriedade, exportar a imagem |
| Estudante | primeira vez, sem saber o que o app faz | desktop e celular | eventual | entender o que o app faz, descrever uma molécula pelo nome, descobrir sozinho que pode selecionar átomos e medir |

Restrições: a API dorme no plano gratuito do Render (~1 min para acordar); a
interface é em português.
Produtos de referência que o público já conhece (lei de Jakob): GaussView,
Avogadro, Chemcraft; Figma e Canva para a mesa.

## Como chegar ao app
O agente sobe e derruba os servidores com a skill `ux-serve`: o que já
estiver rodando é reaproveitado e não é fechado; o que ele subir, ele fecha.
Servidor de desenvolvimento — os tempos de carregamento medidos nele não
representam produção.

```servers
api | backend | uv run uvicorn app.main:app --port 8000 | http://localhost:8000/health
web | .       | npm run dev -- --port 5173 --strictPort | http://localhost:5173/
```


## Conta de teste
O agente só usa a conta que recebe — no chat, ao ser chamado, ou aqui — e
nunca cria conta.
- Login e senha: **passados no chat** ("avalie com o login X e a senha Y").
  Sem eles, o agente avalia o que não exige sessão e pede a conta pelo Claude
  principal antes das telas com login.
- A senha nunca é escrita neste arquivo.
- Conta descartável, sem dados reais: a avaliação pode criar áreas de
  trabalho, medições e notas nela (respeitando o teto de 3 slots).
- Abrir arquivo pela URL `#/analise/<id>`; a ordem das linhas da tela inicial
  muda.

## Limites de segurança
- **Dados reais**: o histórico (teto de 3 slots), as medições e as notas são do
  usuário.
- Não apagar slots; não usar a lixeira do registro (apaga as medições no
  servidor); não usar "Desfazer", "Limpar geometria" nem edições em molécula
  que não tenha sido criada na avaliação.
- Com o histórico cheio, gerar pelo terminal, anexar ou começar por peça
  **sobrescreve o slot aberto**: só testar com slot livre; senão, "não
  testado: histórico cheio".
- O gerador chama um modelo pago por cota: **no máximo 3 pedidos** por
  varredura (um nome comum, uma descrição, um pedido que deveria ser recusado
  ou perguntado).
- Notas criadas: apagar antes de terminar (lixeira em dois cliques). Medições
  não têm remoção individual: listar no relatório quais foram criadas.
- O arranjo da mesa é do navegador e pode ser mexido; anotar o arranjo inicial
  e deixar parecido no fim.
- Apagar com segurança: trocar o `fetch` da página por um que responde 204 a
  todo `DELETE` e anota — assim o "Desfazer" e o prazo correndo até o fim se
  observam com os dados intactos.

## Telas e fluxos a percorrer
1. Entrada: `#/login`, `#/criar-conta`, tela inicial `#/` e histórico (vazio,
   carregando, erro, cheio).
2. Área vazia `#/analise`: os três caminhos (anexar, descrever, peças).
3. A mesa: deslocar (roda, espaço + arrastar, botão do meio), zoom (Ctrl +
   roda, botões, Shift+1, Shift+0), caixa de seleção, agrupar (Ctrl+G),
   renomear e desagrupar, alças, zoom semântico (fichas), grade de pontos,
   nitidez dos gráficos com zoom.
4. A molécula: girar (direito, só na área dela), mover, redimensionar pela
   alça, selecionar átomos (cursor bolha, anel de passagem), o menu de ações
   em anotação, medir (cota abaixo da opção, registro, ponto de "novo"), ciclo
   e energia na barra.
5. Quadros: o menu "Itens" e cada entrada, arrastar, esticar, fechar, exportar
   PNG (observar o modal), pintar o mapa de calor pela tabela, ligação tabela ↔
   átomo e perfil ↔ ciclo, "lido de … · linha N".
6. Montagem (só em molécula criada na avaliação): paleta, variantes, trocar,
   ligar, carga, remover, desfazer, limpar geometria.
7. Terminal: registro aberto/recolhido, procedência, gerador (pergunta de
   esclarecimento, Esc), selo beta, erros.
8. Configurações: engrenagem, tema claro/escuro em todas as telas.
9. Espera e erro: o fio, a tarja, o contador; id inexistente na URL.
10. Celular: 390 × 844 e 768 × 1024.

## Decisões e pendências
- Decisões de interface e o porquê: `CLAUDE.md` (já injetado no contexto — não
  reler; usar Grep com a palavra-chave).
- Base teórica e recomendações numeradas: `interface-fundamentos.md` (ler uma
  vez; "Recomendações em ordem").
- Pendências: as listas "Em aberto" do `CLAUDE.md` e de
  `interface-fundamentos.md`.
- Grafo do código: `graphify query` / `graphify explain`, só para localizar o
  arquivo de um problema ou estimar esforço — ele não responde sobre decisões.
- Relatórios anteriores: `relatorios-ux/` (gravar os novos ali).

## Peculiaridades conhecidas (não são defeitos do app)
- O primeiro pedido pode levar ~1 min com a API hibernando: avaliar como o
  app comunica a espera.
- Decisões que parecem defeito e foram medidas: sem sombra, sem linha de
  separação, vidro líquido só nos elementos do sistema, o direito gira a
  molécula, a cota da medição some sozinha.
