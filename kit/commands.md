# Commandes

> Le langage naturel suffit pour le travail courant : « ajoute l'export CSV des factures »,
> « reprends le plan export-csv », « termine la feature ». Les commandes ci-dessous déclenchent des
> procédures précises. Les règles d'`agent/AGENT.md` s'appliquent toujours.

## Index des commandes

| Commande | Effet |
|---|---|
| `init` | Initialiser `agent-project/` dans un projet où le kit vient d'être installé |
| `audit` | Auditer un module, un dossier ou le diff en cours |
| `architecture` | Rédiger ou mettre à jour `agent-project/architecture.md` |
| `cdc` | Rédiger ou mettre à jour `agent-project/cdc.md` |
| `roadmap` | Rédiger ou mettre à jour `agent-project/roadmap.md` |
| `audit fichiers agent` | Maintenance des fichiers de `agent-project/` |

---

## init

**Quand** : `agent-project/memory.md` n'existe pas.

1. **Type de projet** (seul endroit où il est défini), d'après le domaine métier et pas la simple présence
   de code :
   - **existant** : domaine métier déjà codé → analyser le code ;
   - **starter** : ossature framework et auth présentes, domaine vide → la stack est une contrainte
     imposée, puis traiter comme vierge ;
   - **vierge** : peu ou pas de code → questions de `agent/stacks/<langage>/decisions.md`.
   Stack sans dossier dans `agent/stacks/` : le dire ; seules les règles universelles s'appliqueront.
2. **Validation 1** — présenter ensemble :
   - `memory.md` (`agent/blueprints/memory.blueprint.md`), avec les commandes de vérification ;
   - `architecture.md` (`agent/blueprints/architecture.blueprint.md`) : description fidèle si existant ;
     sinon direction `custom` par défaut, `ddd-lite` seulement si le test de décision de
     `agent/technical-directions/ddd-lite.md` le justifie ;
   - projet existant : règles métier explicites trouvées, avec leur source
     (`agent/blueprints/business-rules.blueprint.md`) ;
   - projet existant : surcharges proposées pour `rules.md` quand une règle du kit est violée massivement
     par le code actuel (le plus souvent une portée « nouveaux fichiers et fichiers modifiés »), pour que
     le premier audit reste lisible.
3. **Validation 2** — présenter ensemble :
   - `security.md` (`agent/blueprints/security.blueprint.md`) si le projet expose une interface web ou une API ;
   - `design.md` (`agent/blueprints/design.blueprint.md`) si le projet a une interface.
4. Projet **vierge** ou **starter** : proposer `cdc.md` (`agent/session/subagents/cdc-writer.md`), puis
   `roadmap.md` (`agent/session/subagents/roadmap-manager.md`).
5. **Configuration de l'IDE** (modification de config : uniquement avec permission) : proposer d'autoriser
   les commandes de vérification sans confirmation et d'interdire la lecture de `.env*`
   (ex : `permissions` dans `.claude/settings.json`, `.cursorignore`).
6. **Résumé** : fichiers créés, stack, direction, surcharges, ce qui reste à confirmer.

Pas de framework de test : proposer d'en installer un (`agent/rules/tests.md`).

---

## audit

**Quand** : à la demande (« audit », « audite le module facturation »). La fin de feature lance déjà un audit
du diff.

Appliquer la procédure de `agent/rules/audit.md` sur la cible (par défaut : le diff en cours) : règles du
kit + `agent-project/rules.md`, commandes de vérification lancées, rapport avec identifiant, sévérité,
`fichier:ligne` et correction. Aucune correction appliquée sans validation.

---

## architecture

**Quand** : changement de structure, décision technique, ou `architecture.md` absent.

1. Projet existant : décrire l'architecture réelle ; vierge : proposer une direction
   (`agent/technical-directions/custom.md` par défaut, `ddd-lite.md` si le test de décision le justifie).
2. Présenter le draft (`agent/blueprints/architecture.blueprint.md`), écrire après validation.
3. Proposer la mise à jour du résumé dans `memory.md`.

---

## cdc

1. Lire `memory.md` s'il existe.
2. Appliquer `agent/session/subagents/cdc-writer.md` et `agent/blueprints/cdc.blueprint.md`.
3. Écrire après validation.

---

## roadmap

1. Lire `roadmap.md` et `cdc.md` s'ils existent.
2. Appliquer `agent/session/subagents/roadmap-manager.md` et `agent/blueprints/roadmap.blueprint.md`.
3. Statuts autorisés : `à_faire`, `en_cours`, `terminé`, `bloqué`, `abandonné`.
4. Écrire après validation.

---

## audit fichiers agent

Appliquer `agent/rules/maintenance.md` : contrôle de cohérence de `agent-project/`, rapport, corrections
après validation.
