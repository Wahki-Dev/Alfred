# Agent — kit de règles pour IA de code

Écosystème de fichiers Markdown qui cadre le travail d'une IA de code (Cursor, Claude Code,
GitHub Copilot…) sur un projet : règles portables, mémoire spécifique au projet, workflow
contrôlé et audit compilé. Indépendant du langage de l'app.

Le contenu du kit est rédigé en **français**.

Fonctionnement détaillé et commandes : [`kit/README.md`](kit/README.md) et [`kit/commands.md`](kit/commands.md).

---

## Installation et mise à jour

Depuis la **racine** du projet (prérequis : `git`). La même commande installe et met à jour.

**Windows (PowerShell)** :
```powershell
irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```

**macOS / Linux** :
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh
```

Version précise (ex : `v1.3.0`) :
```powershell
$env:AGENT_KIT_VERSION = "v1.3.0"; irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh -s -- v1.3.0
```

Le script :
1. télécharge la dernière version publiée (ou celle demandée) ;
2. remplace `agent/` par le kit de cette version et écrit le numéro dans `agent/VERSION` ;
3. crée `agent-project/` (mémoire de l'app) s'il manque, sans jamais toucher à son contenu ;
4. crée les fichiers de démarrage IDE (`.cursor/rules/global.mdc`, `CLAUDE.md`,
   `.github/copilot-instructions.md`) s'ils sont absents.

`agent/` et `agent-project/` sont commités dans l'app : un `git clone` normal suffit.
Ne pas modifier `agent/` à la main dans une app : la mise à jour suivante l'écrase.
Une correction se fait dans ce dépôt, puis une nouvelle version est publiée.

Après une mise à jour, lancer la commande **`regen check`** dans l'IDE pour recompiler
`agent-project/check.md` avec les nouvelles règles.

---

## Versions

Chaque version est un tag git (`v1.0.0`, `v1.1.0`…), détaillée dans [`CHANGELOG.md`](CHANGELOG.md).

- **Patch** (`v1.0.1`) : correction ou reformulation, sans changement de commande ni de chemin.
- **Mineure** (`v1.1.0`) : ajout (commande, stack, blueprint) ; l'existant continue de fonctionner.
- **Majeure** (`v2.0.0`) : rupture (chemin ou commande renommé, bootstrap de `AGENT.md` modifié).

---

## Migrer une app qui a une ancienne copie du dossier `agent/`

Les anciennes copies gardaient la mémoire de l'app dans `agent/project/`. Le script refuse de
s'exécuter tant que ce dossier existe, pour ne pas l'écraser.

1. Déplacer `agent/project/` vers `agent-project/` à la racine de l'app.
2. Relancer le script d'installation.
3. Lancer **`regen check`** dans l'IDE.

---

## Contribuer

Les règles d'un nouveau langage ou framework s'ajoutent dans ce dépôt, par pull request,
dans `kit/stacks/<langage>/` (sur le modèle de `kit/stacks/php/`). Le kit reste unique :
toutes les apps, quel que soit leur langage, reçoivent les mêmes mises à jour des règles communes.

---

## Structure du dépôt

```
kit/                     ← Installé dans agent/ de chaque app
agent-project-template/  ← Copié dans agent-project/ de l'app (fichiers absents uniquement)
bootstrap/               ← Fichiers de démarrage IDE copiés à la racine de l'app (absents uniquement)
install.ps1              ← Installation / mise à jour (Windows)
install.sh               ← Installation / mise à jour (macOS / Linux)
CHANGELOG.md
LICENSE
```

---

## Licence

[MIT](LICENSE)
