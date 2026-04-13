# EuroAcademy

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

```mermaid
gitGraph
    commit id: "chore: init"
    branch develop
    checkout develop
    commit id: "feat: base clean"
    branch feature/auth-ui
    checkout feature/auth-ui
    commit id: "feat: login panel"
    checkout develop
    merge feature/auth-ui tag: "PR #1"
    branch feature/auth-validation
    checkout feature/auth-validation
    commit id: "feat: regex"
    checkout develop
    merge feature/auth-validation tag: "PR #2"
