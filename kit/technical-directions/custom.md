# Direction technique — Custom (base)

> Direction par défaut, et base de `ddd-lite`. Lue à l'`init` et à l'audit.
> Une équipe peut désactiver, changer la sévérité ou la portée d'une règle dans `agent-project/rules.md`.
> Mécanismes propres au framework : `agent/stacks/php/decisions.md` (choix) et `agent/stacks/php/<framework>.md` (règles).

## Quand choisir
- Projet CRUD ou majoritairement standard framework
- Prototype, MVP, ou besoin métier encore instable
- Pas de coeur métier complexe identifié (sinon : `ddd-lite`, sur cette zone seulement)

## Principes
- Suivre les conventions du framework choisi.
- **Point d'entrée fin** (contrôleur, handler, commande, job) : valide, délègue, répond.
- **Logique dans un service** (ou une action pour un cas unitaire).
- ORM natif en direct ; repository seulement si l'accès est complexe, réutilisé ou multi-source.
- Dossiers et abstractions créés au premier besoin, pas en avance.

## Règles
- **CUS-01** · MOYEN — Pas de service fourre-tout (`Manager`, `Helper`, `Utils` génériques) : un service = une responsabilité nommée
- **CUS-02** · MOYEN — Pas de repository sans accès complexe, réutilisé ou multi-source ; sinon ORM direct
- **CUS-03** · MINEUR — Pas de dossier ni de structure vide créés « au cas où »
- **CUS-04** · MOYEN — Toute abstraction (interface, classe de base, couche) a au moins deux usages ou une raison métier claire
- **CUS-05** · MOYEN — Pas de couches DDD (Domain / Application / ports) hors d'une zone `ddd-lite` documentée

## Sortie attendue dans `agent-project/architecture.md`
Descriptif uniquement : direction `custom`, structure réelle ou retenue, responsabilités par
dossier, patterns utilisés (s'ils sont justifiés). Les règles restent dans le kit ; les règles
propres au projet vont dans `agent-project/rules.md`.
