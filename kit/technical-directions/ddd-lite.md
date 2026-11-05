# Direction technique — DDD Lite (hybride)

> Direction **hybride**, pas du full DDD : base `custom` partout (`agent/technical-directions/custom.md`),
> DDD (Application → Domaine → Infrastructure) **uniquement** sur la ou les zones métier complexes.
> Lue à l'`init` et à l'audit, et par le plan d'une feature qui crée une nouvelle zone métier.
> Une équipe peut désactiver, changer la sévérité ou la portée d'une règle dans `agent-project/rules.md`.

---

## 1) DDD ou classique ? (test unique)

Sur la zone ou la feature concernée :

1. Y a-t-il des **règles métier non triviales** (calculs, seuils, décisions, états) ?
2. Y a-t-il des **invariants** à protéger (« un X ne peut jamais être dans l'état Y si… ») ?
3. Faut-il **tester ce métier sans lancer le framework ni la base** ?
4. Est-ce un coeur qui va **durer et évoluer** (pas un écran jetable) ?

- **0 ou 1 « oui »** → classique (`custom`).
- **2 « oui » ou plus** → DDD Lite **sur cette zone uniquement**.
- **Dans le doute** → classique. On extrait vers le DDD quand le métier se densifie.

| Feature | Verdict | Pourquoi |
|---|---|---|
| CRUD utilisateurs, rôles, paramètres | Classique | Pas de métier, juste de la persistance |
| Import d'un fichier + affichage liste | Classique | Pas d'invariant durable |
| Analyse de la traite (anomalies, rendement, seuils sanitaires) | DDD Lite | Règles + invariants + testable hors framework |

Si la direction du projet est `ddd-lite`, le plan d'une feature qui crée une nouvelle zone métier
applique ce test et note le verdict.

---

## 2) Structure hybride

- **Zones simples / CRUD** : structure `custom` (contrôleur fin → service → ORM).
- **Zone complexe** (couches créées au premier besoin, pour cette zone seulement) :
  - `Domain/` : entités, value objects, invariants. **Pur** : ni framework, ni ORM, ni horloge globale.
  - `Application/` : use cases, orchestration, transactions, ports.
  - `Infrastructure/` : adapters qui implémentent les ports (ORM, API, mail, horloge).
  - Entrées (contrôleur, CLI, job) : restent fines, appellent le use case.
- **Wiring** : bindings port → adapter centralisés (ex : service provider Laravel).

---

## 3) Process (une fois le DDD décidé)

1. **Nommer le use case** : verbe + objet métier, sans terme technique (`AnalyserTraiteJournaliere`).
2. **Entrée / sortie** : Command ou DTO en entrée (jamais une `Request`), DTO en sortie (jamais un modèle ORM).
3. **Domaine** : le vocabulaire devient entités (identité + comportement) et value objects (immuables, validés).
4. **Ports** : chaque besoin externe devient une interface nommée par le besoin, pas par la techno.
5. **Adapters** : l'Infrastructure implémente les ports ; seul endroit qui touche la persistance.
6. **Contrôleur fin** : valide, appelle le use case, répond.
7. **Tests par couche** : Domaine sans framework ni base ; Application avec des fakes des ports ; Infrastructure en intégration.

```php
final class VolumeLait                          // value object (Domain)
{
    public function __construct(public readonly float $litres)
    {
        if ($litres < 0) throw new VolumeInvalide();   // invariant protégé ici
    }
}

interface TraiteRepository                      // port (Application/Domain)
{
    public function duJour(DateTraite $jour): CollectionDeTraites;
}

final class AnalyserTraiteJournaliere           // use case (Application)
{
    public function __construct(private TraiteRepository $traites, private Clock $clock) {}

    public function __invoke(AnalyserTraiteCommand $cmd): RapportAnalyse { /* ... */ }
}

final class EloquentTraiteRepository implements TraiteRepository   // adapter (Infrastructure)
{
    public function duJour(DateTraite $jour): CollectionDeTraites { /* Eloquent ici */ }
}
```

Fil rouge : contrôleur fin → `AnalyserTraiteJournaliere` → lit via `TraiteRepository` → règles sur
`Traite` / `VolumeLait` → renvoie `RapportAnalyse`. Le CRUD des utilisateurs reste classique.

---

## 4) Qu'est-ce qui va où ?

| Couche | Contient | N'y met JAMAIS |
|---|---|---|
| Entrée (contrôleur, CLI, job) | Validation de format, appel du use case, réponse | Règle métier durable |
| Application (use case) | Orchestration, transaction, permissions applicatives, appel des ports | ORM direct, HTTP, règle qui appartient au domaine |
| Domaine | Règles, invariants, calculs, vocabulaire métier | Framework, ORM, `now()`, HTTP, `DB::` |
| Infrastructure (adapters) | Implémentation des ports, mapping domaine ↔ persistance | Règle métier |

Une règle vraie « en soi » (invariant) → Domaine. Une règle qui coordonne (transaction,
permission, enchaînement) → Application. Le Domaine ne dépend de personne.

---

## 5) Règles

Périmètre : la zone DDD documentée dans `agent-project/architecture.md` (sauf DDD-01 et DDD-02).

- **DDD-01** · MOYEN — Couches DDD (Domain / Application / ports) dans une zone CRUD ou simple : sur-ingénierie
- **DDD-02** · MOYEN — Périmètre DDD exact (zones concernées) documenté dans `architecture.md`
- **DDD-03** · CRITIQUE — Le Domaine ne dépend ni du framework, ni de l'ORM, ni du transport, ni des fichiers, réseau, mail ou logs
- **DDD-04** · CRITIQUE — Un use case ne retourne jamais un modèle de persistance ni un type d'infrastructure
- **DDD-05** · CRITIQUE — Application et Domaine dépendent de ports, jamais d'une implémentation d'infrastructure
- **DDD-06** · MOYEN — Pas de `new` d'un adapter concret dans Domain ou Application : passer par le wiring
- **DDD-07** · CRITIQUE — Tout port utilisé a un binding vers un adapter
- **DDD-08** · MOYEN — Signatures de ports sans type de persistance (query builder, modèle ORM, document brut)
- **DDD-09** · MINEUR — Ports nommés par le besoin métier, pas par la technologie
- **DDD-10** · MOYEN — Pas de transaction technique dans le Domaine ; frontière transactionnelle portée par le use case
- **DDD-11** · MOYEN — Le Domaine ne lit pas l'heure globale : horloge (`Clock`) ou date injectée
- **DDD-12** · MOYEN — Invariant métier protégé dans le Domaine, pas seulement par la validation d'entrée
- **DDD-13** · MINEUR — Value objects immuables et validés à la construction
- **DDD-14** · MINEUR — Entités porteuses de comportement métier (pas seulement getters/setters)
- **DDD-15** · MINEUR — Mapping domaine ↔ persistance centralisé dans l'Infrastructure
- **DDD-16** · MOYEN — Test du Domaine sans démarrer le framework ni la base
- **DDD-17** · MINEUR — Test d'Application avec des fakes des ports ; base de données seulement si justifié

---

## 6) Sortie attendue dans `agent-project/architecture.md`

Descriptif uniquement :
- Direction : `ddd-lite`
- **Périmètre DDD** : zone(s) en DDD, et zones qui restent en `custom`
- Chemins réels des couches pour la zone DDD, emplacement du wiring
- Ports et adapters existants

Les règles restent dans le kit ; les règles propres au projet vont dans `agent-project/rules.md`.
