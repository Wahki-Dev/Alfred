# Workflow — Process de développement

## Autorité des règles
- `agent/AGENT.md` + `agent-project/memory.md` restent la source de vérité.
- `agent-project/business-rules.md` est la source de vérité des règles métier actives et de leur historique.
- `agent/AGENT.md §2` est le routeur unique : il désigne les fichiers détaillés à consulter selon le type de demande (`architecture.md`, `design.md`, `tests.md`, `security.md`).
- Ce workflow est une surcouche organisationnelle. Il ne remplace rien.
- L'outil d'audit officiel est : `agent-project/check.md` (ruleset compilé ; sources : `agent/rules/audit.md` + `agent/stacks/`).

---

## Principe
Travailler en cycles courts, contrôlés et continus, avec compteur de progression.

Avant le cycle, qualifier la demande (§0ter). Si le parcours rapide est proposé et accepté,
l'agent enchaîne jusqu'à la résolution, sans plan ni découpage.

Sinon, parcours standard. La revue de plan n'est pas une étape : elle fait toujours partie
du PLAN (§1). Après la validation de ce plan, l'agent enchaîne automatiquement toutes les
tâches jusqu'au LANDING + AUDIT, sans attendre de commande entre deux tâches. Il ne
s'arrête que lorsqu'une décision utilisateur non résolue est réellement bloquante, ou à la
demande explicite de l'utilisateur :
1. PLAN (rédaction + revue, une seule étape)
2. TASK SPLIT (compteur + état, sans afficher toutes les tâches)
3. IMPLEMENT (tâche n/X)
4. CODE REVIEW (read-only, optionnel)
5. RESET MENTAL + ROADMAP SYNC (si `agent-project/roadmap.md` existe)
6. NEXT TASK (n+1)/X
7. LANDING + AUDIT (global, fin de feature)

Les titres de sections ci-dessous conservent leurs numéros historiques (`§3` à `§8`) :
la revue n'a plus de section propre.

---

## 0bis) Résolution du plan actif (sécurité d'état) (obligatoire)

L'état d'avancement vit dans le **front-matter du plan** (`agent-project/plans/<plan>.md`), pas dans un fichier global. Une session ne pilote QU'UN seul plan : le **plan actif**.

Avant toute planification :

1. Identifier la feature demandée et chercher le plan correspondant (slug) dans `agent-project/plans/`.
2. Selon le `statut` du plan trouvé :
   - **aucun plan** → qualifier d'abord (§0ter). Parcours rapide accepté : pas de plan. Sinon PLAN MODE (§1)
   - **`brouillon` / `validé`** → reprendre à l'étape correspondante
   - **`en_cours`** → demander UNE décision : **"reprendre"** ou **"réinitialiser"** (pour CE plan)
3. Annoncer le plan actif : `plan actif : agent-project/plans/<fichier>`.

Effet :
- reprendre → continuer avec la tâche `current/total` du plan
- réinitialiser → remettre le plan à `statut: validé / current: 0 / total: 0` (le contenu du plan est conservé)

Plusieurs plans `en_cours` simultanés est un état **normal** (travail en parallèle) : chaque session ne touche qu'à son plan actif.

---

## 0) Démarrage de session (obligatoire)

Avant toute action :

1. Lire `agent-project/memory.md`
2. Créer `agent-project/business-rules.md` s'il manque, puis le lire si la demande touche au métier
3. Appliquer le routing de `agent/AGENT.md §2` : lire tous les fichiers détaillés correspondant au type de demande (ex. `architecture.md` si structure/couches/patterns ; `design.md` si UI/composant ; `tests.md` si tests ; `security.md` si enjeu sécurité)
4. Faire une recherche anti-duplication (fichiers similaires / patterns)
5. Résumer en 5 lignes :
   - conventions applicables
   - fichiers probablement concernés
   - risques / zones sensibles
   - hypothèses
   - questions (si nécessaire)

Sortie attendue :
- bref état des lieux

---

## 0ter) Qualification du parcours (obligatoire)

Avant toute planification, classer la demande. Le parcours rapide n'est acceptable que si
**toutes** les conditions suivantes sont vraies :

- changement local et évident : wording, libellé, couleur, texte statique, ajustement
  d'affichage strictement borné à l'endroit demandé
- aucune complexité technique : pas de logique, de donnée, de contrat, d'API, de permission
- aucun effet de bord identifiable
- aucun impact global : composant partagé, thème, token de design, copie ou traduction
  réutilisée ailleurs, règle métier, sécurité

Dès qu'un doute existe sur un effet de bord ou un impact global, la demande n'est **pas**
simple. Ne pas proposer le parcours rapide. Exemples qui imposent le parcours standard :
fichier de jobs ou de file, traitement asynchrone, config, infrastructure, exploitation,
modèle de données, règle métier, sécurité, style ou composant partagé.

Si le parcours rapide est acceptable, le proposer et s'arrêter :

```
Parcours rapide proposé — changement local, sans effet de bord ni impact global identifié.
Réponds OUI pour enchaîner jusqu'à la résolution, ou NON pour le parcours standard (plan).
```

- **OUI** → implémenter, vérifier le résultat, terminer. Pas de fichier plan, pas de task
  split, pas d'arrêt intermédiaire. Si un effet de bord, un impact global ou une décision
  bloquante apparaît en cours de route : stopper et basculer au parcours standard (§0bis).
- **NON** → parcours standard.

---

## 1) PLAN MODE (avant de coder) (obligatoire)

Objectif : produire un plan simple, testable, sans sur-ingénierie.

Le plan DOIT contenir :
- Exigences (fonctionnelles / non-fonctionnelles)
- Règles métier concernées : références `BR-NNN` existantes et nouvelles règles certaines à synchroniser
- Échelle ponytail montée (`agent/rules/ponytail.md`) : barreau le plus bas qui tient — réutiliser/stdlib/1 ligne avant de prévoir du code neuf
- Décisions d'architecture (minimales, justifiées)
- Référence aux fichiers détaillés du routing `agent/AGENT.md §2` concernés par la feature (ex. `architecture.md` pour une décision structurante, `design.md` pour l'UI)
- Modèles de données (schémas, types, migrations si besoin)
- Si l'utilisateur demande explicitement des tests : stratégie intégrée au fil des exigences
  (pas « à la fin »), conforme à `agent-project/tests.md` et limitée au code applicatif ou
  métier testable. Ne pas prévoir de tests du framework, de l'ORM ou des migrations.
- Liste des fichiers/chemins à lire et modifier
- Edge cases / erreurs attendues
- Implications transverses (voir ci-dessous) — posture lead / architecte
- Section « Rapport d’incident » (template : `agent/session/doc-templates/plan.md`)
- Questions non résolues ultra concises (si besoin)

### Implications transverses (obligatoire)

Se placer en lead / architecte. Le diff local ne suffit pas. Pour chaque feature, questionner
les implications plus larges et les écrire dans le plan. Si un axe ne s'applique pas, le
dire explicitement (`non concerné` + pourquoi), jamais le passer sous silence.

- **Code** : appelants, états partagés, contrats, régressions, effets de bord
- **Traitement asynchrone** : files, jobs, événements, cron, retries, concurrence, blocage
  (ex. une file qui se remplit ou se bloque parce qu'un maillon ne consomme plus)
- **Exploitation** : logs, alertes, mode de panne, reprise, ce qu'un opérateur doit voir
- **Infrastructure** : config, ressources, déploiement, environnements, capacité

Template : `agent/session/doc-templates/plan.md`

### Détection « feature à enjeu sécurité » (obligatoire)

Évaluer si la feature touche un déclencheur de `agent/blueprints/security.blueprint.md`
(authentification / session, mots de passe, rôles et permissions, écriture de données
utilisateur sur son compte ou celui d'un autre, endpoints publics / API exposée, upload de
fichiers).

- Si **oui** → marquer le plan comme sensible dans son front-matter (`securite: requise`) et
  l'annoncer. Une revue sécurité sera **obligatoire et bloquante** avant la fin (voir §8).
- Si **non** → `securite: non` dans le front-matter.

### Écriture du plan dans un fichier (obligatoire)

Le plan n'est PAS qu'un message de conversation : il est écrit dans un fichier dédié.
- Dossier : `agent-project/plans/` (le créer s'il est absent)
- Nommage : `AAAA-MM-JJ-HHMM-slug.md` (horodatage de création + slug court de la feature)
  - ex : `2026-06-25-1530-export-csv-factures.md`
  - le tri alphabétique liste l'ancien en premier ; le plan le plus récent est donc le **dernier** de la liste
- Contenu : suivre `agent/session/doc-templates/plan.md`, avec le **front-matter d'état** en tête (`statut: brouillon`, `current: 0`, `total: 0`, `securite: requise|non`)
- Présenter aussi le plan dans la conversation (résumé) + indiquer le chemin du fichier créé

### Revue intégrée (obligatoire, même étape)

La revue n'est pas une étape séparée et ne se lance pas sur commande. Elle s'exécute
**toujours** dans ce PLAN, avant de présenter le plan à l'utilisateur.

1. Lancer `agent/session/subagents/plan-reviewer.md` avec le plan comme input (read-only)
2. Rapport : critique / important / suggestions / verdict
3. Appliquer les corrections dans le fichier du plan, puis relancer la revue
4. Répéter tant que le verdict n'est pas APPROUVÉ, sauf si un point exige une décision
   utilisateur : le laisser dans « Questions non résolues » et présenter quand même

Le rapport de revue reste dans la conversation (résumé 5–10 lignes). Le plan amendé est
dans `agent-project/plans/...`.

### ARRÊT OBLIGATOIRE APRÈS LE PLAN REVU

Après avoir présenté le plan déjà revu, TOUJOURS terminer par ce bloc exact :

```
✋ Plan revu et présenté — en attente de ta validation avant de continuer.
Réponds OK pour lancer l'implémentation, ou indique les ajustements.
```

INTERDIT de passer au Task Split (§3) sans réponse explicite de l'utilisateur.
INTERDIT de coder avant ce OK.
Si l'utilisateur demande un ajustement : modifier le plan, relancer la revue intégrée, puis
représenter.

Après OK, passer directement au Task Split. Ne pas attendre une commande supplémentaire.

---

## 3) TASK SPLIT (sub-agent task-splitter) (obligatoire)

Objectif :
- Marquer le plan actif `statut: validé` (il vient d'être validé)
- Déterminer le nombre total de tâches (X)
- Initialiser l'état dans le front-matter du **plan actif**
- Ne jamais afficher la liste complète des tâches

Actions :
1. Lancer `agent/session/subagents/task-splitter.md`
2. Le task-splitter :
   - Calcule X
   - Écrit dans le front-matter du plan actif : `statut: en_cours / current: 1 / total: X`
   - Retourne uniquement la tâche **1/X** (format `agent/session/doc-templates/task.md`)

Sortie attendue :
- `Tâche 1/X`
- Bloc `Tâche NOW`
- Rien d'autre

---

## 4) IMPLEMENTATION (tâche n/X) (obligatoire)

Pour la tâche courante :

1. Re-check : `agent-project/memory.md` + `agent-project/business-rules.md` si le métier est concerné + les fichiers du routing `agent/AGENT.md §2` applicables à la tâche (`architecture.md`, `design.md`, `tests.md`, `security.md`) + anti-duplication
2. Draft si action majeure, auto si mineure
3. Implémenter en montant l'échelle ponytail (`agent/rules/ponytail.md`) : réutiliser > stdlib > 1 ligne ; marquer les raccourcis `ponytail:` ; laisser 1 check runnable si logique non triviale
4. Si une règle métier certaine apparaît ou évolue, synchroniser automatiquement
   `agent-project/business-rules.md` selon son blueprint avant de terminer la tâche. Ne rien
   écrire en cas de doublon ; demander une clarification en cas d'ambiguïté ou contradiction.
5. Si l'implémentation révèle un impact code, asynchrone, d'exploitation ou d'infrastructure
   absent du plan : stopper, compléter « Implications transverses », et ne reprendre qu'après
   accord sur cet écart.
6. En cas d'incident (erreur, blocage ou comportement inattendu), compléter le « Rapport
   d’incident » du plan actif avec l'erreur, sa cause, son impact, le correctif et sa
   vérification.
7. Préparer la revue (diff / fichiers touchés)

Sortie attendue :
- `Terminé: n/X` ou `En cours: n/X`
- Fichiers modifiés
- Diff prêt

---

## 5) NEXT TASK (tâche suivante) (automatique)

Après le Reset mental, si `current <= total` :
- Lire le front-matter du plan actif (`agent-project/plans/<plan>.md`)
- Annoncer `Tâche current/total`
- Fournir la tâche NOW
- Enchaîner immédiatement avec son implémentation (§4)

La commande utilisateur **"tâche suivante"** reste disponible uniquement pour reprendre ou
relancer ce passage après une interruption.

Sortie attendue :
- `Tâche n/X`
- Bloc `Tâche NOW`
- Rien d'autre

---

## 6) CODE REVIEW (sub-agent code-reviewer — read-only) [optionnel]

Si demandé :
1. Fournir `git diff` + objectif de la tâche
2. Lancer `agent/session/subagents/code-reviewer.md`
3. Résumé court + corrections proposées

---

## 7) RESET MENTAL (obligatoire) — FIN de tâche, AVANT de passer à la suivante

Procédure :
1. Relire `agent-project/memory.md`
2. Relire `agent-project/business-rules.md` si la tâche touche au métier et vérifier que les règles détectées sont indexées
3. Relire les fichiers du routing `agent/AGENT.md §2` applicables à la tâche (ex. `architecture.md` si structure/couches/patterns ; `design.md` si UI ; `tests.md` ; `security.md`)
4. Re-scan ciblé anti-duplication
5. Si `agent-project/roadmap.md` existe, lancer `agent/session/subagents/roadmap-manager.md` avec :
   - le plan actif
   - la tâche NOW terminée
   - l'objectif de la tâche
   Le sous-agent identifie la tâche roadmap correspondante et propose son passage à `terminé`. Si la correspondance est incertaine, demander confirmation. Aucune mise à jour roadmap sans validation explicite.
6. Re-synthèse 5 lignes max :
   - objectif
   - fichiers
   - contraintes
   - points d'audit
   - hypothèses

Effet attendu (dans le front-matter du plan actif) :
- Incrémenter `current` à `n+1` si `n < X`
- Si une tâche roadmap correspondante est validée comme terminée, mettre à jour son statut dans `agent-project/roadmap.md`
- Si `current <= total`, passer automatiquement à §5 ; sinon passer automatiquement à §8.

---

## 8) LANDING + AUDIT (global, fin de feature) (obligatoire)

Condition :
- `current > total` (enchaînement automatique après la dernière tâche)
- OU commande utilisateur : **"Fin traitement"**

Actions :
1. Audit global via `agent-project/check.md` (une seule fois)
2. Vérifier que toutes les règles métier certaines apparues pendant la feature sont présentes
   sans doublon dans `agent-project/business-rules.md` et que leur historique est à jour.
3. **Revue sécurité (gate bloquant)** : si le plan actif est `securite: requise`, lancer
   `agent/session/subagents/security-reviewer.md` (input : objectif, diff, routes/permissions
   touchées). **INTERDIT de finir sans cette revue.** Tant qu'une faille critique (bloquante)
   subsiste, le plan ne peut PAS passer `terminé`. Après revue, proposer la mise à jour de
   `agent-project/security.md` (format `agent/blueprints/security.blueprint.md`).
4. **Contrôle de conformité au plan validé** (`agent-project/plans/<plan de la feature>.md`) :
   - chaque exigence / changement prévu au plan est bien implémenté (couverture complète, rien d'oublié)
   - le code produit ne s'écarte pas du plan validé sans justification (pas de hors-périmètre non validé)
   - signaler tout écart ou élément du plan non traité comme point d'audit
5. Si `agent-project/roadmap.md` existe, lancer `agent/session/subagents/roadmap-manager.md` pour proposer la mise à jour finale des tâches roadmap liées au plan actif.
6. Rapport complet dans la conversation (audit + revue sécurité + conformité au plan + roadmap si applicable)
7. Corrections restantes (si non conforme ou faille critique)
8. Passer le plan actif à `statut: terminé` (uniquement si la revue sécurité est passée pour un plan `securite: requise`)

Rappel : aucune commande terminale sans validation explicite.
