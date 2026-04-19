# 🎓 Euro Academy - Plataforma de Treinamentos

> **Status:** 🚀 Lançamento Oficial (v1.0) | Otimizado para Desktop/Laboratórios

O **Euro Academy** é uma plataforma corporativa de gestão de treinamentos desenvolvida para a **Eurofarma**. Este projeto é fruto do 6º semestre de Sistemas de Informação na **FIAP** e tem como foco principal a alta fidelidade visual e a segurança de acesso aos dados.

## 📸 Interface de Login
<img width="1919" height="1021" alt="image" src="https://github.com/user-attachments/assets/b8e33740-e0e4-46a4-8739-8cebdf26468d" />

## 📸 Interface de @2FA
<img width="1919" height="908" alt="image" src="https://github.com/user-attachments/assets/6296e158-03fe-4585-a683-595a403cd31a" />

## 📸 Interface logada
<img width="1919" height="921" alt="image" src="https://github.com/user-attachments/assets/e126a03f-ff5c-4736-90e0-212e22eb6f4d" />

## 🛠️ Stack Tecnológica
- **Frontend:** [Flutter](https://flutter.dev) (Motor Gráfico: **CanvasKit** para Web)
- **Backend & Auth:** [Firebase](https://firebase.google.com) (Authentication & Identity Platform)
- **Segurança:** Autenticação Multifator (2FA/TOTP) via Aplicativo Autenticador.
- **Gerência de Estado:** Provider
- **Padrões & Arquitetura:** Clean Architecture + MVVM (Model-View-ViewModel) + Injeção de Dependências (GetIt).

## 🏗️ Arquitetura do Sistema

O projeto segue os princípios da Clean Architecture para separar regras de negócio da interface visual e da comunicação com o servidor:

```mermaid
graph TD
    subgraph Frontend Flutter
        UI[Pages & Widgets] --> VM[ViewModels / Provider]
        VM --> Usecases[Use Cases / Regras de Negócio]
        Usecases --> Repos[Repositories]
    end

    subgraph Backend Firebase
        Repos -. Comunicação .-> Auth[Firebase Authentication]
        Auth --> Identity[Identity Platform MFA]
        Identity --> GoogleAuth[App Google Authenticator]
    end

    %% Estilização para o GitHub
    style UI fill:#02378F,stroke:#fff,stroke-width:2px,color:#fff
    style Auth fill:#FFCA28,stroke:#333,stroke-width:2px,color:#333
    style Identity fill:#FFCA28,stroke:#333,stroke-width:2px,color:#333
```

## 🚀 Como executar o projeto localmente
Para desenvolvedores, professores ou colegas de grupo que desejam clonar e testar o projeto, siga o manual abaixo.

⚠️ Atenção: Como o design do projeto foi projetado especificamente para monitores, ele deve ser executado no navegador para garantir que os gradientes e vetores funcionem perfeitamente.

Passo 1: Pré-requisitos
Flutter SDK instalado.

Navegador Google Chrome.

Um aplicativo de Autenticação no celular (Google Authenticator, Authy, Microsoft Authenticator, etc.) para testar o fluxo de 2FA.

Passo 2: Clonagem e Setup

Abra o seu terminal e execute:
# 1. Clone este repositório
git clone [https://github.com/CallmeKdu/eurotrainer-platform.git](https://github.com/CallmeKdu/eurotrainer-platform.git)

# 2. Entre na pasta do projeto
cd eurotrainer_platform

# 3. Baixe todas as dependências
flutter pub get

Passo 3: Executando o App
Para iniciar o servidor local, utilize o comando:

flutter run -d chrome

## 🌳 Fluxo de Trabalho (Gitflow)

O desenvolvimento da v1.0 seguiu o padrão Gitflow, garantindo que a `main` estivesse sempre estável enquanto as funcionalidades eram testadas na `develop`.

```mermaid
gitGraph
    commit id: "Projeto Inicial"
    branch develop
    checkout develop
    commit id: "Config base"
    
    branch feature/auth-2fa
    checkout feature/auth-2fa
    commit id: "UI Login"
    commit id: "Firebase Auth"
    commit id: "TOTP Logic"
    
    checkout develop
    merge feature/auth-2fa
    commit id: "Ajustes de Design"
    
    checkout main
    merge develop tag: "v1.0"
    commit id: "Lançamento Oficial 🚀"

```
Desenvolvido por EuroTrainers 
Carlos Eduardo Martins Freire | Maria Alice Sousa Santos | Pedro Henrique Lima | Thaís Mari Costa Lopes | Projeto Acadêmico FIAP - 2026
