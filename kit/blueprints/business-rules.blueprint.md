# Blueprint — agent-project/business-rules.md

> Registre des règles métier du projet : comportements et contraintes du domaine, jamais les conventions
> techniques. Source de vérité des règles actives et de leur historique.

---

## Écriture : toujours validée

- **Dans un plan** : les règles nouvelles ou modifiées sont listées dans la section « Règles métier ».
  Le OK du plan les valide ; elles sont écrites **en fin de feature** (`agent/rules/workflow.md` §5).
  Plan abandonné : rien n'est écrit.
- **Hors plan** (question, parcours rapide, analyse) : proposer la règle en une ligne, écrire après accord.
- **À l'`init` d'un projet existant** : proposer les règles explicites trouvées dans le code, les tests ou la
  documentation, avec leur source ; écrire après validation.

Le fichier est créé à la première règle validée.

## Avant d'écrire

1. Chercher un équivalent **sémantique** dans le registre, pas seulement textuel.
2. Identique → rien. Complète ou modifie une règle → mettre à jour et tracer l'ancienne formulation.
3. Contradiction ou ambiguïté → demander une clarification, ne rien écrire.
4. Chaque règle cite sa **source** : demande de l'utilisateur, plan, ou `fichier:ligne`. Pas de source,
   pas de règle.

## Ce qui est une règle métier

- Contrainte, permission, interdiction ou calcul propre au domaine.
- Condition qui détermine un état, une éligibilité, un changement de statut.

Ne le sont pas : conventions de code, choix techniques (→ `agent-project/rules.md` ou `memory.md`),
détails d'interface sans impact métier, hypothèses non confirmées.

## Identifiants

`BR-<domaine>-<slug>` (ex : `BR-facturation-arrondi-ttc`) : lisibles, et sans collision entre deux
branches qui ajoutent une règle en parallèle. Stables, jamais réutilisés.

## Structure

```markdown
# Règles métier — [Nom du projet]

## [Domaine]

### BR-[domaine]-[slug] — [Titre court]
- **Règle** : [formulation précise et testable]
- **Contexte** : [où / quand elle s'applique]
- **Source** : [demande, plan, fichier:ligne]
- **Depuis** : [AAAA-MM-JJ]

## Historique
- [AAAA-MM-JJ] `BR-…` créée — [résumé] — source : [référence]
- [AAAA-MM-JJ] `BR-…` modifiée — avant : « … » — après : « … » — source : [référence]
- [AAAA-MM-JJ] `BR-…` obsolète — dernière formulation : « … » — raison : [raison]
```

## Maintenance

- Une règle active n'apparaît qu'une fois, dans son domaine principal.
- Historique en ajout seul : jamais réécrit.
- Si le fichier devient difficile à parcourir : un fichier par domaine (`business-rules/<domaine>.md`),
  `business-rules.md` restant l'index avec l'historique.
- Chaque règle active devrait être couverte par un test (`TEST-01` de `agent/rules/tests.md`).
