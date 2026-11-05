# Template — Génération de agent-project/roadmap.md

> Ce fichier explique à l'IA COMMENT générer `agent-project/roadmap.md` pour un nouveau projet.

---

## Processus de création

### Étape 1 — Collecter la vision produit

Lire, si disponibles :
- `agent-project/cdc.md`
- `agent-project/memory.md`
- `agent-project/plans/`

Si le projet est vierge, demander les objectifs de lancement et les priorités.

### Étape 2 — Structurer la roadmap

Organiser les travaux en jalons simples.
Chaque tâche doit avoir un statut explicite.
Ne pas détailler l'implémentation technique : les plans de feature portent ce niveau de détail.

### Étape 3 — Proposer avant écriture

Présenter le draft complet et attendre validation avant de créer ou modifier `agent-project/roadmap.md`.

---

## Statuts autorisés

- `à_faire` : tâche identifiée, non commencée
- `en_cours` : tâche active ou reliée à un plan en cours
- `terminé` : tâche livrée et validée
- `bloqué` : tâche impossible à poursuivre sans décision ou dépendance externe
- `abandonné` : tâche sortie du périmètre

---

## Structure de agent-project/roadmap.md

```markdown
# Roadmap — [Nom du projet]

> Dernière mise à jour : [date]
> Source produit : `agent-project/cdc.md` si disponible

## Changelog
- [date] : Création initiale

## Objectifs de roadmap
- [Objectif produit ou jalon]

## Statuts
- `à_faire` : tâche identifiée, non commencée
- `en_cours` : tâche active ou reliée à un plan en cours
- `terminé` : tâche livrée et validée
- `bloqué` : tâche impossible à poursuivre sans décision ou dépendance externe
- `abandonné` : tâche sortie du périmètre

## Tâches

| ID | Tâche | Statut | Priorité | Plan lié | Dernière mise à jour |
|---|---|---|---|---|---|
| RD-001 | [Titre court] | à_faire | haute | — | [date] |

## Jalons

### [Jalon]
- Objectif :
- Tâches liées :
- Critères de fin :

## Risques / dépendances
- [Risque ou dépendance externe]

## Questions ouvertes
- [Question à trancher]
```

---

## Règles de maintenance de roadmap.md

- Toute tâche doit avoir un statut autorisé.
- Toute tâche terminée doit avoir une date de mise à jour récente.
- Lier une tâche à un plan quand un fichier `agent-project/plans/...` existe.
- Ne pas dupliquer le détail des plans de feature.
- Mettre à jour le statut d'une tâche roadmap quand la tâche de workflow correspondante est terminée.
- Proposer la mise à jour et attendre validation avant écriture.
