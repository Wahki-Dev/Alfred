# Template — Génération de agent-project/knowledge.md

> Ce fichier explique à l'IA COMMENT générer `agent-project/knowledge.md` pour un nouveau projet.

---

## Quand créer ce fichier

Uniquement si le projet utilise un outil de documentation externe collaboratif (Notion, Confluence, Coda, etc.).
Si le projet n'a pas de documentation externe, ce fichier n'est pas nécessaire.

---

## Structure de agent-project/knowledge.md

```markdown
# Règles Documentation — [Nom du projet]

> Outil : [ex: Notion, Confluence, Coda]
> Workspace : [URL ou nom]
> Dernière mise à jour : [date]

## Principes généraux
- [Règle 1 : ex: Toujours mettre à jour la doc après une modification majeure]
- [Règle 2 : ex: Chaque feature documentée doit avoir une date]

## Structure de la documentation
[Décrire l'organisation des pages/espaces]
- [Section 1] : [rôle]
- [Section 2] : [rôle]

## Règles de mise à jour

### Quoi documenter
- [ex: Toute décision d'architecture]
- [ex: Tout changement de convention]
- [ex: Tout audit de sécurité]

### Quoi ne pas documenter
- [ex: Le code lui-même (c'est le rôle des commentaires)]
- [ex: Les bugs résolus (c'est le rôle du changelog)]

### Format attendu
[Décrire le format des pages de documentation]

## Interdictions
- JAMAIS modifier la documentation sans validation de l'utilisateur
- [Interdiction spécifique]

## Accès MCP (si configuré)
- Serveur : [nom du serveur MCP]
- Opérations autorisées : [liste]
- Opérations interdites : [liste]
```

---

## Règles de maintenance
- Taille cible : ≤ 100 lignes
- Mettre à jour si l'outil de documentation change
- Si aucun outil de documentation externe : supprimer ce fichier et le retirer du routing dans `AGENT.md`
