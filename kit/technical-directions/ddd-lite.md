# Direction technique — DDD Lite (hybride)

> Direction **hybride**, pas du full DDD. Base `custom` partout **par défaut**,
> DDD (Application → Domaine → Infrastructure) appliqué **uniquement** sur le coeur métier complexe identifié.

---

## Principe central

- **Par défaut = `custom`** (voir `agent/technical-directions/custom.md`) : thin controller → fat service, Eloquent direct.
  - CRUD et zones sans métier complexe (ex : utilisateurs, rôles, paramètres, référentiels) → restent en `custom`. On n'y met **jamais** de couches DDD.
- **DDD ciblé sur le métier complexe uniquement** : la (ou les) zone(s) à règles métier non triviales passent en Application → Domaine → Infrastructure.
- **Règle d'or** : ne pas généraliser le DDD. S'il n'y a pas de valeur métier claire, on reste en `custom`.

---

## Quand appliquer le DDD sur une zone (et pas ailleurs)

Appliquer le DDD **seulement** si la zone présente :
- des règles métier durables et non triviales ;
- des invariants à protéger ;
- un besoin de tester le métier hors framework.

Sinon → `custom`.

---

## Structure hybride cible

- **Zones simples / CRUD** : structure `custom` standard framework (contrôleur → service → ORM).
- **Zone métier complexe** :
  - `Application/` : use cases / services applicatifs, orchestration, ports.
  - `Domain/` : entités riches, value objects, invariants — **pur**, sans framework ni ORM.
  - `Infrastructure/` : adapters, persistance, clients externes (implémentent les ports).
- Créer les couches **au premier besoin**, uniquement pour la zone concernée.

---

## Détail d'implémentation de la partie DDD

- **Guide pratique** (décider + découper, avec exemples) : `agent/technical-directions/ddd-guide-pratique.md`.
- **Règles détaillées + audit** : `agent/technical-directions/ddd-light-hexagonal-guide.md`
  (dépendances dirigées vers l'intérieur, ports/adapters, repositories DDD, tests du domaine, etc.).

Ces deux fichiers **ne s'appliquent qu'à la zone métier complexe**, jamais au reste du code.

---

## Règles vérifiables

- Une zone CRUD/simple qui contient des couches DDD (Domain/Application/ports) = sur-ingénierie → violation.
- Domaine (zone complexe) ne dépend pas du framework, de l'ORM ou du transport.
- Use case (zone complexe) ne retourne pas de modèle de persistance.
- Contrôleurs fins partout (base `custom`) : aucune règle métier durable dans un contrôleur.
- Le périmètre exact de la zone DDD est documenté dans `architecture.md`.

---

## Sortie attendue dans architecture.md

- Direction technique : `ddd-lite`
- **Périmètre DDD** : quelle(s) zone(s) métier passe(nt) en DDD, et lesquelles restent en `custom`
- Couches retenues et chemins adaptés à la stack (pour la zone DDD)
- Règles de dépendances (zone DDD)
- Ports / adapters utiles uniquement au premier besoin
- Checklist d'audit architecture (distinguer zone `custom` et zone DDD)
