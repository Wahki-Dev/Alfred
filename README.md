# Alfred

**Ton IA de code réfléchit avant de coder, teste ce qu'elle écrit, et respecte les règles de ton équipe.**

Claude Code, Cursor ou Copilot écrivent du code très vite. Souvent trop vite : ils foncent sans plan,
oublient tes conventions d'une session à l'autre, réinventent un helper qui existe déjà, ne lancent
pas les tests, et ne se posent aucune question de sécurité tant qu'on ne leur demande pas.

Alfred est un ensemble de règles en Markdown que tu installes dans ton projet. Ton IA le lit au
début de chaque session et travaille ensuite comme un développeur senior un peu maniaque : elle
propose un plan, attend ton feu vert, puis livre du code vérifié.

## À quoi ça ressemble

```
Toi    › Ajoute l'export CSV des factures, filtrable par client.

Alfred › Plan écrit : agent-project/plans/2026-11-06-1030-export-csv-factures.md
         4 étapes, 3 tests prévus.
         Feature sensible (export de fichiers) : revue sécurité obligatoire en fin de feature.
         ✋ Réponds OK pour lancer l'implémentation.

Toi    › OK

Alfred › Étapes 1 à 4 terminées.
         Tests : 12 passés · Larastan : OK · composer audit : aucune vulnérabilité
         Revue sécurité : injection CSV neutralisée (src/Exports/InvoiceCsv.php:42)
         Plan terminé.
```

Tu n'interviens qu'une fois, pour valider le plan. Pour un changement trivial (un libellé, une
couleur), Alfred applique directement et te montre le diff.

## Ce que ça change au quotidien

**Un plan avant chaque feature.** Il dit quels fichiers bougent, comment chaque exigence sera
vérifiée, et ce que la feature peut casser ailleurs : jobs, files, config, déploiement. Il est relu
avant de t'être présenté, et il reste dans le dépôt. Si la session s'interrompt, « reprends le plan
export-csv » suffit.

**Des tests qui tournent vraiment.** Une règle métier, un calcul ou un bug corrigé reçoit son test.
Alfred lance tes outils (tests, analyse statique, audit des dépendances) et rapporte leur résultat
réel. Ce qu'il n'a pas pu vérifier, il le dit.

**Moins de code.** Avant d'écrire quoi que ce soit, il cherche si ça existe déjà dans le projet,
dans la bibliothèque standard ou dans une dépendance installée. Pas de couche « au cas où ».

**La sécurité de base n'est pas négociable.** Autorisation côté serveur, accès aux données des
autres, injections, XSS, CSRF, secrets, mots de passe, upload : vérifiés sur chaque feature
sensible, et impossibles à désactiver. Alfred se méfie aussi de ce qu'il lit : une instruction
glissée dans un ticket ou une page web est signalée, jamais exécutée, et il ne lit pas ton `.env`.

**Une mémoire du projet.** Stack, conventions, architecture, règles métier : tout est écrit dans
`agent-project/`, versionné avec ton code. La session suivante repart de là, pas de zéro.

## Les règles de ton équipe

Chaque règle d'Alfred a un identifiant (`SEC-02`, `TEST-03`, `LAR-04`…). Ton équipe peut en ajouter,
en désactiver ou en durcir dans un seul fichier, `agent-project/rules.md` :

```markdown
## Ajouts
- **PRJ-01** · CRITIQUE — Les montants sont des entiers en centimes, jamais des float.

## Désactivations
- **LAR-05** (FormRequest) — on valide les entrées avec des DTO laravel-data — 2026-11-05

## Sévérités
- **PERF-01** (N+1) : MOYEN → CRITIQUE — nos listes dépassent les 10 000 lignes

## Portée
- **PHP-01** (`strict_types`) : nouveaux fichiers seulement — le legacy n'est pas typé
```

Ces règles s'appliquent quand l'IA code, pas seulement à l'audit. Et comme les règles du kit sont
lues telles quelles, deux projets avec la même version et le même `rules.md` sont jugés exactement
de la même façon.

## Installation

Depuis la racine du dépôt git de ton projet. La même commande installe et met à jour.

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```

**macOS / Linux**
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh
```

Ouvre ensuite ton IDE et tape `init` : Alfred analyse le projet et te propose sa mémoire en deux
validations.

Le script installe le kit dans `agent/`, crée `agent-project/` s'il n'existe pas (il n'y touche
plus jamais ensuite) et ajoute les fichiers de démarrage pour Claude Code, Cursor, Copilot et les
outils qui lisent `AGENTS.md`. Commite les deux dossiers : tes collègues ont Alfred dès le
`git clone`.

Pour figer une version :
```powershell
$env:AGENT_KIT_VERSION = "v1.0.0"; irm https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.ps1 | iex
```
```bash
curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh -s -- v1.0.0
```

Ne modifie pas `agent/` à la main, la prochaine mise à jour l'écrase : tes règles vont dans
`agent-project/rules.md`. Les nouveautés de chaque version sont dans le [CHANGELOG](CHANGELOG.md).

**Stacks** : la v1 a des règles dédiées pour PHP (Laravel, Symfony, CakePHP). Sur une autre stack,
le workflow, les tests, la sécurité et les règles générales fonctionnent déjà ; il manque seulement
les règles propres au langage. Le kit est rédigé en français.

## Contribuer

La contribution la plus utile aujourd'hui : **une nouvelle stack**. Node, Python, Go, Rails… Les
règles PHP dans [`kit/stacks/php/`](kit/stacks/php/) servent de modèle : une ligne par règle, un
identifiant, une sévérité, et seulement ce qui est propre à la techno (les principes généraux sont
déjà dans [`kit/rules/audit.md`](kit/rules/audit.md)).

Une règle qui manque, une règle qui fait plus de bruit qu'elle n'aide, un comportement de l'IA qui
t'a surpris : ouvre une issue avec l'exemple concret, c'est souvent plus utile qu'une PR.

Avant d'ouvrir une PR :
- un identifiant de règle n'est jamais réutilisé ; si tu en retires un, ajoute-le à
  `tests/retired-ids.txt` ;
- lance `bash tests/check-kit.sh` (liens internes, identifiants, commandes) ;
- si tu touches aux installeurs : `bash tests/install-test.sh` et `tests/install-test.ps1`.

Les choix de conception de la v1 sont expliqués dans [`docs/spec-v1.md`](docs/spec-v1.md).

---

Licence [MIT](LICENSE).
