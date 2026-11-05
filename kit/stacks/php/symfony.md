# Stack Symfony — Règles spécifiques

> **SOURCE de compilation** (non lue pendant un audit) — compilée dans `agent-project/check.md`.
> Hérite de `agent/rules/audit.md` (universel) → `agent/stacks/php/php.md` (PHP).
> Ne contient que le **comment** propre à Symfony ; les principes sont définis aux niveaux supérieurs.
> Dernière mise à jour : 2026-06-04

## Changelog
- 2026-06-04 : Création initiale
- 2026-06-04 : Factorisation — conservation des mécanismes Symfony

---

## Controllers & services (mécanismes)
- [ ] Controller fin (`AbstractController`) ; logique dans des services **autowirés**
- [ ] Injection par constructeur — pas de service locator (`$container->get()`)
- [ ] Routing par attributs `#[Route]`

## Validation
- [ ] DTO + contraintes `#[Assert\...]` (composant Validator)
- [ ] Composant Form pour les formulaires quand pertinent

## Doctrine (mécanismes)
- [ ] Anti N+1 (cf. `audit.md` §7) : `JOIN` / `addSelect` ou `fetch: EAGER` ciblé
- [ ] Requêtes réutilisées dans des Repositories dédiés
- [ ] QueryBuilder / DQL paramétrés (`setParameter`)

## i18n (fonctions)
- [ ] `$translator->trans()` / filtre Twig `trans` + fichiers `translations/`

## Sécurité (mécanismes, cf. `audit.md` §8)
- [ ] Autorisation via Voters / `#[IsGranted]`
- [ ] Firewalls et `access_control` cohérents
- [ ] CSRF sur les formulaires hors composant Form

## Twig
- [ ] Échappement automatique conservé — pas de `|raw` sur des données utilisateur
- [ ] Pas de logique métier dans les templates

## Debug interdit (en plus de `php.md`)
- [ ] Aucun `dump()` / `dd()` (VarDumper) en production

---

## Priorités stack Symfony (complètent `rules/audit.md`)

### CRITIQUES
- Autorisation sans Voter / `#[IsGranted]`
- `|raw` sur des données utilisateur (XSS)
- Texte en dur dans Twig alors que l'i18n est en place
- `dump()` / `dd()` en production

### MOYENS
- N+1 Doctrine
- Validation manuelle au lieu de contraintes
- Concaténation dans une requête DQL / QueryBuilder

### MINEURS
- Service locator au lieu d'injection par constructeur
