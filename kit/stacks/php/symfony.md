# Stack Symfony — Règles spécifiques

> Lu directement à l'audit (avec `agent/rules/audit.md` et `agent-project/rules.md`). Une équipe peut
> désactiver, changer la sévérité ou la portée d'une règle dans `agent-project/rules.md`.
> S'ajoute à `agent/stacks/php/php.md`. Ne contient que le **comment** propre à Symfony ;
> les principes sont dans `agent/rules/audit.md`.

---

## Controllers & services
- **SYM-01** · MOYEN — Controller fin (`AbstractController`) ; logique dans des services autowirés
- **SYM-02** · MINEUR — Injection par constructeur, pas de service locator (`$container->get()`)
- **SYM-03** · MINEUR — Routing par attributs `#[Route]`

## Validation
- **SYM-04** · MOYEN — Contraintes `#[Assert\...]` sur DTO ou entité (composant Validator), composant Form pour les formulaires riches ; pas de validation manuelle

## Doctrine
- **SYM-05** · MOYEN — Anti N+1 : `JOIN` + `addSelect`, ou `fetch: EAGER` ciblé
- **SYM-06** · MINEUR — Requête réutilisée → méthode du Repository de l'entité
- **SYM-07** · CRITIQUE — QueryBuilder / DQL / SQL natif paramétrés (`setParameter`), jamais de concaténation

## i18n
- **SYM-08** · CRITIQUE — Si l'i18n est en place : `$translator->trans()` / filtre Twig `trans` + fichiers `translations/`

## Sécurité
- **SYM-09** · CRITIQUE — Autorisation via Voters / `#[IsGranted]` / `denyAccessUnlessGranted()`
- **SYM-10** · MOYEN — Firewalls et `access_control` cohérents avec les routes exposées
- **SYM-11** · CRITIQUE — CSRF sur les formulaires hors composant Form (`csrf_token()` + `isCsrfTokenValid()`)
- **SYM-12** · CRITIQUE — Échappement Twig automatique conservé : pas de `|raw` sur des données utilisateur
- **SYM-13** · CRITIQUE — Production : `APP_ENV=prod` et `APP_DEBUG=0`

## Twig
- **SYM-14** · MOYEN — Pas de logique métier dans les templates

## Debug interdit (en plus de `php.md`)
- **SYM-15** · CRITIQUE — Aucun `dump()` / `dd()` (VarDumper) en production
