# Blueprint — Compilation de agent-project/check.md

> Explique COMMENT compiler `agent-project/check.md`, le ruleset d'audit **actif** du projet.
> Modèle : `check.md` est le **SEUL** fichier de contrôle lu pendant un audit. Il est **compilé une fois**
> à partir des sources, puis régénéré quand une source change.
>
> Sources (jamais lues pendant un audit) :
> - `agent/rules/audit.md` — base de règles universelles
> - `agent/rules/ponytail.md` — parcimonie / lazy (partie vérifiable)
> - `agent/stacks/<langage>/...` — bibliothèque de règles par techno
> - `agent-project/memory.md` — contexte et conventions du projet
> - `agent-project/architecture.md` — direction technique détaillée (si présent)

---

## Principe

`check.md` est un **artefact compilé**, auto-suffisant :
- il contient TOUT ce qu'il faut pour auditer (restrictions + checklist priorisée + format de rapport) ;
- pendant un audit, l'agent ne lit ni `audit.md` ni `stacks/` — uniquement `check.md` (+ `memory.md`).

La duplication de contenu entre les sources et `check.md` est **assumée** : c'est une compilation.
La cohérence est garantie par **régénération** (voir `agent/rules/maintenance.md`).

---

## Processus de compilation

### Étape 1 — Lire les sources
1. `agent-project/memory.md` : stack, framework, versions, conventions, fichiers à consulter
1bis. `agent-project/architecture.md` si présent : direction technique, dépendances, responsabilités, patterns, checklist architecture
2. `agent/rules/audit.md` : règles universelles
2bis. `agent/rules/ponytail.md` : règles de parcimonie vérifiables (section « Ponytail »)
3. Détecter la stack et charger le(s) fichier(s) `agent/stacks/<langage>/...`
   - PHP → `stacks/php/php.md` + le framework détecté (`laravel.md`, `symfony.md`, `cakephp.md`)
   - Stack sans fichier dans `stacks/` → le proposer/créer d'abord (sur la base de règles modernes)
4. **Projet vierge** (peu/pas de code) → s'appuyer sur `stacks/<langage>/decisions.md` (défauts modernes validés à l'`init`).
   **Projet existant** → analyser des fichiers représentatifs pour inférer les règles implicites :

| Type | Nombre | Ce qu'on cherche |
|---|---|---|
| Contrôleurs / handlers | 5–10 | Structure, nommage, responsabilités |
| Services / use cases | 5–10 | Logique métier, patterns, injection |
| Modèles / entités | 5–10 | Conventions, relations, typage |
| Routes | tous | Organisation, nommage, middleware |
| Tests | 3–5 | Framework, conventions |
| Vues / composants | 3–5 | Composants réutilisés |

### Étape 2 — Sélectionner
- De `audit.md` : ne garder que les règles **applicables** au projet (ex : i18n uniquement si l'i18n est présente).
- Ajouter les règles de la/les stack(s) détectée(s).
- Ajouter les règles propres au projet (`memory.md` + `architecture.md` si présent + analyse du code).
- Depuis `architecture.md`, compiler uniquement les règles vérifiables : dépendances, responsabilités par couche, patterns interdits, checklist d'audit.
- Fusionner les doublons : une règle universelle précisée par la stack → **une seule** entrée (la version la plus précise, avec le mécanisme exact).

### Étape 3 — Compiler
Produire `check.md` selon la structure ci-dessous (auto-suffisant).

### Étape 4 — Proposer et valider
Présenter le draft, attendre validation, puis écrire `check.md`.

---

## Structure de agent-project/check.md (compilé)

```markdown
# Check — [Nom du projet]

> Ruleset d'audit ACTIF. SEUL fichier de règles lu pendant un audit (+ memory.md).
> Compilé depuis : rules/audit.md + stacks/<...> + memory.md + architecture.md si présent — NE PAS éditer à la main
> les règles héritées : modifier la source puis régénérer (voir rules/maintenance.md).
> Stack : [langage + framework + versions] · Dernière compilation : [date]

## Changelog
- [date] : Compilation initiale

## Restrictions d'audit
- JAMAIS modifier du code sans validation explicite
- JAMAIS exécuter d'outils (linter, tests) sans demande
- TOUJOURS proposer avant d'appliquer, expliquer le pourquoi, prioriser CRITIQUE > MOYEN > MINEUR

## Checklist
### Architecture & responsabilité
- [ ] ...
### Typage & qualité
- [ ] ...
### Duplication
- [ ] ...
### Ponytail (parcimonie)
- [ ] ...  (abstraction/dépendance évitable, suppression > ajout, fix à la racine, `ponytail:`, 1 check)
### Valeurs / i18n (si applicable)
- [ ] ...  (fonctions exactes du projet : __(), trans(), __d()…)
### Validation
- [ ] ...
### Sécurité
- [ ] ...
### Performance (anti N+1 : mécanisme de l'ORM du projet)
- [ ] ...
### Exceptions & logs (debug interdit : [fonctions de la stack])
- [ ] ...
### Tests
- [ ] ...
### [Sections spécifiques stack : ORM, Events/Queues, UI/Composants…]
- [ ] ...

## Priorités
### CRITIQUES
- ...
### MOYENS
- ...
### MINEURS
- ...

## Format du rapport d'audit
- Titre : Rapport d'Audit — [Module/Feature]
- Sections : Points Positifs · Points d'Attention · Problèmes Critiques (VIOLATION / fichier:ligne / action)
- Actions correctives priorisées : CRITIQUES / MOYENS / MINEURS
- Métriques : conformité %, nb violations critiques, effort estimé
```

---

## Maintenance / régénération

Voir `agent/rules/maintenance.md` :
- Commande **"régénérer check"** → recompiler `check.md` depuis les sources.
- Déclencheurs : modification de `rules/audit.md`, `rules/ponytail.md`, d'un fichier `stacks/`, d'une convention de `memory.md`, ou d'une règle vérifiable de `architecture.md`.
- Taille cible de `check.md` : ≤ 250 lignes (ne compiler que l'applicable, fusionner les doublons).
