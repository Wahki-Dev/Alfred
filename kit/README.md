# Agent AI — Installation & Fonctionnement

Écosystème de fichiers qui cadre le travail d'une IA de code sur un projet : règles
portables, mémoire spécifique au projet, workflow contrôlé et audit compilé.

> Pour le **détail des commandes et de leur fonctionnement** (catalogue complet, usage
> quotidien, procédures pas-à-pas) : voir **`commands.md`**.

---

## Fonctionnement (comment ça marche ?)

Cette section répond à « comment ça marche ? » sans avoir à ouvrir tous les fichiers.

### Idée générale
Toute l'intelligence du dispositif tient dans **un point d'entrée unique** : `AGENT.md`.
L'IDE est juste configuré pour lire ce fichier au début de chaque session. À partir de là,
`AGENT.md` orchestre tout : il vérifie l'état, lit la mémoire du projet, puis route la
demande vers le bon fichier de règles.

### Le cycle d'une session
```
Début de session
   │
   ▼
1. Lire AGENT.md (toujours, en premier)
   │
   ▼
2. agent-project/memory.md existe ?
   ├─ non → l'analyser/le créer (commande `init`) avant toute autre action
   └─ oui → le lire (= source de vérité du projet)
   │
   ▼
3. agent-project/business-rules.md existe ?
   ├─ non → le créer automatiquement
   └─ oui → le lire si la demande touche au métier
   │
   ▼
4. Router la demande (section Routing ci-dessous)
   │
   ▼
5. (dev/correction) Résoudre le plan actif (agent-project/plans/) ──► statut == en_cours ? → "reprendre" / "réinitialiser"
   │
   ▼
6. Qualifier la demande (workflow.md) : parcours rapide si changement local sans effet de bord, sinon PLAN (revue intégrée) → IMPLEMENT → AUDIT
```

### Routing : à chaque demande, le bon fichier
`AGENT.md` aiguille selon le type de demande :

| Demande | Fichier lu |
|---|---|
| Développer une feature / corriger un bug | `rules/workflow.md` (+ `rules/ponytail.md` pour la parcimonie) |
| Comportement ou contrainte métier | `agent-project/business-rules.md` |
| Architecture / direction technique | `agent-project/architecture.md` |
| Cahier des charges / cadrage produit | `agent-project/cdc.md` + `session/subagents/cdc-writer.md` |
| Roadmap / planification produit | `agent-project/roadmap.md` + `session/subagents/roadmap-manager.md` |
| Audit / qualité de code | `agent-project/check.md` (ruleset compilé) |
| Recettage QA (Notion/Userback) | `agent-project/recettage.md` |
| UI / composant visuel | `agent-project/design.md` |
| Tests | `agent-project/tests.md` |
| Sécurité | `agent-project/security.md` |
| Documentation | `agent-project/knowledge.md` |
| Maintenance des fichiers agent | `rules/maintenance.md` |

### Les trois familles de fichiers
- **Portables (jamais modifiés)** : `rules/` et `stacks/`. Règles universelles et règles
  par techno. Identiques d'un projet à l'autre.
- **Spécifiques au projet (générés par l'IA)** : `agent-project/`. La mémoire, l'architecture,
  le ruleset d'audit, et les fichiers optionnels (design, tests…). À ne **pas** copier d'un projet à l'autre.
- **Session** : `session/`. Sous-agents et templates. L'état d'avancement n'est plus global : il vit dans le front-matter de chaque plan (`agent-project/plans/`), ce qui permet plusieurs features en parallèle.

### Le modèle d'audit « compilé »
Les règles de contrôle ne sont **pas** relues éparpillées à chaque audit. Elles sont
**compilées une fois** dans un seul fichier actif, `agent-project/check.md` :

```
rules/audit.md                (universel)   ┐
rules/ponytail.md             (parcimonie)  ├─► compilation ─► agent-project/check.md  ◄── SEUL fichier lu à l'audit
stacks/<stack>                (techno)      │
agent-project/memory.md       (projet)      │
agent-project/architecture.md               ┘
```

Quand une source change, on recompile via la commande **`regen check`**.
(Détail de la compilation : `blueprints/check.blueprint.md`.)

### Le principe de validation
L'IA **propose toujours avant d'appliquer**. Aucune écriture de code, de fichier `agent-project/`
ou de commande terminale sans accord explicite. L'exception est `agent-project/business-rules.md` :
il est créé et synchronisé automatiquement quand une règle métier certaine est détectée.

### Les commandes
L'utilisateur peut déclencher des procédures précises via des commandes (`init`,
`regen check`, `tâche suivante`, `fin traitement`…). Le **détail de chaque commande et de
son fonctionnement** est dans **`commands.md`**.

---

## Structure du dossier

Deux dossiers à la racine de l'app :
- `agent/` : le kit, installé et mis à jour par le script d'installation. **Ne pas le modifier
  à la main** : la prochaine mise à jour l'écrase.
- `agent-project/` : la mémoire de l'app, générée par l'IA. Jamais touchée par une mise à jour.

Les deux sont commités dans le dépôt de l'app.

```
agent/
  VERSION               ← Version du kit installée (écrit par le script d'installation)
  AGENT.md              ← Point d'entrée unique (lu en premier à chaque session)
  README.md             ← Ce fichier (installation + fonctionnement)
  commands.md           ← Utilisation : catalogue des commandes + usage quotidien

  rules/                ← Règles universelles — portables, jamais modifiées
    workflow.md         ← Process : qualification, PLAN (revue intégrée), IMPLEMENT, AUDIT
    ponytail.md         ← Philosophie de code (lazy/parcimonie) — process + SOURCE compilée dans check.md
    audit.md            ← Base universelle de règles (SOURCE, compilée dans check.md)
    maintenance.md      ← Audit et mise à jour des fichiers agent

  stacks/               ← Règles par techno (SOURCE, compilée dans check.md)
    php/
      php.md            ← Commun à tous les projets PHP
      laravel.md        ← Spécifique Laravel
      symfony.md        ← Spécifique Symfony
      cakephp.md        ← Spécifique CakePHP
      decisions.md      ← Aide à la décision pour un projet vierge

  technical-directions/ ← Directions techniques proposées à l'init
    custom.md           ← Base : contrôleurs fins → services
    ddd-lite.md         ← Hybride : base custom + DDD ciblé sur le métier complexe
    ddd-guide-pratique.md ← Tutoriel : décider DDD/classique + process + exemples
    ddd-light-hexagonal-guide.md ← Annexe détaillée de ddd-lite (zone métier complexe)

  session/              ← Sous-agents et templates (pas d'état global)
    subagents/          ← Agents spécialisés (plan-reviewer, task-splitter, etc.)
    doc-templates/      ← Templates de documents (plan, tâche, rapport)

  blueprints/           ← Blueprints source pour générer les fichiers agent-project/
    memory.blueprint.md
    business-rules.blueprint.md
    architecture.blueprint.md
    check.blueprint.md  ← Décrit la COMPILATION de agent-project/check.md
    cdc.blueprint.md
    roadmap.blueprint.md
    design.blueprint.md
    recettage.blueprint.md
    tests.blueprint.md
    security.blueprint.md
    knowledge.blueprint.md

agent-project/          ← Générés par l'IA, spécifiques à CE projet
  memory.md             ← Tour de contrôle : résumé + fichiers à consulter
  business-rules.md     ← Index vivant et historique des règles métier
  architecture.md       ← Direction technique détaillée
  check.md              ← Ruleset d'audit ACTIF (compilé) — seul fichier lu à l'audit
  cdc.md                ← Cahier des charges produit
  roadmap.md            ← Roadmap produit + statuts des tâches
  design.md             ← Design system et règles UI
  security.md           ← Audits sécurité
  tests.md              ← Règles de tests
  knowledge.md          ← Règles documentation
  recettage.md          ← Config recettage QA (Notion/Userback)
  plans/                ← Plans de feature (1 fichier/feature, AAAA-MM-JJ-HHMM-slug.md) — avancement dans le front-matter
```

---

## Installation sur un nouveau projet

### Étape 1 — Lancer le script d'installation
Depuis la **racine** du projet (prérequis : `git`) :

**Windows (PowerShell)** :
```powershell
irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```

**macOS / Linux** :
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh
```

Le script :
1. télécharge la dernière version publiée du kit (ou celle demandée, voir « Mise à jour ») ;
2. installe le kit dans `agent/` et écrit la version dans `agent/VERSION` ;
3. crée `agent-project/` et `agent-project/plans/` s'ils manquent, sans jamais toucher à leur contenu ;
4. crée les fichiers de démarrage IDE de l'étape 2 s'ils sont absents.

### Étape 2 — Configurer l'IDE (bootstrap minimal)
Le script crée ces fichiers s'ils sont absents. S'ils existent déjà, il ne les modifie pas :
y ajouter l'instruction à la main.

**Cursor** — `.cursor/rules/global.mdc` :
```
À chaque début de session, lire obligatoirement le fichier `agent/AGENT.md` en entier avant toute action.
```

**Claude Code** — `CLAUDE.md` :
```
À chaque début de session, lire obligatoirement le fichier `agent/AGENT.md` en entier avant toute action.
```

**GitHub Copilot** — `.github/copilot-instructions.md` :
```
At the start of every session, read `agent/AGENT.md` entirely before any action.
```

**Windsurf / autre** : chercher l'équivalent « custom instructions » / « system prompt »
et y mettre la même directive.

### Étape 3 — Première session
Lancer une session et formuler une première demande (ou la commande `init`).

L'IA va automatiquement :
1. Lire `agent/AGENT.md`
2. Détecter que `agent-project/memory.md` est absent
3. Créer automatiquement `agent-project/business-rules.md`
4. Analyser le projet (dépendances, framework, architecture, conventions et règles métier certaines)
5. Proposer un draft de `memory.md` → validation → écriture
6. Proposer un draft de `architecture.md` → validation → écriture
7. **Compiler** `agent-project/check.md` (stack détectée → règles universelles + `stacks/<stack>` + `memory.md` + `architecture.md`)
8. Si le projet est vierge, proposer et aider à rédiger `agent-project/cdc.md` puis `agent-project/roadmap.md`

Les autres fichiers projet (`design.md`, `tests.md`…) sont proposés au fil des besoins.

---

## Mise à jour du kit

Relancer la commande d'installation : elle remplace `agent/` par la dernière version et
laisse `agent-project/` intact. Une app où la commande n'est pas relancée garde sa version.

Pour une version précise (ex : `v1.3.0`) :

```powershell
$env:AGENT_KIT_VERSION = "v1.3.0"; irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```

```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh -s -- v1.3.0
```

Après une mise à jour :
- commiter `agent/` (le diff montre ce qui a changé dans le kit) ;
- lancer **`regen check`** : `agent-project/check.md` est compilé depuis `rules/` et `stacks/`,
  il ne suit pas la nouvelle version tant qu'il n'est pas recompilé.

---

## Maintenance

Audit complet des fichiers de l'écosystème : commande **`audit fichiers agent`**
(processus dans `rules/maintenance.md`). L'audit vérifie cohérence, duplication, taille
des fichiers (anti-bloat) et règles obsolètes/contradictoires.

→ Pour l'usage quotidien et toutes les commandes, voir **`commands.md`**.
