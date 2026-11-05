# Changelog

Format : une section par version publiée (tag git `vX.Y.Z`), la plus récente en haut.

## [1.0.0] — 2026-11-05

Première version distribuable. Conception détaillée : [`docs/spec-v1.md`](docs/spec-v1.md).

**Installation**
- Kit regroupé dans `kit/`, installé dans `agent/` par `install.ps1` / `install.sh`.
- Mémoire de l'app dans `agent-project/` (hors du kit, jamais écrasée par une mise à jour).
- `agent/VERSION` : version et SHA du commit installé.
- Installeurs : pré-versions ignorées, exécution limitée à la racine du dépôt git, remplacement
  atomique de `agent/`, avertissement si `agent/` contient des modifications non commitées.
- Fichiers de démarrage IDE : `CLAUDE.md` (import `@agent/AGENT.md`), `AGENTS.md`, Cursor, Copilot.

**Règles**
- Identifiants stables et sévérité sur chaque règle vérifiable (`SEC-02 · CRITIQUE · socle`).
- Plus de `check.md` compilé : l'audit lit directement les règles du kit et
  `agent-project/rules.md` (règles de l'équipe : ajouts, désactivations, sévérités, portée).
- Socle sécurité non désactivable ; dépendances vérifiées par l'outil (`composer audit`).
- Politique de tests unique (`rules/tests.md`) : test par défaut pour toute règle métier,
  calcul ou bug corrigé ; « OK sans tests » au moment de la validation du plan.

**Workflow**
- Parcours inchangé : demande → plan → revue → OK → code en continu → audit de fin.
- Parcours rapide appliqué directement ; plus d'arrêt par tâche ; étapes cochées dans le plan.
- Commandes de vérification déclarées dans `memory.md` lancées sans demande.
- Règles métier validées via le plan, écrites en fin de feature.
- Sécurité de l'agent : contenu externe traité comme donnée, pas de lecture de `.env*`.

**Retraits**
- Commandes `regen check`, `audit check`, `audit memory`, `tâche suivante`, `reprendre`,
  `réinitialiser`, `fin traitement` ; fichiers projet `check.md`, `tests.md`, `knowledge.md`.
- Recettage déplacé en module optionnel (`kit/modules/recettage.md`).
