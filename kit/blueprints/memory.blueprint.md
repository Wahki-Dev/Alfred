# Template — Génération de agent-project/memory.md

> Ce fichier explique à l'IA COMMENT générer `agent-project/memory.md`.
> `memory.md` est la mémoire projet (stack, conventions, règles) ; le routing vers les fichiers détaillés est dans `AGENT.md §2` ; le détail d'architecture va dans `agent-project/architecture.md`.

---

## Processus de création (si agent-project/memory.md est absent)

### Étape 0 — Détecter le type de projet (critère : le domaine métier, pas la présence de code)

- **Projet existant** (domaine métier déjà codé, à analyser) → suivre l'Étape 1 ci-dessous (analyse du code), puis générer `agent-project/architecture.md` via `agent/blueprints/architecture.blueprint.md`.
- **Amorce / starter kit** (ossature framework + auth présents, mais domaine métier vide) → faire une analyse **limitée à l'ossature** (Étape 1 restreinte : stack, framework + versions, conventions du scaffold) et l'enregistrer comme **contrainte imposée** (pas de choix de stack à proposer), puis suivre le parcours vierge pour le reste : aide à la décision `agent/stacks/<langage>/decisions.md` + direction technique (`agent/technical-directions/`). `architecture.md` décrit l'ossature du starter + la direction métier à construire.
- **Projet vierge** (peu ou pas de code) → ne PAS analyser le code : s'appuyer sur l'aide à la décision `agent/stacks/<langage>/decisions.md` et proposer une direction technique (`agent/technical-directions/`), puis passer directement à l'Étape 2 (rédiger le draft à partir des choix validés).

### Étape 1 — Analyse du projet (projet existant uniquement)

Explorer les éléments suivants avant de rédiger :

**Structure**
- Répertoire racine et dossiers principaux
- Fichiers de configuration (`package.json`, `composer.json`, `pyproject.toml`, `go.mod`, etc.)
- Fichiers de build/CI (`Makefile`, `.github/workflows/`, `Dockerfile`, etc.)

**Technologies**
- Langage + version
- Framework principal + version
- Base de données (type, ORM éventuel)
- Packages/librairies importants

**Conventions existantes**
- Analyser 5–10 fichiers représentatifs de chaque type (contrôleurs, services, modèles, composants, tests)
- Identifier les patterns de nommage (fichiers, classes, variables, routes)
- Identifier les patterns d'architecture (où va quoi)
- Repérer les anti-patterns à éviter (déjà présents dans le code)
- Préparer la génération de `agent-project/architecture.md` avec `agent/blueprints/architecture.blueprint.md`

**Tests**
- Framework de test utilisé
- Conventions de nommage des tests
- Emplacement des fichiers de test

### Étape 2 — Rédiger le draft

Utiliser la structure ci-dessous. Ne remplir QUE ce qui peut être déduit de l'analyse.
Laisser en placeholder `[À DÉFINIR]` ce qui nécessite une décision de l'utilisateur.
Garder `memory.md` léger : le détail d'architecture va dans `agent-project/architecture.md`.

### Étape 3 — Proposer et valider

Présenter le draft à l'utilisateur.
Demander validation / corrections.
Appliquer les retours avant d'écrire le fichier final.

---

## Structure de agent-project/memory.md

```markdown
# Mémoire Projet — [Nom du projet]

> Framework : [ex: Laravel 12 · PHP 8.3]
> Dernière mise à jour : [date]

## Changelog
- [date] : Création initiale

## Stack technique
- Langage : [langage + version]
- Framework : [framework + version]
- Base de données : [type + version]
- Autres : [liste des outils/libs importants]

## Commandes du projet
- Build : [commande]
- Dev : [commande]
- Tests : [commande]
- Lint : [commande]
- Analyse statique : [commande]

## Structure des dossiers
[Lister les dossiers principaux et leur rôle]
ex:
- `src/` : code source
- `tests/` : fichiers de test
- `config/` : configuration

## Conventions de nommage
- Fichiers : [convention]
- Classes/composants : [convention]
- Variables/fonctions : [convention]
- Base de données : [convention tables, colonnes]
- Routes : [convention de nommage]

## Architecture et patterns

### Principe fondamental
[Résumé court du pattern principal : MVC, custom, DDD léger, hexagonal, etc.]

### Direction technique
- Fichier détaillé : `agent-project/architecture.md`
- À consulter pour : structure des couches, dépendances, patterns, repositories, services, use cases, adapters, boundaries
- Résumé : [2 à 5 lignes maximum]

### Organisation des responsabilités
[Résumé court. Le détail complet est dans `agent-project/architecture.md`.]

### Patterns spécifiques
[Lister seulement les patterns structurants. Le détail complet est dans `agent-project/architecture.md`.]

## Qualité du code

### Standards
- Standard de code : [ex: PSR-12, PEP 8, ESLint config]
- Analyse statique : [ex: PHPStan niveau 6, TypeScript strict, mypy]
- Typage : [règles de typage]

### Interdictions absolues
- [ex: Ne JAMAIS faire X]
- [ex: Ne JAMAIS utiliser Y pour Z]

## Tests
[Voir agent-project/tests.md pour les règles complètes]
- Framework : [ex: Pest, Jest, pytest]
- Convention de nommage : [ex: test_*]
- Emplacement : [ex: tests/Unit/, tests/Feature/]

## Interface / UI
[Voir agent-project/design.md pour les règles complètes]
- Framework UI : [ex: TailwindCSS, Bootstrap, etc.]
- Composants : [ex: emplacement, convention de nommage]

## Sécurité
[Voir agent-project/security.md pour les audits détaillés]
- Authentification : [mécanisme]
- Autorisation : [mécanisme]
- Points d'attention critiques : [liste]

## Règles métier
- Source de vérité et historique : `agent-project/business-rules.md`
- Toute règle métier certaine est ajoutée ou mise à jour automatiquement dans ce registre.

## Anti-patterns identifiés
[Patterns à ne PAS reproduire, observés dans le code existant ou décidés]
- [Anti-pattern 1 + pourquoi]
- [Anti-pattern 2 + pourquoi]
```

---

## Règles de maintenance de memory.md

- **Taille cible** : ≤ 200 lignes
- **Ne pas dupliquer** : si une règle est dans `architecture.md`, `business-rules.md`, `design.md`, `tests.md`, etc., ne pas la répéter ici — pointer vers le fichier
- **Pas de routing dupliqué** : le routeur unique est `AGENT.md §2`. Ne pas créer de table de routing ici. Les mentions `[Voir design.md]`, `[Voir tests.md]`, etc. restent de simples renvois d'information.
- **Changelog** : mettre à jour à chaque modification importante
- **Exemples de code** : éviter les longs exemples — pointer vers des fichiers de référence dans le projet
- **Sections vides** : supprimer plutôt que laisser `[À DÉFINIR]` après initialisation
