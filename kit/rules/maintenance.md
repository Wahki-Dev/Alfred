# Maintenance — Audit des fichiers agent

> **Déclencheur** : commande **"audit fichiers agent"** ou détection d'incohérence par l'IA.
> **Règle absolue** : toujours proposer les modifications → attendre validation → appliquer.

---

## Objectif

Garder les fichiers `agent-project/` utiles, cohérents, à jour et non redondants.

---

## Déclenchement

### Automatique (l'IA propose)
- Incohérence détectée entre deux fichiers projet
- Règle dans `memory.md` contredite par un pattern récent
- **Source modifiée** (`rules/audit.md`, `rules/ponytail.md` ou un fichier `stacks/...`) → proposer de **régénérer `check.md`**
- Nouvelle règle architecturale dans `memory.md` → vérifier si `check.md` doit être régénéré
- Section d'un fichier jamais référencée depuis plusieurs sessions

### Manuel (commande utilisateur)
- `"audit fichiers agent"` → audit complet
- `"audit memory"` → audit ciblé sur `memory.md` uniquement
- `"audit check"` → audit ciblé sur `check.md` uniquement
- `"régénérer check"` → recompiler `check.md` depuis les sources (voir `agent/blueprints/check.blueprint.md`)

---

## Règles d'audit

### Anti-bloat
- **Seuil** : ~200 lignes par fichier `agent-project/`
- Si dépassement : identifier les sections peu utiles, proposer de les synthétiser ou supprimer
- Une règle claire en 2 lignes vaut mieux qu'un paragraphe de 10 lignes
- Interdire les exemples de code trop longs dans `memory.md` (pointer vers des fichiers de référence dans le projet)

### Anti-duplication
- La même règle ne peut pas figurer dans deux fichiers différents
- Les règles métier vivent dans `business-rules.md` et ne doivent pas être répétées dans `memory.md`, `design.md`, `tests.md`, etc.
- Rechercher les doublons sémantiques entre règles métier, même si leur formulation diffère
- En cas de doublon : garder la version dans le fichier le plus pertinent, supprimer l'autre

### Cohérence
- Pas de contradiction entre les fichiers (ex: une règle dans `memory.md` contredite dans `design.md`)
- Les références croisées entre fichiers doivent être valides (fichier référencé existe)
- Le changelog de `memory.md` doit refléter les modifications réelles

### Actualité
- Supprimer les règles devenues obsolètes (ex: pattern abandonné)
- Mettre à jour les références à des fichiers/dossiers renommés
- Proposer d'archiver (commenter avec date) plutôt que supprimer si incertain

---

## Processus d'audit complet

### Étape 1 — Inventaire
1. Lister tous les fichiers présents dans `agent-project/`
2. Vérifier leur existence (certains peuvent manquer)
3. Mesurer la taille de chaque fichier (nombre de lignes)

### Étape 2 — Analyse par fichier

Pour chaque fichier `agent-project/` :

**memory.md**
- [ ] Taille ≤ 200 lignes
- [ ] Pas de sections vides ou placeholder non rempli
- [ ] Pas de doublon avec d'autres fichiers projet
- [ ] Changelog à jour
- [ ] Règles cohérentes avec l'état actuel du projet

**business-rules.md**
- [ ] Chaque identifiant `BR-NNN` est stable et unique
- [ ] Aucune règle active dupliquée sémantiquement
- [ ] Règles cohérentes avec le comportement métier actuel
- [ ] Sources et dates renseignées
- [ ] Historique complet, chronologique et jamais réécrit
- [ ] Règles obsolètes absentes des sections actives mais conservées dans l'historique

**check.md** (artefact compilé)
- [ ] Taille ≤ 250 lignes
- [ ] **À jour avec ses sources** (`rules/audit.md` + `rules/ponytail.md` + `stacks/<stack>` + `memory.md`) — la duplication de contenu est normale (compilation)
- [ ] Auto-suffisant : contient restrictions + checklist priorisée + format de rapport
- [ ] Ne contient que les règles **applicables** au projet (pas de section de stack non utilisée)
- [ ] Cohérence avec `memory.md` (toute convention architecturale a une entrée de checklist)
- [ ] Changelog / date de compilation à jour

**design.md**
- [ ] Taille ≤ 200 lignes
- [ ] Référence des composants qui existent réellement dans le projet
- [ ] Pas de règles UI déjà dans memory.md

**tests.md**
- [ ] Taille ≤ 150 lignes
- [ ] Règles de test cohérentes avec le framework actuel
- [ ] Pas de règles dupliquées avec memory.md

**security.md**
- [ ] Audits datés (chaque section a une date)
- [ ] Features auditées toujours existantes dans le projet
- [ ] Sections "durcissements optionnels" non appliqués encore valides

**knowledge.md / recettage.md**
- [ ] Placeholders remplis (aucun `{{...}}` restant)
- [ ] Config encore valide (URLs, IDs, etc.)

### Étape 3 — Rapport

Produire un rapport structuré :

```markdown
# Rapport de Maintenance — agent-project/ [date]

## État des fichiers
| Fichier | Lignes | Statut |
|---|---|---|
| memory.md | X | OK / À nettoyer |
| design.md | X | OK / Manquant |
| ... | | |

## Problèmes détectés
### Critiques
- ...

### Mineurs
- ...

## Propositions de modifications
1. [fichier] — [action] — [justification]
2. ...
```

### Étape 4 — Validation
- Présenter le rapport à l'utilisateur
- Attendre validation explicite pour chaque modification proposée
- Appliquer uniquement ce qui est validé

### Étape 5 — Application
- Appliquer les modifications validées
- Mettre à jour le changelog de `memory.md` si des règles ont changé
- Confirmer les modifications effectuées

---

## Règles de mise à jour de memory.md

Quand une nouvelle règle émerge en session :
1. L'IA propose l'ajout (texte exact)
2. L'utilisateur valide
3. Ajouter dans la section la plus pertinente (pas en fin de fichier)
4. Mettre à jour le changelog
5. Vérifier qu'aucune règle existante n'est contredite

Quand une règle est modifiée :
1. Proposer la nouvelle formulation + justification
2. Mettre à jour le changelog avec la date et la raison

Quand une règle est supprimée :
1. Expliquer pourquoi elle est obsolète
2. Supprimer uniquement après validation
3. Tracer dans le changelog

## Règles de mise à jour de business-rules.md

Appliquer automatiquement `agent/blueprints/business-rules.blueprint.md` dès qu'une règle
métier certaine est détectée. Vérifier d'abord l'existence d'un équivalent sémantique.
Toute création, modification ou obsolescence doit être tracée dans l'historique.
En cas d'ambiguïté ou de contradiction, demander une clarification avant écriture.

---

## Régénération de agent-project/check.md (artefact compilé)

> `check.md` est compilé depuis `rules/audit.md` + `rules/ponytail.md` + `stacks/<stack>` + `memory.md`.
> On ne le modifie pas à la main pour les règles héritées : on **régénère** (voir `agent/blueprints/check.blueprint.md`).

**Déclencheurs de régénération** :
- Modification de `rules/audit.md` (base universelle)
- Modification de `rules/ponytail.md` (parcimonie)
- Modification d'un fichier `stacks/...` de la stack du projet
- Nouvelle convention / anti-pattern dans `memory.md`
- Commande **"régénérer check"**

**Processus** :
1. Identifier la/les source(s) modifiée(s) et leur impact sur le ruleset
2. Recompiler `check.md` (sélection des règles applicables + fusion des doublons)
3. Présenter le diff, attendre validation
4. Écrire `check.md` + mettre à jour la date de compilation et le changelog

Exemples :
- Nouvelle règle universelle dans `audit.md` → ajoutée à `check.md` si applicable au projet
- Nouveau mécanisme dans `stacks/php/laravel.md` → reflété dans la section correspondante de `check.md`
- Nouvelle convention de nommage dans `memory.md` → entrée "Nommage (CRITIQUE)" de `check.md`
