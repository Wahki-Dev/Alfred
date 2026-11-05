# Stack PHP — Règles spécifiques au langage

> **SOURCE de compilation** (non lue pendant un audit) — compilée dans `agent-project/check.md`.
> Règles communes à TOUS les projets PHP. Pour un framework, voir AUSSI `laravel.md`, `symfony.md` ou `cakephp.md`.
> Dernière mise à jour : 2026-06-04

## Changelog
- 2026-06-04 : Création initiale (extraction des règles non universelles de `rules/audit.md`)
- 2026-06-04 : Ajout « migrations réversibles » (factorisé depuis les fichiers framework)

---

## Typage & langage
- [ ] `declare(strict_types=1);` en tête de chaque fichier PHP
- [ ] Type hints sur tous les paramètres, retours et propriétés
- [ ] INTERDIT : `mixed` sans justification explicite
- [ ] Visibilité explicite (`public` / `protected` / `private`) sur méthodes ET propriétés
- [ ] `readonly` pour les propriétés non mutables (PHP 8.1+)
- [ ] Comparaisons strictes `===` / `!==` (jamais `==` sur des types hétérogènes)
- [ ] INTERDIT : opérateur `@` de suppression d'erreur

## Valeurs & enums
- [ ] Enums natifs (`enum`, PHP 8.1+) pour les valeurs métier finies — pas de chaînes en dur ni de constantes éparses

## Standards
- [ ] PSR-12 : classes en PascalCase, méthodes/variables en camelCase
- [ ] PSR-4 : une classe par fichier, namespace = chemin
- [ ] Imports (`use`) utiles uniquement, pas d'import inutilisé

## Base de données & migrations
- [ ] Migrations réversibles : méthode `down()` ou migration nativement réversible (commun à tous les outils PHP : Laravel, Doctrine, Phinx)

## Debug interdit en production
- [ ] Aucun `var_dump()`, `print_r()`, `var_export()` de debug, ni `error_log()` de debug oublié

## Documentation
- [ ] PHPDoc uniquement s'il apporte une info absente du typage (ex : `@var Collection<int, User>`) — jamais pour dupliquer les types

---

## Priorités stack PHP (complètent `rules/audit.md`)

### CRITIQUES
- Absence de `declare(strict_types=1)`
- `mixed` non justifié
- Instruction de debug (`var_dump`, `print_r`, `var_export`…) en production

### MOYENS
- Visibilité non explicite
- Comparaison `==` au lieu de `===`

### MINEURS
- Import inutilisé
- PHPDoc redondant avec le typage
