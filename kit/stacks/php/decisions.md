# Aide à la décision — Démarrage d'un projet PHP

> Lu uniquement par la commande `init`, pour un projet **vierge** ou un **starter** (voir `agent/commands.md`).
> Pas lu à l'audit. Sert à rédiger `agent-project/memory.md` et `agent-project/architecture.md`.
> But : proposer des défauts modernes et solides, poser PEU de questions, laisser l'utilisateur trancher.

## Principe directeur (anti-sur-ingénierie)
- Commencer **simple** : un pattern n'entre que s'il répond à un besoin réel et présent (YAGNI).
- Proposer un défaut recommandé pour chaque décision, **jamais imposer**.
- Ne poser que les questions qui changent réellement l'architecture.
- Pas de Repository / DDD / CQRS / event sourcing « au cas où ».

---

## Cadrage (toutes stacks PHP) — questions à poser
1. Framework ? (Laravel · Symfony · CakePHP · autre) — *starter : déjà imposé, ne pas reposer la question*
2. Nature dominante ? (CRUD administratif · application métier · API · mixte)
3. Multilingue (i18n) nécessaire ? (oui / non, et quelles langues)
4. Framework de test ? (défaut proposé ci-dessous ; les tests sont prévus par défaut, voir `agent/rules/tests.md`)
5. Base de données ? (MySQL/MariaDB · PostgreSQL · SQLite · autre)

→ À partir des réponses : drafts de `memory.md` (stack, commandes de vérification, conventions)
et `architecture.md` (direction `custom` par défaut, voir `agent/technical-directions/`).

---

## Laravel — matrice de décision

> Les règles vérifiables des controllers sont dans `agent/stacks/php/laravel.md` (LAR-01 à LAR-03).
> Ici = choix greenfield. Garder les deux cohérents.

**Controllers**
| Contexte | Défaut proposé |
|---|---|
| CRUD administratif simple | Resource Controller (`index/show/store/update/destroy`) |
| Action métier explicite et isolée | Single Action Controller (`__invoke`) |
| Sous-ressource / contexte précis | Controller dédié dans un sous-dossier (`Users/UpdateStatusController`) |

**Logique métier** : thin controller → **Service** (ou **Action** pour un cas unitaire). Repository **seulement** si accès données complexe, réutilisé ou multi-source ; sinon Eloquent direct.
**Validation** : FormRequest dès que la validation est non triviale.
**Données** : Eloquent · `enum` PHP pour statuts/types · casts explicites · `$fillable` explicite.
**Structure** : `app/Services`, `app/Actions`, `app/Enums` créés **au premier besoin**, pas en avance.
**Auth (si besoin)** : web → Breeze/Fortify · API → Sanctum.
**Tests** : Pest.
**Vérification** : Pest · Larastan · Pint (`--test`) · `composer audit`.

---

## Symfony — matrice de décision

**Controllers** : fins (`AbstractController`), routing par `#[Route]` → logique dans des **services autowirés**.
**Validation** : DTO + `#[Assert\...]` (Validator) ; composant Form si formulaires riches.
**Données** : entités Doctrine + le Repository généré par entité.
**Sécurité** : Voters / `#[IsGranted]` dès qu'il y a des règles d'accès.
**Structure** : standard Symfony (`src/Controller`, `src/Service`, `src/Entity`, `src/Repository`).
**Tests** : PHPUnit (+ Foundry pour les fixtures si besoin).
**Vérification** : PHPUnit · PHPStan · PHP-CS-Fixer (`--dry-run`) · `composer audit`.

---

## CakePHP — matrice de décision

**Controllers** : fins → logique dans les **Table objects** ou des services ; conventions Inflector respectées.
**Validation** : `validationDefault()` (champs) + `buildRules()` (intégrité) dans la Table.
**Données** : ORM CakePHP (Table/Entity) · `contain()` pour les associations · `$_accessible` explicite.
**Réutilisation** : Components (controllers) · Helpers (vues).
**Sécurité** : plugins Authentication / Authorization (policies).
**Tests** : PHPUnit (intégration CakePHP).
**Vérification** : PHPUnit · PHPStan · PHP_CodeSniffer (CakePHP standard) · `composer audit`.

---

## Sortie attendue
- Un `memory.md` reflétant **uniquement** les choix validés, avec les commandes de vérification.
- Un `architecture.md` cohérent avec ces choix.
- Les patterns non retenus ne sont pas imposés : réévaluables quand un besoin réel émerge.
