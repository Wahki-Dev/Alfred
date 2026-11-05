# Stack CakePHP — Règles spécifiques

> **SOURCE de compilation** (non lue pendant un audit) — compilée dans `agent-project/check.md`.
> Hérite de `agent/rules/audit.md` (universel) → `agent/stacks/php/php.md` (PHP).
> Ne contient que le **comment** propre à CakePHP ; les principes sont définis aux niveaux supérieurs.
> Dernière mise à jour : 2026-06-04

## Changelog
- 2026-06-04 : Création initiale
- 2026-06-04 : Factorisation — conservation des mécanismes CakePHP

---

## Conventions CakePHP
- [ ] Conventions Inflector : tables au pluriel, entités au singulier, clés étrangères `xxx_id`
- [ ] Logique dans les Table objects ou des services ; réutilisation via Components (controllers) et Helpers (vues)

## ORM CakePHP (mécanismes)
- [ ] Anti N+1 (cf. `audit.md` §7) : `contain()` pour les associations
- [ ] Requêtes réutilisées → custom finders (`findXxx`) dans la Table
- [ ] Conditions paramétrées (pas de concaténation SQL)
- [ ] Pagination via le composant Paginator pour les grandes listes

## Validation
- [ ] Règles dans `validationDefault()` ; intégrité (unicité, clés étrangères) dans `buildRules()`

## i18n (fonctions)
- [ ] `__()` / `__d()` + fichiers `resources/locales/`

## Sécurité (mécanismes, cf. `audit.md` §8)
- [ ] Authentification / Authorization via les plugins officiels (policies)
- [ ] Échappement de sortie via `h()` dans les templates
- [ ] CSRF middleware / component actif sur les formulaires

## Debug interdit (en plus de `php.md`)
- [ ] Aucun `debug()`, `dd()`, `pr()`, `pj()`, `dump()`, `stackTrace()` oublié

---

## Priorités stack CakePHP (complètent `rules/audit.md`)

### CRITIQUES
- Sortie non échappée (`h()` manquant) → XSS
- Texte en dur dans un template alors que l'i18n est en place
- `debug()` / `dd()` / `pr()` en production

### MOYENS
- N+1 (`contain()` manquant)
- Validation hors `validationDefault()` / `buildRules()`

### MINEURS
- Non-respect des conventions Inflector
