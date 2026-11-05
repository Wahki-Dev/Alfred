# Audit — Base universelle de règles (SOURCE)

> ⚠️ **SOURCE de compilation — ce fichier n'est PAS lu pendant un audit.**
> Il sert de base universelle pour compiler `agent-project/check.md`
> (voir `agent/blueprints/check.blueprint.md`).
> Pendant un audit, l'agent lit uniquement `agent-project/check.md` (+ `agent-project/memory.md`).
> Les règles ci-dessous sont **indépendantes du langage** ; le détail par techno est dans `agent/stacks/`.

---

## Restrictions de l'audit

- JAMAIS modifier du code sans validation explicite
- JAMAIS exécuter des outils d'analyse (linter, tests) sans demande
- JAMAIS proposer des corrections qui violent `agent-project/memory.md`
- TOUJOURS proposer avant d'appliquer
- TOUJOURS expliquer le pourquoi
- TOUJOURS prioriser : CRITIQUE > MOYEN > MINEUR

---

## Checklist d'audit

### 0) Préparation (OBLIGATOIRE)
- [ ] Lire `agent-project/memory.md` avant tout audit
- [ ] Lire `agent-project/check.md` avant tout audit
- [ ] Lire le plan validé de la feature (`agent-project/plans/<plan>.md`) s'il existe
- [ ] Identifier les conventions de nommage du projet
- [ ] Identifier les patterns d'architecture du projet

---

### 0bis) Conformité au plan validé (CRITIQUE)

- [ ] **Couverture complète** : chaque exigence / changement prévu au plan est implémenté (rien d'oublié)
- [ ] **Pas d'écart non justifié** : le code ne dévie pas du plan validé sans raison explicite
- [ ] **Pas de hors-périmètre** : aucun ajout non prévu et non validé

---

### 1) Architecture & Responsabilité

- [ ] **Single responsibility** : chaque fichier/classe a une seule responsabilité
- [ ] **Pas de logique métier dans les contrôleurs/handlers** → déléguer aux services
- [ ] **Nommage** : conforme aux conventions définies dans `agent-project/memory.md`
- [ ] **Structure dossiers** : respect de l'architecture définie dans `memory.md`
- [ ] **Patterns projet** : respect des patterns spécifiques définis dans `memory.md`

---

### 2) Typage & Qualité

- [ ] **Typage** : aussi strict que le langage le permet (paramètres, retours, propriétés)
- [ ] **Pas de type fourre-tout** (non spécifique) sans justification — mots-clés exacts dans la règle de stack
- [ ] **Conventions du langage** : respect du standard défini dans `memory.md` / la règle de stack
- [ ] **Imports** : pas d'imports inutilisés

---

### 3) Duplication (CRITIQUE)

- [ ] **Pas de code dupliqué** → extraire en services/actions/helpers
- [ ] **Pas de templates/vues répétés** → créer des composants
- [ ] **Pas de requêtes similaires** → créer des scopes/repositories
- [ ] **Pas de validations répétées** → créer des validators/rules réutilisables
- [ ] **Pas de valeurs en dur répétées** → utiliser des constantes/enums/config

---

### 4) Valeurs & Internationalisation

- [ ] **Pas de valeurs en dur** pour les concepts métier → enums/constantes
- [ ] **i18n (si le projet en dispose)** : textes affichés passés par le mécanisme d'i18n — jamais de texte en dur dans les vues (fonctions exactes dans la règle de stack)
- [ ] **Messages d'erreur** : clairs, traduits si i18n, sinon configurables

---

### 5) Validation & Formulaires

- [ ] **Validation** côté serveur pour toute donnée utilisateur
- [ ] **Validators dédiés** si règles complexes ou réutilisées (pas de validation inline répétée)
- [ ] **Messages d'erreur** : clairs, traduits
- [ ] **Sanitization** des données si nécessaire

---

### 6) Routes & Organisation

- [ ] Routes groupées par contexte
- [ ] Nommage des routes explicite et cohérent
- [ ] Middleware appliqués aux groupes (pas route par route)
- [ ] Routes sensibles protégées (authentification + autorisation)

---

### 7) Performance

- [ ] **Pas de requêtes dans les boucles** (N+1)
- [ ] **Eager loading** pour les relations chargées
- [ ] **Pagination** pour les grandes listes
- [ ] **Cache** pour les données statiques/coûteuses
- [ ] Index sur colonnes fréquemment recherchées

---

### 8) Sécurité

> Checklist de base appliquée à **tout** projet (y compris vierge). Les mécanismes exacts
> (fonctions, middlewares, en-têtes) sont précisés par la règle de stack.

#### 8.1 Authentification & session
- [ ] **Authentification** requise sur les endpoints non publics (pas d'accès anonyme par défaut)
- [ ] **Mots de passe** hachés avec un algorithme fort (bcrypt/argon2), jamais en clair ni chiffrement réversible
- [ ] **Sessions** : régénération de l'ID au login (anti-fixation), expiration/timeout, invalidation au logout
- [ ] **Reset password** : token à usage unique, expirant, non devinable
- [ ] **Aucun identifiant par défaut** ni **compte de test/admin** actif en dehors du dev

#### 8.2 Autorisation
- [ ] **Autorisation** vérifiée côté serveur (policies, gates, guards) pour chaque action sensible
- [ ] **Ownership / IDOR** : un utilisateur ne peut accéder/modifier que ses propres ressources
- [ ] **Pas de contrôle d'accès uniquement côté client** (UI cachée ≠ endpoint protégé)

#### 8.3 Injections & sorties
- [ ] **Pas de SQL/NoSQL brut** sans paramètres bindés (requêtes préparées / query builder)
- [ ] **Pas d'injection de commandes** (pas de concaténation d'input dans un appel shell/OS)
- [ ] **XSS** : échappement systématique des outputs (contexte HTML/attribut/JS/URL)
- [ ] **Validation & sanitization** de toute donnée utilisateur côté serveur

#### 8.4 En-têtes & requêtes cross-origin
- [ ] **CSRF** : protection active sur toutes les mutations (POST/PUT/PATCH/DELETE)
- [ ] **CORS** : origines explicitement autorisées (pas de `*` avec credentials)
- [ ] **CSP** : Content-Security-Policy restrictive (limite les sources scripts/styles)
- [ ] **HSTS** : Strict-Transport-Security activé (+ en-têtes `X-Content-Type-Options`, `X-Frame-Options`/`frame-ancestors`)

#### 8.5 Secrets & configuration
- [ ] **Aucun secret ni clé API** en dur dans le code ou le dépôt → variables d'environnement / vault
- [ ] **`.env` et fichiers sensibles** ignorés par le VCS (`.gitignore`)
- [ ] **Chiffrement** : HTTPS/TLS en transit, chiffrement au repos des données sensibles
- [ ] **PRNG** : générateur cryptographiquement sûr pour tokens/secrets/IDs de session (jamais `rand()`/PRNG standard)

#### 8.6 Abus & disponibilité
- [ ] **Bruteforce** : rate limiting / throttling sur login, reset, endpoints d'auth
- [ ] **DoS** : limites sur taille de payload, pagination, timeouts, quotas sur opérations coûteuses
- [ ] **Upload de fichiers** : validation du type MIME + taille côté serveur, stockage hors webroot

#### 8.7 Exposition d'informations
- [ ] **Pas de données sensibles** dans les logs (mots de passe, tokens, PII)
- [ ] **Messages d'erreur** génériques en production (pas de stack trace / détail interne exposé)
- [ ] **Stockage côté client** (front/mobile) : pas de secret/token sensible en localStorage/stockage non sécurisé
- [ ] **Dépendances / composants** : pas de version vulnérable connue (audit des dépendances)

---

### 9) Exceptions & Logs

- [ ] **Exceptions métier** explicites avec messages clairs
- [ ] **Code HTTP** approprié pour les erreurs (400, 403, 404, 422, 500)
- [ ] **Logs critiques** avec contexte suffisant
- [ ] **Pas d'instruction de debug oubliée** en production (fonctions interdites listées dans la règle de stack)
- [ ] **Pas de données sensibles** dans les logs (mots de passe, tokens)

---

### 10) Tests

- [ ] **Logique métier critique** couverte par des tests unitaires
- [ ] **Contrôleurs/routes** couverts par des tests d'intégration
- [ ] **Tests unitaires ultra-rapides** (sans persistance pour logique pure)
- [ ] Conventions de test respectées (voir `agent-project/tests.md`)

---

### 11) Documentation & Propreté

- [ ] **Code auto-documenté** : noms explicites, pas de docblocks qui dupliquent les types
- [ ] **Commentaires** uniquement pour logique non évidente ou contraintes spécifiques
- [ ] **Pas de code commenté** sans raison expliquée
- [ ] **Pas de `TODO`** sans ticket/issue associé

---

### 11bis) Ponytail (parcimonie)

> Partie vérifiable de `agent/rules/ponytail.md` (source de compilation de ce ruleset).

- [ ] **Pas d'abstraction non demandée** (interface/couche/généricité sans besoin réel)
- [ ] **Pas de dépendance évitable** (stdlib ou dépendance déjà installée préférée)
- [ ] **Suppression > ajout** : pas de code mort, pas de fichier/boilerplate superflu
- [ ] **Fix à la racine** : fonction partagée corrigée une fois, pas chaque appelant
- [ ] **Raccourcis marqués `ponytail:`** (avec plafond + chemin d'upgrade si limite connue)
- [ ] **Logique non triviale** accompagnée d'au moins UN check runnable

---

### 12) Règles de la stack

> Appliquer toutes les règles du/des fichier(s) `agent/stacks/<langage>/...` correspondant à la stack détectée
> (langage + framework : typage, debug interdit, i18n, ORM, sécurité propres à la techno).

---

### 13) Règles projet spécifiques

> Appliquer toutes les règles de `agent-project/check.md` :
> architecture, nommage, ORM, composants, events propres à CE projet.
> Ce fichier est le complément obligatoire du présent audit.

---

## Format du rapport d'audit

```markdown
# Rapport d'Audit — [Module/Feature]

## Points Positifs
- ...

## Points d'Attention
- ...

## Problèmes Critiques
### [Catégorie]
1. **Problème**
   - VIOLATION : règle violée
   - Fichier : `chemin/fichier:ligne`
   - Action : correction précise

## Actions Correctives (Priorisées)
### CRITIQUES (Immédiat)
1. Action (effort estimé)

### MOYENS (À planifier)
1. ...

### MINEURS (Nice to have)
1. ...

## Recommandations
- ...

## Métriques
- Conformité globale : X%
- Violations critiques : X
- Effort total estimé : Xh
```

---

## Priorités

### CRITIQUES (Bloquer)
- Plan validé non couvert (exigence oubliée) ou écart au plan non justifié
- Single responsibility violé
- Typage manquant alors que le langage le permet
- Routes sensibles non protégées
- Texte affiché en dur alors que le projet utilise l'i18n
- Duplication de logique métier
- Instruction de debug laissée en production (voir règle de stack)
- Sécurité : injection (SQL/NoSQL/commande), XSS, CSRF absent sur mutation
- Sécurité : autorisation/authentification absente ou contournable (IDOR)
- Sécurité : secret / clé API en dur dans le code ou le dépôt
- Sécurité : mot de passe en clair / PRNG non sûr pour token ou secret
- Sécurité : identifiant par défaut ou compte de test actif en production
- Règles CRITIQUES de la stack (`agent/stacks/...`) violées
- Règles CRITIQUES de `agent-project/check.md` violées

### MOYENS
- N+1 queries
- Validation répétée (créer validator)
- Migrations/jobs sans gestion d'erreur
- Logs sans contexte
- Sécurité : rate limiting absent (bruteforce), pas de limite anti-DoS
- Sécurité : en-têtes manquants (CORS trop permissif, CSP/HSTS absents)
- Sécurité : données sensibles dans logs ou messages d'erreur détaillés
- Sécurité : dépendance / composant en version vulnérable connue
- Abstraction non demandée / dépendance évitable (ponytail)
- Fix de symptôme au lieu de la cause racine (ponytail)

### MINEURS
- Imports inutilisés
- Docblocks qui dupliquent les types
- `TODO` sans ticket
- Raccourci intentionnel non marqué `ponytail:`
