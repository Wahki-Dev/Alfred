# Audit — Règles universelles et procédure

> Lu directement à l'audit, avec `agent/rules/tests.md`, la stack du projet (`agent/stacks/<langage>/`),
> la direction citée par `agent-project/architecture.md` (`agent/technical-directions/custom.md`, plus
> `agent/technical-directions/ddd-lite.md` si elle s'applique) et `agent-project/rules.md`.
> Format d'une règle : `identifiant · sévérité [· socle] — règle`. Sévérités : CRITIQUE (bloque la fin de
> feature), MOYEN (à corriger ou planifier), MINEUR.

---

## Surcharge par l'équipe

`agent-project/rules.md` peut, pour une règle du kit identifiée :
- la **désactiver** (raison + date obligatoires) ;
- changer sa **sévérité** ;
- restreindre sa **portée** (ex : nouveaux fichiers et fichiers modifiés seulement) ;
- et **ajouter** des règles `PRJ-NN`.

Priorité : `rules.md` > direction > stack > ce fichier. Les règles `socle` ne peuvent être ni désactivées
ni rétrogradées : une exception ponctuelle est une « limite assumée » datée dans `agent-project/security.md`.

Une règle de stack ou de direction qui précise une règle de ce fichier la remplace : une violation n'est
signalée qu'une fois, sous l'identifiant le plus précis.

En cas de conflit entre une règle de ce fichier et `agent/rules/ponytail.md`, ponytail l'emporte :
on n'ajoute pas de couche, de cache ou d'abstraction sans besoin réel et présent.

---

## Procédure

1. **Cible** : diff de la feature, dossier ou module demandé. Lire le plan s'il existe.
2. **Règles** : ce fichier + `agent/rules/tests.md` + stack + direction(s) + `agent-project/rules.md`
   (appliquer désactivations, sévérités, portées et ajouts).
3. **Outils** : lancer les commandes de vérification déclarées dans `agent-project/memory.md` (tests, lint,
   analyse statique, audit des dépendances). Aucune autre commande sans permission.
4. **Rapport** (format ci-dessous). Aucune modification de code sans validation ; les corrections proposées
   respectent `memory.md` et `rules.md`.

Une règle qu'on ne peut pas vérifier (outil absent, code hors cible) est rapportée « non vérifiée »,
jamais « conforme ».

### Format du rapport

```markdown
# Audit — [cible]

## Vérifications
- Tests : [commande] → [résultat réel] · Lint : … · Analyse statique : … · Dépendances : …
- Non vérifié : [règle] — [raison]

## Violations
| Règle | Sévérité | Fichier:ligne | Correction |
|---|---|---|---|

## Conformité au plan (si plan)
- Étapes non faites / hors périmètre : …
```

---

## Plan

- **PLAN-01** · CRITIQUE — Chaque étape du plan validé est implémentée ; aucun ajout hors périmètre sans accord ; tout écart est justifié.

## Architecture

- **ARCH-01** · CRITIQUE — Une classe ou un fichier = une responsabilité.
- **ARCH-02** · CRITIQUE — Pas de logique métier durable dans un contrôleur, handler, job ou listener : déléguer.
- **ARCH-03** · MOYEN — Nommage conforme aux conventions de `agent-project/memory.md`.
- **ARCH-04** · MOYEN — Fichiers placés selon la structure décrite dans `agent-project/architecture.md`.

## Typage

- **TYPE-01** · CRITIQUE — Typage aussi strict que le langage le permet (paramètres, retours, propriétés).
- **TYPE-02** · MOYEN — Pas de type fourre-tout sans justification (mots-clés exacts dans la stack).
- **TYPE-03** · MINEUR — Pas d'import inutilisé.

## Duplication

- **DUP-01** · CRITIQUE — Pas de logique métier dupliquée : réutiliser l'existant, extraire au deuxième usage réel.
- **DUP-02** · MOYEN — Pas de vue ou de template répété : composant existant, ou nouveau composant au deuxième usage.
- **DUP-03** · MOYEN — Pas de requête identique répétée : la réutiliser (scope, méthode), sans couche dédiée par défaut.
- **DUP-04** · MOYEN — Pas de validation répétée : règle de validation réutilisable.
- **DUP-05** · MOYEN — Pas de valeur métier en dur répétée : enum, constante ou config.

## Internationalisation

- **I18N-01** · CRITIQUE — Si le projet a de l'i18n : aucun texte affiché en dur (fonctions exactes dans la stack).
- **I18N-02** · MOYEN — Messages d'erreur clairs, traduits si i18n.

## Validation

- **VAL-01** · CRITIQUE — Toute donnée externe est validée côté serveur.
- **VAL-02** · MOYEN — Validation complexe ou réutilisée dans un validateur dédié, pas inline.

## Routes

- **ROUTE-01** · MINEUR — Routes groupées par contexte, nommage explicite et cohérent.
- **ROUTE-02** · MOYEN — Middlewares appliqués aux groupes plutôt que route par route.

## Performance

- **PERF-01** · MOYEN — Pas de requête dans une boucle (N+1) : chargement anticipé selon l'ORM.
- **PERF-02** · MOYEN — Grandes listes paginées.
- **PERF-03** · MINEUR — Index sur les colonnes filtrées ou jointes fréquemment.

## Sécurité — socle (non désactivable)

- **SEC-01** · CRITIQUE · socle — Authentification et autorisation vérifiées côté serveur pour chaque action non publique ; jamais seulement côté client.
- **SEC-02** · CRITIQUE · socle — Ownership : un utilisateur n'accède qu'à ses propres ressources (IDOR).
- **SEC-03** · CRITIQUE · socle — Pas d'injection : requêtes paramétrées, aucune entrée concaténée dans une commande système, pas de désérialisation de données non fiables.
- **SEC-04** · CRITIQUE · socle — Sorties échappées selon le contexte (HTML, attribut, JS, URL).
- **SEC-05** · CRITIQUE · socle — Protection CSRF sur toute mutation authentifiée par cookie.
- **SEC-06** · CRITIQUE · socle — Aucun secret en dur (code, dépôt, logs, réponses) ; fichiers d'environnement ignorés par git.
- **SEC-07** · CRITIQUE · socle — Mots de passe hachés (bcrypt, argon2) ; tokens, identifiants de session et liens de reset générés par un PRNG cryptographique, à usage unique et expirants.
- **SEC-08** · CRITIQUE · socle — Upload : type et taille vérifiés côté serveur, stockage hors webroot, nom de fichier généré.

## Sécurité — autres règles

- **SEC-09** · CRITIQUE — Aucun identifiant par défaut ni compte de test actif hors développement.
- **SEC-10** · CRITIQUE — Chemin de fichier construit depuis une entrée : normalisé et confiné à un dossier autorisé.
- **SEC-11** · CRITIQUE — Appel HTTP vers une URL fournie : hôtes autorisés explicitement, adresses internes refusées (SSRF).
- **SEC-12** · CRITIQUE — Webhook entrant : signature vérifiée avant tout traitement.
- **SEC-13** · MOYEN — Session régénérée au login, expirante, invalidée au logout.
- **SEC-14** · MOYEN — Limitation de débit sur login, reset et endpoints d'authentification.
- **SEC-15** · MOYEN — Limites anti-abus : taille de requête, pagination, timeouts sur les opérations coûteuses.
- **SEC-16** · MOYEN — Erreurs génériques en production, sans trace ni détail interne.
- **SEC-17** · MOYEN — Ni mot de passe, ni token, ni donnée personnelle dans les logs.
- **SEC-18** · MOYEN — Côté client : aucun token sensible en stockage non sécurisé (localStorage).
- **SEC-19** · MOYEN — Dépendances sans vulnérabilité connue, **vérifié par l'outil** (`composer audit`, `npm audit`).
- **SEC-20** · MOYEN — Export CSV ou tableur : cellules commençant par `=`, `+`, `-`, `@` neutralisées.
- **SEC-21** · MOYEN — Redirection vers une URL fournie : destinations autorisées explicitement.
- **SEC-22** · MOYEN — Données personnelles : collecte limitée au nécessaire, durée de conservation définie, export et suppression possibles.
- **SEC-23** · MOYEN — En-têtes et transport : HTTPS, HSTS, CSP, `X-Content-Type-Options`, `frame-ancestors` ; CORS sans `*` avec credentials. Vérifiés à l'`init` et par `audit fichiers agent`, consignés dans `agent-project/security.md`.

## Erreurs et logs

- **LOG-01** · MOYEN — Exceptions métier explicites, codes HTTP adaptés (400, 403, 404, 422, 500).
- **LOG-02** · MOYEN — Jobs, migrations et intégrations : échecs gérés et journalisés avec contexte.
- **LOG-03** · CRITIQUE — Aucune instruction de debug oubliée (liste dans la stack).

## Propreté

- **DOC-01** · MINEUR — Code auto-documenté ; pas de commentaire ou docblock qui répète le typage.
- **DOC-02** · MINEUR — Pas de code commenté sans raison, pas de `TODO` sans ticket.

## Parcimonie (`agent/rules/ponytail.md`)

- **PONY-01** · MOYEN — Pas d'abstraction non demandée : interface, couche, repository, cache ou généricité sans besoin réel et présent.
- **PONY-02** · MOYEN — Pas de dépendance évitable (stdlib, plateforme ou dépendance déjà installée d'abord).
- **PONY-03** · MOYEN — Bug corrigé à la racine (fonction partagée), pas chez chaque appelant.
- **PONY-04** · MINEUR — Pas de code mort ni de fichier superflu.
- **PONY-05** · MINEUR — Raccourci volontaire marqué `ponytail:`, avec son plafond et le chemin d'évolution s'il est connu.
