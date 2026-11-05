# Stack PHP — Règles communes au langage

> Lu directement à l'audit (avec `agent/rules/audit.md` et `agent-project/rules.md`). Une équipe peut
> désactiver, changer la sévérité ou la portée d'une règle dans `agent-project/rules.md`.
> Commun à tous les projets PHP. Pour le framework, voir AUSSI `laravel.md`, `symfony.md` ou `cakephp.md`.
> Ne contient que le **comment** propre à PHP ; les principes sont dans `agent/rules/audit.md`.

---

## Typage & langage
- **PHP-01** · CRITIQUE — `declare(strict_types=1);` en tête de chaque fichier PHP
- **PHP-02** · CRITIQUE — Type hints sur tous les paramètres, retours et propriétés
- **PHP-03** · CRITIQUE — `mixed` interdit sans justification explicite en commentaire
- **PHP-04** · MOYEN — Visibilité explicite (`public` / `protected` / `private`) sur méthodes ET propriétés
- **PHP-05** · MINEUR — `readonly` pour les propriétés non mutables (PHP 8.1+)
- **PHP-06** · MOYEN — Comparaisons strictes `===` / `!==` (jamais `==` sur des types hétérogènes)
- **PHP-07** · MOYEN — Opérateur `@` de suppression d'erreur interdit

## Valeurs & enums
- **PHP-08** · MOYEN — Enums natifs (`enum`, PHP 8.1+) pour les valeurs métier finies, pas de chaînes en dur ni de constantes éparses

## Standards
- **PHP-09** · MINEUR — PSR-12 : classes en PascalCase, méthodes et variables en camelCase
- **PHP-10** · MOYEN — PSR-4 : une classe par fichier, namespace = chemin

## Base de données & migrations
- **PHP-11** · MOYEN — Migrations réversibles : méthode `down()` ou migration nativement réversible (Laravel, Doctrine, Phinx)

## Sécurité
- **PHP-12** · CRITIQUE — `unserialize()` interdit sur une donnée d'origine externe (utiliser `json_decode()`, ou `allowed_classes: false`)

## Debug interdit en production
- **PHP-13** · CRITIQUE — Aucun `var_dump()`, `print_r()`, `var_export()` ni `error_log()` de debug oublié

## Documentation
- **PHP-14** · MINEUR — PHPDoc uniquement s'il apporte une info absente du typage (ex : `@var Collection<int, User>`), jamais pour dupliquer les types
