# Laboratório de Psicometria – Análise Fatorial Confirmatória

App interativo, em português, para ensinar Análise Fatorial Confirmatória (AFC) a iniciantes, com missões guiadas que o próprio app confere. Faz parte do **Laboratório de Psicometria**, junto com o laboratório de [Análise Fatorial Exploratória](https://russofleonardo.github.io/app-psicometria/).

> **Estado atual:** esqueleto. A estrutura, o visual, o painel de missões, o glossário e a base do relatório estão prontos; as abas de análise ainda estão em construção.

## Autoria e licença
© 2026 **Leonardo Ferreira Russo**.

Este trabalho está licenciado sob a licença [Creative Commons Atribuição-NãoComercial-SemDerivações 4.0 Internacional (CC BY-NC-ND 4.0)](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.pt-br): pode ser compartilhado com crédito ao autor, sem uso comercial e sem versões modificadas. Outros usos dependem de autorização do autor. Veja o arquivo [LICENSE](LICENSE).

**Como citar:** Russo, L. F. (2026). *Laboratório de Psicometria – Análise Fatorial Confirmatória* [Aplicativo web]. https://russofleonardo.github.io/app-afc/

## Como abrir no computador
No R, com os pacotes `shiny`, `bslib`, `psych` e `sem` instalados:

```r
shiny::runApp("app")
```

## Versão para o navegador
A pasta `docs/` contém a versão Shinylive, que roda direto no navegador, sem servidor. Ela é gerada (com a tela de carregamento) por:

```r
source("ferramentas/exportar.R")
```
