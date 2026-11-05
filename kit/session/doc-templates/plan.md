---
feature: slug-court
statut: brouillon     # brouillon | en_cours | terminé | abandonné
securite: non         # requise | non — requise : revue sécurité bloquante en fin de feature
tests: oui            # oui | non (« OK sans tests »)
---

# Plan — [Nom de la feature]

> Fichier : `agent-project/plans/AAAA-MM-JJ-HHMM-slug.md`
> Sections marquées *(si utile)* : à supprimer quand elles ne s'appliquent pas.

## Objectif
- Pourquoi, et comportement actuel
- Non-objectifs :

## Fichiers concernés
- À lire :
- À modifier / créer :

## Étapes
- [ ] 1. …
- [ ] 2. …

## Vérification
| Exigence | Preuve |
|---|---|
| … | test `…` (agent/rules/tests.md) ou commande `…` |

## Règles métier
- Existantes concernées : `BR-…`
- Nouvelles ou modifiées (écrites en fin de feature si le plan est validé) : …
- Ambiguïtés à trancher : …

## Implications transverses
- Code :
- Asynchrone :
- Exploitation :
- Infrastructure :

## Modèle de données *(si utile)*
- Schémas, migrations, contraintes

## Décision d'architecture *(si utile)*
- Option retenue + pourquoi · alternatives écartées
- Direction `ddd-lite` et nouvelle zone métier : résultat du test de décision

## Questions
- …

## Notes d'implémentation *(remplie pendant l'implémentation, si besoin)*
- Écart, incident, cause, correctif

## Revue sécurité *(remplie en fin de feature si `securite: requise`)*
- Violations socle : …
- Autres risques : …
- Vérifié (outil ou code cité) / non vérifié : …
