# Agent — kit de règles pour IA de code

Écosystème de fichiers Markdown qui cadre le travail d'une IA de code (Cursor, Claude Code,
GitHub Copilot…) sur un projet : règles portables, mémoire spécifique au projet, règles propres
à l'équipe, workflow contrôlé (plan → revue → OK → code) et audit.

**v1 : PHP (Laravel, Symfony, CakePHP).** Les règles universelles s'appliquent à toute stack ;
les règles de stack existent seulement pour PHP.

Le contenu du kit est rédigé en **français**.

Fonctionnement détaillé et commandes : [`kit/README.md`](kit/README.md) et [`kit/commands.md`](kit/commands.md).

---

## Installation et mise à jour

Depuis la **racine du dépôt git** du projet (prérequis : `git`). La même commande installe et met à jour.

**Windows (PowerShell)** :
```powershell
irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```

**macOS / Linux** :
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh
```

Version précise (ex : `v1.0.0`) :
```powershell
$env:AGENT_KIT_VERSION = "v1.0.0"; irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh -s -- v1.0.0
```

Le script :
1. télécharge la dernière version stable publiée (les pré-versions `-rc`, `-beta` sont ignorées),
   ou celle demandée ;
2. remplace `agent/` par le kit de cette version (remplacement atomique, avertissement si
   `agent/` contient des modifications non commitées) et écrit la version et le SHA du commit
   dans `agent/VERSION` ;
3. crée `agent-project/` (mémoire de l'app) s'il manque, sans jamais toucher à son contenu,
   dont `agent-project/rules.md` : les **règles de l'équipe** (ajouts, désactivations,
   sévérités, portée), jamais écrasé par une mise à jour ;
4. crée les fichiers de démarrage IDE (`.cursor/rules/global.mdc`, `CLAUDE.md`, `AGENTS.md`,
   `.github/copilot-instructions.md`) s'ils sont absents.

`agent/` et `agent-project/` sont commités dans l'app : un `git clone` normal suffit.
Ne pas modifier `agent/` à la main dans une app : la mise à jour suivante l'écrase.
Une règle propre à l'équipe ou au projet va dans `agent-project/rules.md`.
Une correction du kit se fait dans ce dépôt, puis une nouvelle version est publiée.

Après une mise à jour, il n'y a rien à recompiler : relire le [`CHANGELOG.md`](CHANGELOG.md),
commiter `agent/`, et vérifier que les identifiants de règles cités dans
`agent-project/rules.md` existent toujours (l'agent le signale au démarrage de session).

---

## Versions

Chaque version est un tag git (`v1.0.0`, `v1.1.0`…), détaillée dans [`CHANGELOG.md`](CHANGELOG.md).

- **Patch** (`v1.0.1`) : correction ou reformulation, sans changement de commande ni de chemin.
- **Mineure** (`v1.1.0`) : ajout (commande, stack, règle) ; l'existant continue de fonctionner.
- **Majeure** (`v2.0.0`) : rupture (chemin ou commande renommé, identifiant de règle retiré,
  bootstrap de `AGENT.md` modifié).

---

## Migrer une app qui a une ancienne copie du dossier `agent/`

Les anciennes copies gardaient la mémoire de l'app dans `agent/project/`. Le script refuse de
s'exécuter tant que ce dossier existe, pour ne pas l'écraser.

1. Déplacer `agent/project/` vers `agent-project/` à la racine de l'app.
2. Relancer le script d'installation.
3. Supprimer `agent-project/check.md` et `agent-project/tests.md` s'ils existent (remplacés en v1
   par les règles du kit et `agent-project/rules.md`).

---

## Contribuer

Les règles d'un nouveau langage ou framework s'ajoutent dans ce dépôt, par pull request,
dans `kit/stacks/<langage>/` (sur le modèle de `kit/stacks/php/`). Le kit reste unique :
toutes les apps, quel que soit leur langage, reçoivent les mêmes mises à jour des règles communes.

Chaque règle vérifiable porte un identifiant stable (`SEC-02`, `LAR-04`…), jamais réutilisé.
Un identifiant retiré est ajouté à `tests/retired-ids.txt`. La CI (`tests/check-kit.sh`)
vérifie les liens internes, l'unicité des identifiants et le catalogue des commandes.

---

## Structure du dépôt

```
kit/                     ← Installé dans agent/ de chaque app
agent-project-template/  ← Copié dans agent-project/ de l'app (fichiers absents uniquement)
bootstrap/               ← Fichiers de démarrage IDE copiés à la racine de l'app (absents uniquement)
docs/                    ← Documents de conception du kit (non installés)
tests/                   ← Scripts de vérification du dépôt (CI)
install.ps1              ← Installation / mise à jour (Windows)
install.sh               ← Installation / mise à jour (macOS / Linux)
CHANGELOG.md
LICENSE
```

---

## Licence

[MIT](LICENSE)
