# Template — Génération de agent-project/architecture.md

> Ce fichier explique à l'IA COMMENT générer `agent-project/architecture.md`.
> `architecture.md` est le fichier détaillé de direction technique. Le routing est dans `AGENT.md §2` ; `memory.md` reste la mémoire projet.

---

## Processus de création

### Étape 0 — Détecter le type de projet

- **Projet existant** : analyser l'architecture réelle et produire un document fidèle à l'existant.
- **Projet vierge** : proposer une direction technique, puis rédiger depuis le choix validé.

### Étape 1 — Projet existant

Explorer :
- Structure des dossiers et responsabilités réelles
- Framework / runtime / conventions de chargement
- Flux d'entrée (routes, contrôleurs, handlers, CLI, jobs)
- Logique métier (services, actions, use cases, modèles, domaine)
- Persistance (ORM, repositories, queries, migrations)
- Intégrations externes
- Tests par niveau
- Anti-patterns déjà présents

Rédiger `architecture.md` à partir de ce qui existe réellement.
Ne pas imposer DDD, hexagonal ou une nouvelle structure si le projet ne l'applique pas déjà.
Signaler les écarts et recommandations dans une section séparée.

### Étape 2 — Projet vierge

Proposer une direction technique :
- `custom` : base — contrôleurs fins → services, adaptée au framework et au besoin
- `ddd-lite` : hybride — base `custom` partout + DDD (Application → Domaine → Infrastructure) ciblé **uniquement** sur le coeur métier complexe

Utiliser `agent/technical-directions/<direction>.md` pour rédiger le draft.
Ne jamais proposer du full DDD par défaut : `ddd-lite` reste hybride et documente le périmètre DDD.
Si une direction n'est pas validée explicitement, rester sur `custom`.

### Étape 3 — Proposer et valider

Présenter le draft.
Attendre validation avant d'écrire `agent-project/architecture.md`.
Après validation, mettre ou proposer une référence courte dans `agent-project/memory.md`.

---

## Structure de agent-project/architecture.md

```markdown
# Architecture — [Nom du projet]

> Direction technique : [custom | ddd-lite | autre]
> Projet : [existant | vierge]
> Dernière mise à jour : [date]

## Changelog
- [date] : Création initiale

## Résumé
[Résumé court de l'architecture et de l'intention technique]

## Direction technique
- Choix retenu :
- Pourquoi :
- Alternatives rejetées :
- Limites / zones où ne pas appliquer :

## Structure des dossiers
- `[chemin]` : [responsabilité]

## Responsabilités par couche / zone

### Entrées
[HTTP, CLI, jobs, events, consumers, UI actions, etc.]

### Application / orchestration
[Services, actions, use cases, handlers applicatifs]

### Domaine / métier
[Modèles métier, règles, invariants, value objects si applicable]

### Infrastructure
[Persistance, clients externes, fichiers, mail, logs, adapters]

## Dépendances entre couches
- [Qui dépend de qui, tel que le projet le fait]
- Direction `ddd-lite` : périmètre exact de la zone DDD (dossiers), le reste est en `custom`

## Patterns retenus
- [Pattern] : [quand l'utiliser]

## Patterns à éviter
- [Anti-pattern observé] : [pourquoi] — à imposer ? le proposer comme règle `PRJ-NN` dans `agent-project/rules.md`

## Persistance et transactions
- [Règles ORM / repositories / queries]
- [Frontières transactionnelles]

## Validation et erreurs
- [Validation d'entrée]
- [Invariants métier]
- [Exceptions / erreurs attendues]

## Tests par niveau
- [Niveau] : [objectif + emplacement]

## Recommandations / dette connue
- [Écart observé ou amélioration proposée]
```

---

## Règles de maintenance de architecture.md

- Fichier **descriptif** : il dit ce qui existe et ce qui est retenu. Les règles vérifiées à l'audit sont
  celles de la direction dans le kit (`agent/technical-directions/`) et celles de `agent-project/rules.md` :
  ne pas les recopier ici.
- Détailler l'architecture ici, pas dans `memory.md` (qui n'en garde qu'un résumé)
- Mettre à jour quand une décision structurante change (proposition + validation)
- Ne jamais documenter une architecture cible comme déjà existante
