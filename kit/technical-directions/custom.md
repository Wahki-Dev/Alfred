# Direction technique — Custom (base)

> Direction par défaut. C'est la **base** sur laquelle s'appuie `ddd-lite`.
> Principe : contrôleurs/handlers **fins**, logique dans des **services**. Adapter au framework réel.

---

## Quand choisir

- Projet CRUD simple ou majoritairement standard framework
- Prototype ou MVP court
- Besoin métier encore instable
- Peu d'intégrations externes
- Pas de coeur métier complexe identifié

---

## Principes

- Suivre les conventions du framework choisi.
- **Point d'entrée fin** (contrôleur / handler / commande) : il valide, délègue, répond. Aucune règle métier durable dedans.
- **Logique dans un service** (fat service) : le service porte la logique applicative et métier.
- Accès données via l'ORM natif directement. Repository **seulement** si accès complexe, réutilisé ou multi-source.
- Créer les dossiers et abstractions au premier besoin, pas en avance.
- Ne pas introduire DDD, couches hexagonales ou ports/adapters : c'est le rôle de `ddd-lite` sur le métier complexe uniquement.

---

## Base Laravel (norme du projet)

- **Contrôleurs** : Single Action Controller (`__invoke`) pour une action métier isolée ; Resource Controller pour un CRUD administratif ; sous-dossier dédié pour une sous-ressource.
- **Thin controller → fat service** : le contrôleur appelle un service (`app/Services`) ou une Action (`app/Actions`) pour un cas unitaire.
- **Validation** : FormRequest dès qu'elle est non triviale.
- **Données** : Eloquent direct · `enum` PHP pour statuts/types · casts explicites. Repository seulement si justifié.
- Détails et matrice de décision : `agent/stacks/php/decisions.md`.

*(Pour une autre stack : garder le principe « entrée fine → service » et l'adapter aux conventions natives.)*

---

## Structure type

La structure exacte dépend de la stack.
`agent-project/architecture.md` doit décrire les dossiers réels ou retenus.

Exemples de zones à documenter :
- Entrées : routes, contrôleurs, handlers, commandes
- Logique applicative : services, actions (use cases si nécessaires)
- Données : modèles, ORM, repositories si déjà justifiés
- Intégrations : clients externes, adapters simples
- Tests : unitaires, intégration, bout-en-bout si pertinents

---

## Règles vérifiables

- Point d'entrée fin : pas de règle métier durable dans un contrôleur / handler.
- Pas de duplication de logique métier entre entrées.
- Pas de service générique fourre-tout.
- Pas de repository ajouté sans complexité d'accès données ou multi-source.
- Pas de structure vide créée "au cas où".
- Toute abstraction doit avoir au moins deux usages ou une raison métier claire.

---

## Sortie attendue dans architecture.md

- Direction technique : `custom`
- Structure retenue
- Responsabilités par dossier
- Patterns utilisés uniquement s'ils sont justifiés
- Anti-patterns à éviter
- Checklist d'audit adaptée au projet
