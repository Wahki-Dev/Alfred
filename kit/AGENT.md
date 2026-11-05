# AGENT.md — Point d'entrée unique

> **Ce fichier est lu en PREMIER à chaque session, sans exception.**

---

## 1. Bootstrap de session (OBLIGATOIRE, dans cet ordre)

1. Lire ce fichier en entier
2. Vérifier l'existence de `agent-project/memory.md`
   - **Présent** → lire en entier
   - **Absent** → lancer la création immédiatement avant toute autre action, en détectant d'abord le type de projet **d'après le domaine métier** (pas la simple présence de code) :
     - **Existant** (domaine métier déjà codé, à analyser) → analyser le code via `agent/blueprints/memory.blueprint.md`, puis générer `architecture.md` via `agent/blueprints/architecture.blueprint.md`
     - **Amorce / starter kit** (ossature framework + auth présents, mais domaine métier vide) → enregistrer la stack détectée comme **contrainte imposée** (pas de choix de stack), puis router comme un projet vierge : aide à la décision `agent/stacks/<langage>/decisions.md` + direction technique (`agent/technical-directions/`) ; `architecture.md` décrit l'ossature du starter + la direction métier à construire
     - **Vierge** (peu/pas de code) → s'appuyer sur l'aide à la décision `agent/stacks/<langage>/decisions.md` + proposer une direction technique (`agent/technical-directions/`), puis rédiger `memory.md` et `architecture.md` via les blueprints
   - *(la procédure complète correspond à la commande `init` — voir `agent/commands.md`)*
3. Vérifier `agent-project/business-rules.md`
   - **Absent** → le créer automatiquement via `agent/blueprints/business-rules.blueprint.md`
   - **Présent** → le lire dès que la demande implique un comportement ou une contrainte métier
4. Identifier le type de demande → appliquer le routing (section 2)
5. Vérifier les autres fichiers projet (section 3) et proposer les manquants si pertinent

> **État d'avancement / reprise** : il n'y a PAS d'état global de session. Pour une demande de développement ou de correction, la reprise d'un travail en cours est résolue **par plan** (voir `agent/rules/workflow.md` §0bis) : l'avancement vit dans le front-matter du plan concerné (`agent-project/plans/...`). Plusieurs plans `en_cours` en parallèle est un état normal.

---

## 2. Routing

> **Routeur unique du projet.** Cette table est la seule autorité pour décider quels fichiers détaillés consulter selon le type de demande. `memory.md` et `workflow.md` s'y réfèrent — ils ne redéfinissent pas ce routing.

| Type de demande | Fichier à lire |
|---|---|
| Développement feature / correction bug | `agent/rules/workflow.md` |
| Comportement / contrainte / décision métier | `agent-project/business-rules.md` |
| Architecture / direction technique | `agent-project/architecture.md` |
| Cahier des charges / cadrage produit | `agent-project/cdc.md` + `agent/session/subagents/cdc-writer.md` |
| Roadmap / planification produit | `agent-project/roadmap.md` + `agent/session/subagents/roadmap-manager.md` |
| Audit / qualité de code | `agent-project/check.md` (ruleset compilé — **seul** fichier de règles lu) |
| Recettage / traitement bugs QA (Notion/Userback) | `agent-project/recettage.md` |
| Élément visuel / UI / composant | `agent-project/design.md` |
| Tests | `agent-project/tests.md` |
| Fonctionnalité à enjeu sécurité | `agent-project/security.md` + revue via `agent/session/subagents/security-reviewer.md` (gate bloquant en fin de feature, voir `agent/rules/workflow.md` §8) |
| Documentation / base de connaissance | `agent-project/knowledge.md` |
| Audit des fichiers agent eux-mêmes | `agent/rules/maintenance.md` |

**Règle** : si plusieurs contextes s'appliquent simultanément, lire tous les fichiers concernés dans l'ordre du tableau.

> **Modèle d'audit (compilé)** : `agent-project/check.md` est un artefact **compilé** depuis les sources
> `agent/rules/audit.md` (base universelle) + `agent/stacks/<langage>/...` (techno) + `agent-project/memory.md` + `agent-project/architecture.md` si présent.
> Pendant un audit, l'agent ne lit QUE `check.md` (+ `memory.md`) — jamais `audit.md` ni `stacks/`.
> Compilation et régénération : voir `agent/blueprints/check.blueprint.md` et `agent/rules/maintenance.md`.

---

## 3. Fichiers projet — vérification au démarrage

| Fichier | Si absent |
|---|---|
| `agent-project/memory.md` | Créer immédiatement (voir `agent/blueprints/memory.blueprint.md`) |
| `agent-project/business-rules.md` | **Créer automatiquement** via `agent/blueprints/business-rules.blueprint.md` ; aucun accord préalable requis |
| `agent-project/architecture.md` | Créer immédiatement après `memory.md` via `agent/blueprints/architecture.blueprint.md` (projet existant ou vierge) |
| `agent-project/check.md` | **Compiler** immédiatement après `memory.md` et `architecture.md` (détecter la stack, voir `agent/blueprints/check.blueprint.md`) |
| `agent-project/cdc.md` | Proposer à l'utilisateur de le créer via `agent/session/subagents/cdc-writer.md` (prioritaire pour un projet vierge) |
| `agent-project/roadmap.md` | Proposer à l'utilisateur de le créer via `agent/session/subagents/roadmap-manager.md` (prioritaire pour un projet vierge) |
| `agent-project/plans/` | Créer le dossier au premier plan (1 fichier/feature ; l'état d'avancement vit dans le front-matter du plan — voir `agent/rules/workflow.md` §1 et §0bis) |
| `agent-project/design.md` | Proposer à l'utilisateur de le créer |
| `agent-project/recettage.md` | Proposer à l'utilisateur (nécessite remplissage des placeholders) |
| `agent-project/tests.md` | Proposer à l'utilisateur de le créer |
| `agent-project/security.md` | Proposer à l'utilisateur de le créer |
| `agent-project/knowledge.md` | Proposer à l'utilisateur de le créer |

---

## 4. Règles globales permanentes

### Comportement
- JAMAIS coder sans que le plan ait été validé explicitement par l'utilisateur, sauf parcours rapide accepté (`agent/rules/workflow.md` §0ter) : cet accord autorise d'enchaîner jusqu'à la résolution
- TOUJOURS questionner les implications au-delà du diff : code, traitement asynchrone, exploitation, infrastructure (`agent/rules/workflow.md` §1)
- JAMAIS modifier des fichiers de configuration sans permission explicite
- JAMAIS exécuter de commandes terminales sans validation
- JAMAIS dupliquer des fonctionnalités existantes
- JAMAIS surcharger le code avec des features non demandées
- TOUJOURS proposer avant d'appliquer pour toute modification importante
- TOUJOURS vérifier l'existant avant de créer (recherche exhaustive)
- TOUJOURS être force de proposition sans outrepasser : proposer sans imposer

### Mémoire projet
- TOUJOURS respecter les règles de `agent-project/memory.md`
- Le routing est centralisé dans `AGENT.md §2` (routeur unique) : consulter les fichiers détaillés qu'il désigne selon le type de demande, avant toute décision dans le domaine concerné (structure → `architecture.md`, UI → `design.md`, tests → `tests.md`, sécurité → `security.md`)
- Si un nouveau pattern technique émerge en session : proposer son ajout dans `agent-project/memory.md`, attendre validation, puis appliquer
- Si une règle métier certaine émerge : vérifier `agent-project/business-rules.md`, éviter tout doublon sémantique, puis l'ajouter ou la mettre à jour automatiquement avec son historique. En cas d'ambiguïté ou de contradiction, demander une clarification avant écriture
- Si une action contredit une règle existante : refuser et expliquer, ou proposer une modification justifiée de la règle
- Traiter `agent-project/memory.md` comme la source de vérité absolue pour ce projet
- Traiter `agent-project/business-rules.md` comme la source de vérité des règles métier actives et de leur historique

### Validation obligatoire avant chaque modification de code
1. Conformité avec `agent-project/memory.md`
2. Conformité avec `agent-project/business-rules.md` si le domaine métier est concerné
3. Absence de duplication
4. Respect des standards du projet
5. Documentation : nouvelle règle métier certaine → synchroniser automatiquement `business-rules.md` ; nouveau pattern technique → proposer son ajout à `memory.md`

---

## 5. Maintenance des fichiers agent

Commande déclencheur : **"audit fichiers agent"**
→ Lire `agent/rules/maintenance.md` et appliquer le processus complet.

L'IA peut également **proposer** un audit si elle détecte une incohérence entre les fichiers projet lors d'une session.

---

## 6. Commandes

Le catalogue des commandes est dans `agent/commands.md` (ex : `init`, `regen check`, `tâche suivante`, `fin traitement`).
Si l'utilisateur appelle une commande, appliquer la procédure décrite dans ce fichier.
