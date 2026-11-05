# Blueprint — agent-project/memory.md

> `memory.md` **décrit** le projet : stack, commandes, structure, conventions observées. Il est lu à chaque
> session : il reste court et factuel.
> Ce qui est **imposé** (interdictions, anti-patterns, règles d'équipe) va dans `agent-project/rules.md`.
> Le détail d'architecture va dans `agent-project/architecture.md`, les règles métier dans
> `agent-project/business-rules.md`.

---

## Création (commande `init`, voir `agent/commands.md`)

Le type de projet (existant, starter, vierge) est déterminé par `init`. Selon le cas :
- **existant** : analyser le code (ci-dessous) et ne remplir que ce qui en est déduit ;
- **starter** : analyser l'ossature seulement, la stack est une contrainte imposée ;
- **vierge** : rédiger à partir des choix validés avec `agent/stacks/<langage>/decisions.md`.

Ce qui demande une décision de l'utilisateur reste `[À DÉFINIR]` dans le draft, puis est tranché ou
supprimé avant écriture.

### Analyse (projet existant)
- Fichiers de dépendances et de configuration (`composer.json`, `package.json`…), CI, Docker
- Langage, framework, base de données, bibliothèques importantes, avec versions
- 5 à 10 fichiers représentatifs par type (contrôleurs, services, modèles, vues, tests) : nommage,
  placement, patterns
- Framework de test, emplacement et nommage des tests
- Outils de qualité présents (analyse statique, formatage, audit de dépendances) et leurs commandes

## Structure

```markdown
# Mémoire projet — [Nom du projet]

> [Framework + version · Langage + version] · Dernière mise à jour : [AAAA-MM-JJ]

## Stack
- Langage / framework / base de données : …
- Bibliothèques importantes : …

## Commandes de vérification
> Lancées par l'agent sans demander. Elles ne modifient aucun fichier.
- Tests : [ex : `php artisan test`]
- Lint : [ex : `vendor/bin/pint --test`]
- Analyse statique : [ex : `vendor/bin/phpstan analyse`]
- Audit des dépendances : [ex : `composer audit`]

## Autres commandes
> Jamais lancées sans permission.
- Dev / build / migrations : …

## Structure
- `[dossier]` : [rôle]

## Conventions observées
- Nommage (fichiers, classes, méthodes, tables, routes) : …
- Placement (où va quoi) : …
- i18n : [non / oui — langues, fonction utilisée]

## Tests
- Framework : … · Emplacement : … · Nommage : …

## Interface
- Framework UI, emplacement des composants : … (détail : `agent-project/design.md`)

## Architecture
- Direction : [custom | ddd-lite | existante décrite] — détail : `agent-project/architecture.md`
- Résumé : [2 à 5 lignes]

## Sécurité
- Socle : `agent-project/security.md`

## Changelog
- [AAAA-MM-JJ] : création
```

## Maintenance

- Court : c'est le fichier projet lu à chaque session. Pas d'exemple de code, pointer vers un fichier de
  référence du projet.
- Ne pas répéter ce qui vit dans `architecture.md`, `rules.md`, `business-rules.md`, `design.md`.
- Une commande de vérification qui ne marche plus est corrigée dès qu'on s'en aperçoit (proposition + validation).
- Toute modification est proposée puis validée, et tracée dans le changelog.
