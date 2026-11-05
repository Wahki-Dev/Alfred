# Utilisation — Commandes & usage quotidien

> Comment se servir de l'écosystème au quotidien. Pour l'installation et le fonctionnement
> global, voir `README.md`.
>
> `@` ce fichier puis appelle une commande (ex : `init`, `regen check`).
> Chaque commande décrit ce que l'IA doit faire. Les règles d'`AGENT.md` s'appliquent toujours :
> **proposer avant d'appliquer**, validation explicite avant tout code ou écriture de fichier.

---

## Comment ça s'utilise

- **Demande normale** : il suffit de formuler la demande. L'IA fait son bootstrap
  (lecture `AGENT.md` → `memory.md`) puis route automatiquement (voir `README.md`).
- **Commande** : taper un mot-clé du catalogue ci-dessous (ex : `init`, `tâche suivante`,
  `fin traitement`) pour déclencher une procédure précise.

### Ce que l'IA fait automatiquement
- Lit `agent-project/memory.md` à chaque session (source de vérité du projet)
- Crée `agent-project/business-rules.md` s'il manque, puis maintient automatiquement son index et son historique dès qu'une règle métier certaine est détectée
- Consulte `agent-project/architecture.md` quand `memory.md` l'indique pour une décision structurante
- Propose des mises à jour de `memory.md` si un nouveau pattern émerge
- Qualifie la demande (`rules/workflow.md` §0ter) : propose le parcours rapide seulement pour un changement local sans effet de bord ni impact global ; sinon parcours standard
- Maintient l'état d'avancement dans le front-matter du plan actif (`agent-project/plans/...`) pendant un workflow de feature
- Propose la mise à jour du statut roadmap quand une tâche correspondante est terminée
- Détecte les incohérences entre fichiers projet (et peut proposer un audit)

### Ce qui nécessite toujours ta validation
- Toute modification de code
- Toute création/mise à jour d'un fichier `agent-project/`, sauf `agent-project/business-rules.md`, créé et synchronisé automatiquement
- Toute commande terminale

---

## Index des commandes
| Commande | Alias | Effet |
|---|---|---|
| `init` | — | Initialiser l'écosystème dans un projet fraîchement installé |
| `architecture` | `direction technique` | Proposer / rédiger / mettre à jour `agent-project/architecture.md` |
| `cdc` | `cahier des charges` | Proposer / rédiger `agent-project/cdc.md` |
| `roadmap` | `feuille de route` | Proposer / rédiger / mettre à jour `agent-project/roadmap.md` |
| `regen check` | `régénérer check` | Recompiler `agent-project/check.md` depuis les sources |
| `tâche suivante` | — | Reprendre ou relancer le passage à la tâche suivante |
| `fin traitement` | — | Audit final + remise à zéro de l'état |
| `audit fichiers agent` | — | Maintenance complète des fichiers agent |
| `audit memory` | — | Audit ciblé de `agent-project/memory.md` |
| `audit check` | — | Audit ciblé de `agent-project/check.md` |
| `reprendre` | — | Reprendre un workflow en cours |
| `réinitialiser` | — | Réinitialiser l'état du workflow |

---

## init

**Quand** : première fois, le kit vient d'être installé dans `agent/` (voir `README.md`) — rien n'est encore généré.

**Étapes** :
1. Créer le dossier `agent-project/plans/` s'il manque (l'avancement de chaque feature vivra dans le front-matter de son plan ; pas d'état global de session).
2. Créer automatiquement `agent-project/business-rules.md` via `blueprints/business-rules.blueprint.md`. Pour un projet existant, y indexer uniquement les règles métier certaines détectées dans le code, les tests ou la documentation.
3. Détecter le type de projet **d'après le domaine métier** (pas la simple présence de code) : **existant**, **amorce / starter kit**, ou **vierge**.
   - **Existant** (domaine métier déjà codé) → analyser stack, framework + versions, structure, conventions, anti-patterns (méthode : `blueprints/memory.blueprint.md`) puis préparer `agent-project/architecture.md` via `blueprints/architecture.blueprint.md`.
   - **Amorce / starter kit** (ossature framework + auth présents, domaine métier vide) → relever la stack, framework + versions et conventions du scaffold et les enregistrer comme **contrainte imposée** (sans proposer de choix de stack), puis router comme **vierge** pour la suite : `stacks/<langage>/decisions.md` + direction technique. `agent-project/architecture.md` décrit l'ossature du starter + la direction métier à construire.
   - **Vierge** (peu/pas de code) → utiliser l'**aide à la décision** `stacks/<langage>/decisions.md` puis proposer une direction technique (`technical-directions/custom.md` = base, ou `technical-directions/ddd-lite.md` = hybride si coeur métier complexe) ; laisser trancher.
4. Proposer un draft de `agent-project/memory.md` (choix validés uniquement) → validation → écrire.
5. Proposer un draft de `agent-project/architecture.md` via `blueprints/architecture.blueprint.md` → validation → écrire.
6. Détecter la stack. Si elle n'a pas de fichier dans `stacks/` → proposer de le créer (règles modernes).
7. **Compiler** `agent-project/check.md` (`rules/audit.md` applicable + `rules/ponytail.md` + `stacks/<stack>` + `memory.md` + `architecture.md`) — méthode : `blueprints/check.blueprint.md` → validation → écrire.
8. Si le projet est **vierge** ou une **amorce / starter kit** : proposer systématiquement `agent-project/cdc.md` via `session/subagents/cdc-writer.md`, puis `agent-project/roadmap.md` via `session/subagents/roadmap-manager.md`.
9. Proposer (sans imposer) les fichiers projet optionnels pertinents : `design.md`, `tests.md`, `security.md`, `knowledge.md`, `recettage.md`.
10. Résumé : ce qui a été créé, stack détectée, direction technique, fichiers restant à proposer.

**Validation** : chaque fichier `agent-project/` est présenté en draft et écrit seulement après accord, sauf `business-rules.md`, dont la création et la synchronisation sont automatiques.

---

## architecture
*(alias : `direction technique`)*

**Quand** : initialisation, changement de structure, décision technique, architecture trop implicite, ou absence de `agent-project/architecture.md`.

**Étapes** :
1. Lire `agent-project/memory.md` s'il existe.
2. Détecter si le projet est **existant** ou **vierge**.
3. **Existant** → analyser l'architecture réelle et rédiger un draft fidèle via `blueprints/architecture.blueprint.md`.
4. **Vierge** → proposer une direction technique depuis `technical-directions/` (`custom` par défaut ; `ddd-lite` = hybride, base custom + DDD ciblé sur le métier complexe, si justifié).
5. Présenter le draft de `agent-project/architecture.md`.
6. Attendre validation explicite avant écriture ou mise à jour.
7. Proposer la mise à jour courte de `agent-project/memory.md` pour pointer vers `architecture.md`.

---

## cdc
*(alias : `cahier des charges`)*

**Quand** : nouveau projet, cadrage produit incomplet, ou demande explicite de cahier des charges.

**Étapes** :
1. Lire `agent-project/memory.md` s'il existe.
2. Lancer `session/subagents/cdc-writer.md`.
3. Utiliser `blueprints/cdc.blueprint.md` pour proposer un draft de `agent-project/cdc.md`.
4. Attendre validation explicite avant écriture ou mise à jour.

---

## roadmap
*(alias : `feuille de route`)*

**Quand** : nouveau projet, planification produit, ou mise à jour des statuts de tâches roadmap.

**Étapes** :
1. Lire `agent-project/roadmap.md` s'il existe, ainsi que `agent-project/cdc.md` si disponible.
2. Lancer `session/subagents/roadmap-manager.md`.
3. Utiliser `blueprints/roadmap.blueprint.md` pour proposer une création ou une mise à jour.
4. Vérifier que chaque tâche a un statut autorisé : `à_faire`, `en_cours`, `terminé`, `bloqué`, `abandonné`.
5. Attendre validation explicite avant écriture ou mise à jour.

---

## regen check
*(alias : `régénérer check`)*

**Quand** : une source a changé (`rules/audit.md`, `rules/ponytail.md`, un fichier `stacks/...`, ou une convention de `memory.md`), ou besoin de recompiler.

**Étapes** :
1. Identifier la/les source(s) modifiée(s) et leur impact.
2. Recompiler `agent-project/check.md` (sélection des règles applicables + fusion des doublons) — méthode : `blueprints/check.blueprint.md`.
3. Présenter le diff → validation.
4. Écrire `check.md` + mettre à jour la date de compilation et le changelog.

---

## tâche suivante

**Quand** : après une interruption d'un workflow de développement, pour reprendre le passage
automatique à la tâche suivante.

**Étapes** : appliquer `rules/workflow.md` §5 — lire le front-matter du plan actif
(`agent-project/plans/...`), fournir la tâche `current/total` au format
`session/doc-templates/task.md`, puis l'implémenter immédiatement. Le passage à la tâche
suivante est automatique pendant un workflow non interrompu.

---

## fin traitement

**Quand** : la feature est terminée.

**Étapes** : appliquer `rules/workflow.md` §8 — audit global via `agent-project/check.md`, contrôle de conformité au plan validé, rapport complet, corrections restantes si non conforme, puis passage du plan actif à `statut: terminé`.

---

## audit fichiers agent

**Quand** : maintenir/nettoyer les fichiers de l'écosystème agent.

**Étapes** : appliquer le processus complet de `rules/maintenance.md` (inventaire, analyse par fichier, rapport, validation, application).

---

## audit memory · audit check

**Quand** : audit ciblé d'un seul fichier.

**Étapes** : appliquer `rules/maintenance.md` restreint au fichier visé (`agent-project/memory.md` ou `agent-project/check.md`).

---

## reprendre · réinitialiser

**Quand** : à la résolution du plan actif (`rules/workflow.md` §0bis), si ce plan a `statut: en_cours`.

**Étapes** (sur le **plan actif** uniquement) :
- `reprendre` → continuer avec la tâche `current/total` du plan.
- `réinitialiser` → remettre le plan à `statut: validé / current: 0 / total: 0` (le contenu du plan est conservé).
