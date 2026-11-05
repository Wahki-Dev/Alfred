# Guide d'inspiration — DDD léger + architecture hexagonale

> Annexe détaillée de la direction `ddd-lite` (`agent/technical-directions/ddd-lite.md`).
> **Périmètre : à appliquer UNIQUEMENT sur la (ou les) zone(s) métier complexe(s) identifiée(s), jamais sur l'ensemble du code.**
> Le reste (CRUD, zones simples) reste en `custom`.
> Source portable pour générer `agent-project/architecture.md`. Ne pas appliquer automatiquement.

---

## 0) Quand appliquer ces règles à une zone

Réserver DDD léger + architecture hexagonale aux **zones métier complexes** qui contiennent ou prévoient :
- un coeur métier durable ;
- des règles métier non triviales ;
- plusieurs interfaces d'entrée (HTTP, CLI, jobs, messages, API publique) ;
- plusieurs dépendances externes ou sources de données ;
- un besoin fort de testabilité hors framework.

Ne pas proposer cette direction par défaut pour :
- CRUD administratif simple ;
- prototype court ;
- projet essentiellement UI ou intégration légère ;
- besoin sans logique métier stable.

---

## 1) Principes

1. **Domaine souverain**
   - Le domaine exprime le métier et reste indépendant du framework, de l'ORM, du transport et de l'infrastructure.
2. **Dépendances dirigées vers l'intérieur**
   - Interfaces d'entrée -> Application -> Domain.
   - Infrastructure -> ports exposés par Application ou Domain.
3. **DDD léger**
   - Langage métier, entités riches, value objects, invariants, use cases.
   - Pas de CQRS, Event Sourcing ou bus de messages par défaut.
4. **Pragmatisme**
   - Le DDD s'applique surtout au coeur métier.
   - Les zones CRUD simples peuvent garder l'architecture standard du framework.

---

## 2) Structure cible générique

Adapter les chemins au langage et au framework du projet.

- `Domain/` : modèle métier pur.
- `Application/` : cas d'usage, orchestration, ports applicatifs.
- `Infrastructure/` : adapters sortants, persistance, clients externes, horloge système.
- `Interfaces/` : adapters entrants, contrôleurs, handlers, commandes CLI, consumers.
- `Bootstrap/` ou configuration framework : wiring ports -> adapters.

Variantes acceptables :
- conserver les dossiers standards du framework si `architecture.md` documente clairement où placer chaque responsabilité ;
- créer les dossiers au premier besoin, pas en avance.

---

## 3) Règles de dépendances

### Domain

Le domaine ne dépend pas :
- du framework ;
- de l'ORM ou de la base de données ;
- du transport HTTP / CLI / queue ;
- du système de fichiers, réseau, mail, logs ;
- d'une horloge globale ou fonction de date globale.

Le domaine peut dépendre :
- du langage standard ;
- de types métier ;
- d'interfaces nécessaires à l'expression du métier, si elles restent abstraites.

### Application

L'application :
- dépend du domaine ;
- orchestre les use cases ;
- dépend de ports, pas d'implémentations d'infrastructure ;
- ne contient pas de règles métier durables si elles appartiennent naturellement au domaine.

### Infrastructure

L'infrastructure :
- dépend des couches internes ;
- implémente les ports ;
- contient les mappings persistance <-> domaine ;
- encapsule framework, ORM, SDK externes, réseau, fichiers, mail, logs.

### Interfaces

Les interfaces d'entrée :
- adaptent la requête externe au use case ;
- valident le format et les droits d'accès ;
- ne portent pas la logique métier durable.

---

## 4) Domaine

### Entités

- Identité stable.
- Invariants protégés.
- Méthodes métier nommées avec le langage métier.

Anti-patterns :
- entités réduites à getters/setters ;
- logique métier dans contrôleurs, handlers, jobs ou listeners ;
- état modifiable sans invariant.

### Value Objects

- Immuables.
- Validés à la construction.
- Comparables par valeur.
- Sans dépendance framework.

Exemples génériques : `Money`, `Email`, `Percentage`, `DateRange`, `Quantity`.

### Services de domaine

À créer seulement si la logique n'a pas de propriétaire naturel dans une entité ou un value object.
Éviter les services fourre-tout.

### Langage omniprésent

- Noms alignés sur le métier.
- Éviter `Manager`, `Helper`, `Utils`, `Processor` sans responsabilité précise.

---

## 5) Application / Use Cases

- 1 use case = 1 intention métier.
- Entrées simples : commande, DTO ou primitives.
- Sorties simples : résultat, DTO de lecture, identifiant ou statut.
- Ne jamais exposer un modèle de persistance comme résultat de use case.
- Les transactions, permissions applicatives et publications d'événements se coordonnent ici si nécessaire.

Audit :
- un use case qui retourne un objet ORM ou un type infrastructure est une violation ;
- une dépendance directe vers une implémentation infrastructure est une violation ;
- une logique métier complexe dans Application doit être évaluée pour migration vers Domain.

---

## 6) Ports & Adapters

### Ports

Un port exprime un besoin interne, pas une technologie.

Exemples :
- `OrderRepository`
- `PaymentGateway`
- `Clock`
- `TransactionManager`
- `NotificationSender`

Le port vit côté intérieur :
- dans Domain si le domaine en a besoin ;
- dans Application si le besoin est applicatif.

### Adapters

Un adapter implémente un port avec une technologie concrète :
- persistance ;
- API externe ;
- système de fichiers ;
- horloge système ;
- envoi email / notification.

Règle :
- le mapping entre objet domaine et représentation technique appartient à Infrastructure.

---

## 7) Repositories DDD

Un repository DDD :
- parle le langage du domaine ;
- renvoie des objets domaine ou des résultats applicatifs validés ;
- masque la persistance ;
- ne fuit pas de query builder, modèle ORM, document brut ou collection technique.

Un repository technique du framework n'est pas automatiquement un repository DDD.

Audit :
- signatures de ports avec types de persistance = violation ;
- mapping domaine <-> persistance absent ou dispersé = suspect ;
- requêtes métier répétées hors adapter = suspect.

---

## 8) Wiring

Le wiring relie ports et adapters dans la zone prévue par le framework ou le bootstrap.

Règles :
- Application et Domain ne créent pas directement les adapters ;
- les bindings sont centralisés ou facilement traçables ;
- le remplacement par fake/mock doit rester simple en test.

Audit :
- `new` d'un adapter concret dans Domain ou Application = violation ;
- binding introuvable pour un port utilisé = violation.

---

## 9) Transactions

- Le domaine ne gère pas les transactions.
- L'application orchestre une unité de travail via un port ou un mécanisme applicatif.
- L'infrastructure implémente le détail technique.

Audit :
- transaction technique dans Domain = violation ;
- transaction dispersée dans plusieurs adapters = suspect ;
- absence de frontière transactionnelle sur un use case critique = suspect.

---

## 10) Temps et dates

- Le domaine ne lit pas l'heure globale directement.
- Injecter une date, une horloge abstraite ou un service de temps.
- Les types de dates doivent être explicites et immuables quand le langage le permet.

Audit :
- appel direct à une horloge globale dans Domain = violation ;
- logique temporelle non testable = suspect.

---

## 11) Validation

- Interface : validation de format, présence, types d'entrée.
- Application : cohérence du cas d'usage, permissions applicatives.
- Domain : invariants métier et états impossibles.

Audit :
- règle métier majeure uniquement dans la validation d'entrée = suspect ;
- invariant absent du domaine = suspect ;
- validation dupliquée dans plusieurs interfaces = suspect.

---

## 12) Tests

- Domain : tests unitaires rapides, sans framework, sans DB.
- Application : tests de use cases avec fakes/mocks des ports.
- Infrastructure : tests d'intégration avec DB, réseau ou SDK si nécessaire.
- Interfaces : tests de routing, validation et autorisations.

Audit :
- test Domain qui démarre le framework = violation ;
- test Application nécessitant une DB sans justification = suspect ;
- absence de test sur invariant critique = suspect.

---

## 13) Red flags

- Classe service trop large qui mélange DB, métier, API externe et notification.
- Domaine dépendant du framework, de l'ORM ou du transport.
- Use case retournant un modèle de persistance.
- Contrôleur ou handler qui calcule des règles métier durables.
- Ports nommés d'après une technologie plutôt qu'un besoin métier.
- Helpers ou utils contenant de la logique métier.

---

## 14) Checklist d'audit

1. Vérifier l'arborescence et la responsabilité des dossiers.
2. Scanner Domain :
   - dépendances framework / ORM / infrastructure ;
   - invariants absents ;
   - entités anémiques.
3. Vérifier Application :
   - dépendances vers Infrastructure ;
   - use cases trop larges ;
   - retours de types techniques.
4. Vérifier ports :
   - interfaces côté intérieur ;
   - noms exprimant un besoin métier ;
   - signatures sans fuite technique.
5. Vérifier adapters :
   - mapping domaine <-> technique centralisé ;
   - dépendances externes isolées.
6. Vérifier wiring :
   - ports liés aux adapters ;
   - pas de création directe d'adapters dans les couches internes.
7. Vérifier tests :
   - Domain sans framework ;
   - Application avec fakes ;
   - Infrastructure en intégration.

---

## 15) Conventions minimales

- Créer les couches au premier besoin.
- Nommer par intention métier.
- Préférer types immuables pour les value objects.
- Créer des exceptions métier dédiées quand elles clarifient l'invariant.
- Garder le détail technique dans `agent-project/architecture.md`, pas dans `memory.md`.
