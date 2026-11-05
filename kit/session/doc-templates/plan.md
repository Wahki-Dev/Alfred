---
feature: slug-court
statut: brouillon        # brouillon | validé | en_cours | terminé
current: 0
total: 0
securite: non           # requise | non — si requise : revue sécurité bloquante en fin (workflow §8)
---

# Plan — [Nom de la feature]

> Fichier : `agent-project/plans/AAAA-MM-JJ-HHMM-slug.md`
> Date : [AAAA-MM-JJ HH:MM]
> État d'avancement : front-matter ci-dessus (source de vérité de la progression)

## Contexte
- Pourquoi
- Comportement actuel

## Objectifs / Non-objectifs
- Objectifs:
- Non-objectifs:

## Exigences (avec tests associés)
1. Exigence A
   - Vérification: (comment prouver que ça marche)
2. Exigence B
   - Vérification:

> Ajouter des tests uniquement sur demande explicite de l'utilisateur, selon
> `agent-project/tests.md`. Ne couvrir que le code applicatif ou métier testable,
> jamais les mécanismes du framework, de l'ORM ou les migrations.

## Règles métier concernées
- Existantes : `BR-NNN` — [titre]
- Nouvelles / modifiées : [règle certaine à synchroniser automatiquement dans `agent-project/business-rules.md`]
- Ambiguïtés à clarifier : [si applicable]

## Architecture (décisions minimales)
- Option retenue + justification
- Alternatives rejetées + pourquoi

## Modèles de données
- Schémas / types / migrations
- Contraintes & validations

## Changements (où)
- Fichiers à lire:
- Fichiers à modifier/créer:

## Erreurs & edge cases
- ...

## Implications transverses
> Posture lead / architecte. Chaque axe est renseigné. `non concerné` exige une raison.
- Code :
- Traitement asynchrone :
- Exploitation :
- Infrastructure :

## Rapport d’incident
> À compléter pendant l’implémentation uniquement en cas d’incident.
- Erreur :
- Cause :
- Impact :
- Correctif :
- Vérification :

## Questions non résolues (ultra concises)
- Q1:
- Q2:
