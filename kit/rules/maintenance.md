# Maintenance — Audit des fichiers agent

> Commande `audit fichiers agent`. L'agent peut aussi la **proposer** quand il remarque une incohérence.
> Toujours : rapport → validation de l'utilisateur → application de ce qui est validé.

Objectif : des fichiers `agent-project/` justes, à jour, sans contradiction ni doublon, et courts pour
ceux qui sont lus à chaque session (`memory.md`, `rules.md`).

---

## Contrôles

**Global**
- Chaque référence vers un fichier, un dossier ou une commande existe encore.
- Pas de contradiction entre fichiers (ex : une convention de `memory.md` contredite par `design.md`).
- Une même information ne vit qu'à un endroit : description → `memory.md` / `architecture.md` ;
  règle imposée → `rules.md` ; règle métier → `business-rules.md`.

**`memory.md`**
- Les commandes de vérification fonctionnent (les lancer) et ne modifient aucun fichier.
- Plus de `[À DÉFINIR]` ; pas de détail qui appartient à `architecture.md` ou `rules.md` ; pas d'exemple
  de code long.

**`rules.md`**
- Chaque identifiant visé (désactivation, sévérité, portée) existe dans la version du kit (`agent/VERSION`).
- Chaque désactivation a une raison et une date ; aucune ne vise une règle `socle`.
- Les règles `PRJ-NN` sont uniques, formulées de façon vérifiable, avec une sévérité.

**`business-rules.md`**
- Identifiants uniques, chaque règle a une source et une date ; pas de doublon sémantique.
- Règles cohérentes avec le code actuel ; historique intact.

**`architecture.md`**
- Décrit la structure réelle (dossiers existants) ; pas de règle d'audit recopiée depuis le kit.

**`security.md`**
- Socle revérifié (en-têtes, auth, secrets ignorés par git) ; date mise à jour.
- Limites assumées encore valides (la feature existe, le périmètre est exact).
- Aucun détail exploitable, aucun secret.

**`design.md`**
- Les composants cités existent dans le projet.

**`plans/`**
- Plans `en_cours` sans activité récente : proposer `terminé` ou `abandonné`.

**`recettage.md`** (si présent)
- Aucun `{{…}}` restant ; URLs et identifiants encore valides.

---

## Rapport

```markdown
# Maintenance agent-project/ — [AAAA-MM-JJ]

## Problèmes
| Fichier | Problème | Proposition |
|---|---|---|

## Vérifié sans problème
- …
```

Après validation : appliquer, puis tracer dans le changelog de `memory.md` ce qui a changé.
