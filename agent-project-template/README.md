# agent-project/

Ce dossier contient les fichiers générés par l'IA pour CE projet.
Ne pas copier son contenu d'un projet à l'autre.

Les blueprints de génération sont dans `agent/blueprints/`.

Fichiers principaux :
- `memory.md` : mémoire projet, résumé des conventions et règles (le routing est dans `AGENT.md §2`)
- `business-rules.md` : index vivant des règles métier actives et historique de leurs évolutions
- `architecture.md` : direction technique détaillée, structure, dépendances et patterns
- `check.md` : ruleset d'audit compilé
- `cdc.md` : cahier des charges produit
- `roadmap.md` : roadmap produit avec statuts de tâches
- `plans/` : plans de feature avec état d'avancement en front-matter

Sur tout projet, vierge ou existant, l'agent doit proposer ou générer `architecture.md` via `agent/blueprints/architecture.blueprint.md`.
Sur tout projet, l'agent crée automatiquement `business-rules.md` via `agent/blueprints/business-rules.blueprint.md`, puis le synchronise sans doublon dès qu'une règle métier certaine apparaît. Une ambiguïté ou contradiction doit être clarifiée avant écriture.
Sur un projet vierge, l'agent doit proposer et aider à rédiger `cdc.md` puis `roadmap.md`.
Les tâches de `roadmap.md` doivent avoir un statut, mis à jour quand la tâche correspondante est terminée.
