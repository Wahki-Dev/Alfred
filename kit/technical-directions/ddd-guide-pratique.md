# Guide pratique — DDD Lite au quotidien

> **Pour qui ?** L'IA **et** le développeur humain. À rouvrir chaque fois qu'on se demande :
> « Cette feature, je la fais en DDD ou en contrôleur classique ? », « J'ai mon use case, et maintenant ? »,
> « Ce bout de code, il va dans le Domaine ou l'Application ? ».
>
> Ce fichier = **décision + process + exemples**. Les règles détaillées d'audit sont dans
> `ddd-light-hexagonal-guide.md`. La direction elle-même est dans `ddd-lite.md`.

---

## 0) Le principe en une phrase

**Par défaut on code classique** (thin controller → fat service → Eloquent).
On ne passe en DDD **que** la zone qui porte du **vrai métier complexe**. Le reste reste simple.

---

## 1) DDD ou contrôleur classique ? (le test)

Pose-toi ces 4 questions sur la feature :

1. Y a-t-il des **règles métier non triviales** (calculs, seuils, décisions, états) ?
2. Y a-t-il des **invariants** à protéger (« un X ne peut jamais être dans l'état Y si… ») ?
3. Ai-je besoin de **tester ce métier sans lancer Laravel/la BDD** ?
4. Est-ce un cœur qui va **durer et évoluer** (pas un écran jetable) ?

- **0 à 1 « oui »** → **classique** (`custom`). Thin controller → service → Eloquent. Stop.
- **2 « oui » ou plus** → **DDD Lite** sur cette zone uniquement.

### Exemples de tri

| Feature | Verdict | Pourquoi |
|---|---|---|
| CRUD utilisateurs, rôles, paramètres | Classique | Pas de métier, juste de la persistance |
| Import d'un fichier + affichage liste | Classique | Pas d'invariant durable |
| **Analyse des données de traite** (détection anomalies, calculs de rendement, seuils sanitaires) | **DDD Lite** | Règles métier + invariants + testable hors framework |

> Règle anti-sur-ingénierie : dans le doute, commence en **classique**. On extrait vers le DDD quand le métier se densifie, pas « au cas où ».

---

## 2) Le process DDD (une fois qu'on a décidé DDD)

**On part TOUJOURS du use case** (une intention métier = un use case).

### Étape 1 — Nommer le use case

Un verbe métier + un objet métier. Pas de terme technique.
> `AnalyserTraiteJournaliere`, `ValiderLotDeLait`, `CalculerRendementTroupeau`.

### Étape 2 — Définir l'entrée et la sortie

- **Entrée** : une Command / DTO avec des primitives ou value objects. Jamais une `Request` HTTP.
- **Sortie** : un résultat / DTO de lecture. **Jamais un modèle Eloquent.**

```php
final class AnalyserTraiteJournaliere
{
    public function __invoke(AnalyserTraiteCommand $cmd): RapportAnalyse { /* ... */ }
}
```

### Étape 3 — Faire parler le métier → Domaine

Repère le vocabulaire et les règles. Ça devient des **entités** (identité + comportement) et des **value objects** (valeurs immuables et validées).

```php
final class VolumeLait            // value object
{
    public function __construct(public readonly float $litres)
    {
        if ($litres < 0) throw new VolumeInvalide(); // invariant protégé ici
    }
}
```

Le Domaine **ne connaît pas** Laravel, Eloquent, HTTP. Il ne contient que du métier pur.

### Étape 4 — Identifier les besoins externes → Ports

Le use case a besoin de lire/écrire/appeler quelque chose ? On déclare un **port** (une interface), on n'appelle pas la techno directement.

```php
interface TraiteRepository        // port, côté Application/Domaine
{
    public function duJour(DateTraite $jour): CollectionDeTraites;
}
```

### Étape 5 — Brancher la technique → Infrastructure (adapters)

L'adapter **implémente** le port avec Eloquent, une API, etc. C'est le seul endroit qui touche la persistance.

```php
final class EloquentTraiteRepository implements TraiteRepository
{
    public function duJour(DateTraite $jour): CollectionDeTraites { /* Eloquent ici */ }
}
```

### Étape 6 — Le contrôleur reste fin

Le Single Action Controller valide, appelle le use case, renvoie une réponse. Rien de métier.

```php
final class AnalyserTraiteController
{
    public function __invoke(AnalyserTraiteRequest $r, AnalyserTraiteJournaliere $uc)
    {
        return response()->json($uc(AnalyserTraiteCommand::fromRequest($r)));
    }
}
```

### Étape 7 — Tests par couche

- **Domaine** : tests unitaires purs (pas de BDD, pas de Laravel).
- **Application** : use case avec des **fakes** des ports.
- **Infrastructure** : tests d'intégration (vraie BDD).

---

## 3) Qu'est-ce qui va où ? (antisèche)

| Couche | Ce qui va dedans | Ce qui n'y va JAMAIS |
|---|---|---|
| **Interface** (contrôleur, commande CLI, job) | Validation de format, appel du use case, réponse | Règle métier durable |
| **Application** (use case / service applicatif) | Orchestration, transaction, appel des ports | Eloquent direct, HTTP, règle métier qui appartient au domaine |
| **Domaine** (entités, value objects, services de domaine) | Règles métier, invariants, calculs, vocabulaire métier | Laravel, Eloquent, `now()`, HTTP, `DB::` |
| **Infrastructure** (adapters) | Implémentation des ports : Eloquent, API, mail, horloge | Règle métier |

**Réflexe de direction des dépendances** : Interface → Application → Domaine. L'Infrastructure implémente les ports (pointe vers l'intérieur). Le Domaine ne dépend de personne.

---

## 4) Réflexes rapides (FAQ)

- **« J'ai créé un contrôleur, où mettre la logique ? »** → Dans le use case (Application) s'il orchestre ; dans le Domaine si c'est une règle métier. Jamais dans le contrôleur.
- **« Puis-je appeler Eloquent dans le Domaine ? »** → Non. Passe par un port implémenté en Infrastructure.
- **« Mon use case peut-il retourner un modèle Eloquent ? »** → Non. Retourne un DTO / value object.
- **« Où mettre un `now()` / une date ? »** → Injecte une horloge (port `Clock`). Le Domaine ne lit pas l'heure globale.
- **« Une règle est-elle du Domaine ou de l'Application ? »** → Si elle est vraie « en soi » (invariant du métier) → Domaine. Si elle coordonne plusieurs choses (transaction, permissions, orchestration) → Application.
- **« Je ne sais pas si c'est assez complexe pour du DDD. »** → Refais le test §1. Dans le doute : classique.

---

## 5) Le fil rouge en 30 secondes

Feature « analyser la traite du jour » :
`Contrôleur fin` → `use case AnalyserTraiteJournaliere` → lit les traites via `TraiteRepository` (port) → applique les règles sur `Traite` / `VolumeLait` (Domaine) → renvoie `RapportAnalyse` (DTO).
L'accès BDD vit dans `EloquentTraiteRepository` (Infrastructure). Le CRUD des utilisateurs, lui, reste en **classique**.

---

## Voir aussi

- `ddd-lite.md` — la direction technique (quoi/quand, périmètre).
- `ddd-light-hexagonal-guide.md` — les règles détaillées et la checklist d'audit.
- `../stacks/php/decisions.md` — les défauts Laravel de la base `custom`.
