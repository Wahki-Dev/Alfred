# Stack Laravel — Règles spécifiques

> **SOURCE de compilation** (non lue pendant un audit) — compilée dans `agent-project/check.md`.
> Hérite de `agent/rules/audit.md` (universel) → `agent/stacks/php/php.md` (PHP).
> Ne contient que le **comment** propre à Laravel ; les principes sont définis aux niveaux supérieurs.
> Dernière mise à jour : 2026-06-04

## Changelog
- 2026-06-04 : Création initiale
- 2026-06-04 : Factorisation — retrait des principes universels, conservation des mécanismes Laravel

---

## Controllers (aide à la décision)
> Duplication assumée : la matrice de choix « greenfield » est dans `agent/stacks/php/decisions.md` (phase `init`).
> Ci-dessous = la version pour la phase **audit** (vérification du choix dans `check.md`). Garder les deux en cohérence.
- [ ] CRUD administratif simple → **Resource Controller** (`index/show/store/update/destroy`)
- [ ] Action métier explicite et isolée → **Single Action Controller** (`__invoke`)
- [ ] Logique métier déléguée à un **service/action** dédié (application du thin controller, cf. `audit.md` §1)
- [ ] INTERDIT : nom de ressource dans un controller invokable (préférer `Users/UpdateStatusController`)

## Validation
- [ ] FormRequest dès que la validation dépasse quelques champs ou est réutilisée

## Eloquent (mécanismes)
- [ ] Anti N+1 (cf. `audit.md` §7) : eager loading via `with()`
- [ ] Requêtes réutilisées → scopes (locaux/globaux) ou repository
- [ ] INTERDIT : `env()` hors des fichiers `config/` (utiliser `config()`)

## i18n (fonctions)
- [ ] `__()` / `trans()` + fichiers `lang/` ; nouvelles clés dans les fichiers de langue concernés

## Sécurité (mécanismes, cf. `audit.md` §8)
- [ ] Autorisation via Policies / Gates
- [ ] `@csrf` sur tout formulaire POST/PUT/PATCH/DELETE
- [ ] Échappement Blade `{{ }}` ; `{!! !!}` uniquement sur contenu de confiance

## Vues
- [ ] Réutiliser les composants Blade existants avant tout HTML brut

## Events / Queues
- [ ] Ordre des listeners maîtrisé (ex : création AVANT notification)
- [ ] Jobs : gestion des échecs (`failed()`, retries)

## Debug interdit (en plus de `php.md`)
- [ ] Aucun `dd()`, `dump()`, `ray()`, `Log::debug()` oublié

---

## Priorités stack Laravel (complètent `rules/audit.md`)

### CRITIQUES
- Autorisation absente ou en dur (pas de Policy/Gate)
- Texte en dur dans Blade alors que l'i18n est en place
- `dd()` / `dump()` en production

### MOYENS
- N+1 (eager loading manquant)
- Validation complexe inline au lieu d'un FormRequest
- `env()` hors config

### MINEURS
- HTML brut alors qu'un composant Blade existe
