# Aide à la décision — Démarrage d'un projet PHP

> **SOURCE** (non lue pendant un audit). Utilisée par la commande `init` quand le projet est **vierge**
> (peu ou pas de code à analyser). Sert à alimenter `agent-project/memory.md` puis à compiler `agent-project/check.md`.
> But : proposer des défauts modernes et solides, poser PEU de questions ciblées, laisser l'utilisateur trancher.

## Principe directeur (anti-sur-ingénierie)
- Commencer **simple** : n'introduire un pattern que s'il répond à un besoin réel et présent (YAGNI).
- Proposer un défaut recommandé pour chaque décision — **jamais imposer**.
- Ne poser que les questions qui changent réellement l'architecture.
- Pas de Repository / DDD / CQRS / event sourcing « au cas où ».

---

## Cadrage (toutes stacks PHP) — questions à poser
1. Framework ? (Laravel · Symfony · CakePHP · autre)
2. Nature dominante ? (CRUD administratif · application métier · API · mixte)
3. Multilingue (i18n) nécessaire ? (oui / non)
4. Tests souhaités dès le départ ? (oui + framework / non)
5. Base de données ? (MySQL/MariaDB · PostgreSQL · SQLite · autre)

→ À partir des réponses : proposer `memory.md` (stack, conventions, patterns retenus) puis compiler `check.md`.

---

## Laravel — matrice de décision

> Duplication assumée : la version « audit » de ces règles controllers est dans `agent/stacks/php/laravel.md`.
> Ici = phase **greenfield** (`init`, projet vierge). Garder les deux en cohérence.

**Controllers**
| Contexte | Défaut proposé |
|---|---|
| CRUD administratif simple | Resource Controller (`index/show/store/update/destroy`) |
| Action métier explicite et isolée | Single Action Controller (`__invoke`) |
| Sous-ressource / contexte précis | Controller dédié dans un sous-dossier (`Users/UpdateStatusController`) |

**Logique métier** : thin controller → **Service** (ou **Action** pour un cas unitaire). Repository **seulement** si accès données complexe/réutilisé ou multi-source ; sinon Eloquent direct.
**Validation** : FormRequest dès que la validation est non triviale.
**Données** : Eloquent · `enum` PHP pour statuts/types · casts explicites.
**Structure** : `app/Services`, `app/Actions`, `app/Enums` créés **au premier besoin**, pas en avance.
**Auth (si besoin)** : web → Breeze/Fortify · API → Sanctum.
**Tests (si oui)** : Pest par défaut.

---

## Symfony — matrice de décision

**Controllers** : fins (`AbstractController`), routing par `#[Route]` → logique dans des **services autowirés**.
**Validation** : DTO + `#[Assert\...]` (Validator) ; composant Form si formulaires riches.
**Données** : entités Doctrine + Repository dédié par entité.
**Sécurité** : Voters / `#[IsGranted]` dès qu'il y a des règles d'accès.
**Structure** : standard Symfony (`src/Controller`, `src/Service`, `src/Entity`, `src/Repository`).
**Tests (si oui)** : PHPUnit (+ éventuellement Foundry pour les fixtures).

---

## CakePHP — matrice de décision

**Controllers** : fins → logique dans les **Table objects** ou des services ; conventions Inflector respectées.
**Validation** : `validationDefault()` (champs) + `buildRules()` (intégrité) dans la Table.
**Données** : ORM CakePHP (Table/Entity) · `contain()` pour les associations.
**Réutilisation** : Components (controllers) · Helpers (vues).
**Sécurité** : plugins Authentication / Authorization (policies).
**Tests (si oui)** : PHPUnit (intégration CakePHP).

---

## Sortie attendue
- Un `memory.md` reflétant **uniquement** les choix validés.
- Un `check.md` compilé cohérent avec ces choix.
- Les patterns non retenus ne sont pas imposés — réévaluables plus tard quand un besoin réel émerge.
