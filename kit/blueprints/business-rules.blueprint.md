# Template — Génération de agent-project/business-rules.md

> Ce fichier définit le registre vivant des règles métier propres au projet.
> Il contient les comportements et contraintes du domaine, jamais les conventions techniques.

---

## Création automatique

Si `agent-project/business-rules.md` est absent, le créer automatiquement pendant le
bootstrap, sans demander de validation, avec la structure minimale ci-dessous.

Pour un projet existant, analyser les règles métier déjà explicites dans le code, les tests
et la documentation. N'enregistrer que les règles certaines ; signaler les règles ambiguës
comme questions, sans les ajouter.

## Mise à jour automatique

À chaque demande, planification, implémentation ou correction :

1. Détecter toute règle métier formulée, confirmée ou rendue explicite.
2. Lire le registre et rechercher un équivalent sémantique, pas seulement textuel.
3. Si elle existe à l'identique : ne rien ajouter.
4. Si elle complète ou modifie une règle existante : mettre à jour cette règle et tracer
   l'ancienne formulation dans l'historique.
5. Si elle est nouvelle et certaine : l'ajouter automatiquement dans le domaine pertinent.
6. Si elle contredit une règle existante ou reste ambiguë : demander une clarification
   avant toute mise à jour.
7. Si elle devient obsolète : la retirer des règles actives et tracer son obsolescence dans
   l'historique ; ne jamais effacer l'historique.

Cette écriture automatique est une exception explicite à la validation préalable des
fichiers `agent-project/`. L'agent annonce brièvement toute modification effectuée.

## Ce qui constitue une règle métier

- Contrainte, permission, interdiction ou calcul propre au domaine.
- Condition qui détermine un état, une éligibilité ou un changement de statut métier.
- Comportement attendu par les utilisateurs ou l'organisation.

Ne sont pas des règles métier :
- conventions de code, architecture et choix techniques ;
- détails d'interface sans impact sur le domaine ;
- hypothèses temporaires non confirmées.

## Structure de agent-project/business-rules.md

```markdown
# Règles métier — [Nom du projet]

> Dernière mise à jour : [AAAA-MM-JJ HH:MM]
> Source de vérité des règles métier actives du projet.

## [Domaine métier]

### BR-001 — [Titre court]
- **Règle** : [formulation précise et testable]
- **Contexte** : [où/quand elle s'applique]
- **Source** : [demande, plan, fichier ou décision]
- **Ajoutée le** : [AAAA-MM-JJ]
- **Modifiée le** : [AAAA-MM-JJ, uniquement si applicable]

## Historique
- [AAAA-MM-JJ HH:MM] `BR-001` créée — [résumé] — source : [référence]
- [AAAA-MM-JJ HH:MM] `BR-001` modifiée — ancienne règle : « ... » — nouvelle règle : « ... » — source : [référence]
- [AAAA-MM-JJ HH:MM] `BR-001` rendue obsolète — dernière règle : « ... » — raison : [raison]
```

## Règles de maintenance

- Identifiants `BR-NNN` stables, uniques et jamais réutilisés.
- Une règle active n'apparaît qu'une fois, dans son domaine principal.
- Formulation concise, non ambiguë et vérifiable.
- Historique append-only : aucune entrée n'est supprimée ni réécrite.
- Éviter les exemples longs ; référencer le plan ou le code concerné.
- Taille cible : ≤ 250 lignes ; au-delà, créer des fichiers par domaine et conserver
  `business-rules.md` comme index avec historique central.
