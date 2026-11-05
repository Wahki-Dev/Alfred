# Stack CakePHP — Règles spécifiques

> Lu directement à l'audit (avec `agent/rules/audit.md` et `agent-project/rules.md`). Une équipe peut
> désactiver, changer la sévérité ou la portée d'une règle dans `agent-project/rules.md`.
> S'ajoute à `agent/stacks/php/php.md`. Ne contient que le **comment** propre à CakePHP ;
> les principes sont dans `agent/rules/audit.md`.

---

## Conventions CakePHP
- **CAKE-01** · MINEUR — Conventions Inflector : tables au pluriel, entités au singulier, clés étrangères `xxx_id`
- **CAKE-02** · MOYEN — Logique dans les Table objects ou des services ; réutilisation via Components (controllers) et Helpers (vues)

## ORM
- **CAKE-03** · MOYEN — Anti N+1 : `contain()` pour les associations
- **CAKE-04** · MINEUR — Requête réutilisée → custom finder (`findXxx`) dans la Table
- **CAKE-05** · CRITIQUE — Conditions paramétrées, jamais de concaténation SQL
- **CAKE-06** · MOYEN — Grandes listes paginées via le composant Paginator

## Validation
- **CAKE-07** · MOYEN — Règles de champs dans `validationDefault()` ; intégrité (unicité, clés étrangères) dans `buildRules()`

## i18n
- **CAKE-08** · CRITIQUE — Si l'i18n est en place : `__()` / `__d()` + fichiers `resources/locales/`

## Sécurité
- **CAKE-09** · CRITIQUE — Authentification / autorisation via les plugins officiels Authentication / Authorization (policies)
- **CAKE-10** · CRITIQUE — Sortie échappée via `h()` dans les templates
- **CAKE-11** · CRITIQUE — Middleware CSRF actif sur les formulaires
- **CAKE-12** · CRITIQUE — Mass assignment : `$_accessible` explicite dans les entités, pas de `'*' => true` sur des champs sensibles (rôle, propriétaire, statut)
- **CAKE-13** · CRITIQUE — Production : `'debug' => false`

## Debug interdit (en plus de `php.md`)
- **CAKE-14** · CRITIQUE — Aucun `debug()`, `dd()`, `pr()`, `pj()`, `dump()`, `stackTrace()` oublié
