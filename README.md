# Sistema Autônomo de Execução Estratégica (Shizuku Interface)

Este projeto implementa a interface de controle em Flutter para o **Sistema Autônomo de Execução Estratégica**, projetado para rodar inferências táticas em tempo real sobre o ambiente do Clash Royale. A aplicação atua como um painel de gerenciamento para as camadas de visão computacional, modelo de IA embarcado e injeção de comandos via Shizuku.

## Funcionalidades do Painel

*   **Status de Sistemas:** Monitoramento em tempo real do estado do serviço Shizuku, da taxa de quadros de captura de tela e do status do motor TensorFlow Lite.
*   **Controle de Execução:** Botão de ativação global para iniciar o ciclo fechado de observação, predição e ação.
*   **Métricas em Tempo Real:** Exibição de inferência de latência, probabilidade de predição do elixir do oponente e detecção de ameaças.
*   **Log de Decisões:** Visualizador das ações táticas recomendadas pelo modelo de Deep RL antes da execução.

## Stack Tecnológica da Interface

*   **Flutter & Dart:** Framework de UI para construção do painel de controle fluido e responsivo.
*   **Material Design 3:** Utilizado para criar uma interface limpa, focada em métricas e status operacionais.
*   **Conceito de Arquitetura Subjacente:** A interface foi projetada para interagir com o Core Engine (TensorFlow Lite / C++ / OpenCV Mobile) e o Input Pipeline via APIs nativas no futuro.

## Setup e Execução

1.  Certifique-se de que o [Shizuku](https://shizuku.rikka.app/) está instalado e em execução no dispositivo Android alvo.
2.  Clone este repositório e instale as dependências:
    ```bash
    flutter pub get
    ```
3.  Execute a aplicação no seu dispositivo físico (Emuladores não suportarão o pipeline de visão adequadamente):
    ```bash
    flutter run
    ```

---

## Sobre CouldAI

Este aplicativo foi gerado com o [CouldAI](https://could.ai), um construtor de aplicativos de inteligência artificial multiplataforma que transforma prompts em aplicativos nativos de produção para iOS, Android, Web e Desktop utilizando agentes autônomos que arquitetam, constroem, testam, implantam e iteram soluções completas.