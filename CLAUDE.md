# Regras do projeto

App Shiny em R para ensinar Análise Fatorial Confirmatória (AFC) a iniciantes. Faz parte do **Laboratório de Psicometria** (o primeiro app da série é o de AFE: https://github.com/russofleonardo/app-psicometria). O foco é ensinar AFC, não R. O usuário não é programador: explique tudo de forma simples, em português.

## Git e GitHub
- O projeto fica no repositório `app-afc` no GitHub do usuário.
- Ao terminar cada etapa que esteja funcionando, faça um commit com mensagem clara em português e dê push para o GitHub.
- Antes de qualquer mudança grande, confirme que o que já funciona está salvo no GitHub.
- Nunca suba senhas, chaves ou arquivos `.env`. Garanta que estejam no `.gitignore`.
- No fim de cada sessão, diga ao usuário o que foi salvo e se ficou algo pendente.

## Publicação (GitHub Pages)
- O app é publicado em https://russofleonardo.github.io/app-afc/, a partir da pasta `docs/` (GitHub Pages, branch `main`, pasta `/docs`).
- **Sempre que alterar algo em `app/`**, antes do commit: teste no R, gere de novo a versão do navegador com `source("ferramentas/exportar.R")` (não use `shinylive::export` direto: o script também ajusta a página de abertura — título, idioma e a tela "Carregando…") e inclua a pasta `docs/` no mesmo commit.
- Depois do push, o GitHub leva 1 a 2 minutos para atualizar o link. Quem já abriu o app pode precisar recarregar com Ctrl+F5.
- O progresso das missões fica salvo no navegador pelo `id` de cada missão (`app/missoes.R`). As missões podem ser reordenadas, inseridas ou retiradas, mas o `id` de uma missão existente **nunca** muda; missão nova ganha um `id` novo e único.

## Autoria e licença
- Autor: Leonardo Ferreira Russo. Licença: CC BY-NC-ND 4.0 (arquivo `LICENSE`).
- Mantenha o aviso de autoria onde ele está: rodapé da barra lateral e seção "Autoria, licença e como citar" da aba 0 (vêm de `base_laboratorio.R`), cabeçalho de cada arquivo `.R`, `README.md` e `LICENSE`. Arquivos `.R` novos também ganham o cabeçalho.

## Notas técnicas
- O app é publicado com Shinylive (roda no navegador via webR, sem servidor). Use apenas pacotes que funcionam no webR. Pacotes previstos: `shiny`, `bslib`, `psych`, `GPArotation` e **`sem`** (para a AFC). Gráficos em R base.
- **O `lavaan` NÃO roda no navegador** (testado em nov/2026): ele aparece no repositório do webR, mas depende do `quadprog`, que não existe para o webR, e por isso não carrega. O pacote **`sem` funciona** (testado: AFC de 5 fatores com os 25 itens do Big Five em cerca de 3 s no navegador).
- Antes de usar qualquer pacote novo, teste se ele carrega e roda no navegador (exportar e abrir), não só se ele aparece no repositório do webR.
- Toda a interface fica em português, com números no formato brasileiro (`fmt()`, `fmt_int()`, `fmt_pct()` em `base_laboratorio.R`).
- Estrutura do código em `app/`:
  - `app.R`: a tela e o servidor deste app;
  - `base_laboratorio.R`: **peças comuns do Laboratório de Psicometria** (visual, painel de missões, glossário, relatório, autoria). Não coloque nada específico de AFC nele. Se melhorar algo ali, vale levar a melhoria aos outros apps do laboratório;
  - `dados.R`: dados e rótulos dos itens;
  - `glossario.R`: definições dos termos (use `termo()` / `termo_html()` no texto);
  - `missoes.R`: o roteiro das missões.
- A versão exportada para o navegador fica em `docs/`.
