# Stack Laravel — Règles spécifiques

> Lu directement à l'audit (avec `agent/rules/audit.md` et `agent-project/rules.md`). Une équipe peut
> désactiver, changer la sévérité ou la portée d'une règle dans `agent-project/rules.md`.
> S'ajoute à `agent/stacks/php/php.md`. Ne contient que le **comment** propre à Laravel ;
> les principes sont dans `agent/rules/audit.md`.

---

## Controllers
> Source des règles vérifiables. La matrice de choix greenfield (`init`) est dans
> `agent/stacks/php/decisions.md` : garder les deux cohérentes.
- **LAR-01** · MOYEN — CRUD administratif simple → Resource Controller (`index/show/store/update/destroy`)
- **LAR-02** · MOYEN — Action métier isolée → Single Action Controller (`__invoke`), qui délègue à un service (`app/Services`) ou une Action (`app/Actions`)
- **LAR-03** · MINEUR — Pas de nom de ressource dans un controller invokable : sous-dossier dédié (`Users/UpdateStatusController`)

## Configuration
- **LAR-04** · MOYEN — `env()` uniquement dans `config/` ; ailleurs `config()`

## Validation
- **LAR-05** · MOYEN — FormRequest dès que la validation dépasse quelques champs ou est réutilisée

## Vues
- **LAR-06** · MINEUR — Réutiliser les composants Blade existants avant tout HTML brut

## Eloquent
- **LAR-07** · MOYEN — Anti N+1 : eager loading via `with()` / `load()`
- **LAR-08** · MINEUR — Requête répétée à plusieurs endroits → scope local (pas de repository sans besoin réel)

## i18n
- **LAR-09** · CRITIQUE — Si l'i18n est en place : textes via `__()` / `trans()` et fichiers `lang/` ; nouvelles clés ajoutées dans chaque langue

## Sécurité
- **LAR-10** · CRITIQUE — Autorisation via Policies / Gates (`authorize()`, `can`), jamais en dur dans le controller
- **LAR-11** · CRITIQUE — `@csrf` sur tout formulaire POST/PUT/PATCH/DELETE ; pas d'exclusion CSRF sans raison documentée
- **LAR-12** · CRITIQUE — Échappement Blade `{{ }}` ; `{!! !!}` uniquement sur du contenu de confiance
- **LAR-13** · CRITIQUE — Mass assignment : `$fillable` explicite ; `$guarded = []` et `Model::unguard()` interdits ; jamais `create($request->all())` (utiliser `$request->validated()`)
- **LAR-14** · CRITIQUE — `whereRaw`, `selectRaw`, `orderByRaw`, `DB::raw`, `DB::select` : jamais de variable interpolée, toujours des bindings
- **LAR-15** · CRITIQUE — `APP_DEBUG=false` en production (sinon stack traces et variables d'environnement exposées)
- **LAR-16** · CRITIQUE — Fichier privé jamais sur le disque `public` : disque privé + URL signée (`temporaryUrl`, route `signed`) ou réponse contrôlée après autorisation

## Events / Queues
- **LAR-17** · MOYEN — Ordre des listeners maîtrisé (ex : création AVANT notification)
- **LAR-18** · MOYEN — Jobs : gestion des échecs (`failed()`, `$tries`, `backoff`)

## Debug interdit (en plus de `php.md`)
- **LAR-19** · CRITIQUE — Aucun `dd()`, `dump()`, `ray()` ni `Log::debug()` de debug oublié
