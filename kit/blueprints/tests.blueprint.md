# Template — Génération de agent-project/tests.md

> Ce fichier explique à l'IA COMMENT générer `agent-project/tests.md` pour un nouveau projet.

---

## Processus de création

Explorer :
- Le framework de test utilisé (`composer.json`, `package.json`, `pyproject.toml`, etc.)
- Les fichiers de test existants pour identifier les conventions
- La configuration de test (`phpunit.xml`, `jest.config.js`, `pytest.ini`, etc.)
- La CI/CD pour comprendre quand les tests tournent

---

## Structure de agent-project/tests.md

```markdown
# Règles de Tests — [Nom du projet]

> Framework : [ex: Pest, Jest, pytest, RSpec]
> Dernière mise à jour : [date]

## Règle fondamentale
NE JAMAIS générer des tests sans demande explicite de l'utilisateur.
Toujours demander : "Souhaitez-vous que je génère des tests pour cette fonctionnalité ?"

## Priorité : tester le métier
Les tests couvrent **en priorité la logique métier** : règles de gestion, calculs, invariants,
décisions, transitions d'état, cas limites et cas d'erreur du domaine.

**On ne teste PAS l'ORM ni le framework** — ça n'a aucun sens :
- Pas de test des relations/CRUD générés par l'ORM (save, find, hasMany…) → déjà testés en amont
- Pas de test des getters/setters triviaux ni du mapping des champs
- Pas de test du routing, de l'injection de dépendances, de la validation native du framework
- Pas de test des bibliothèques tierces (on les suppose fiables)

Exception : tester le métier **au travers** de l'ORM/framework quand la valeur du test est la
règle métier elle-même (ex : un scope qui encode une règle de gestion, une policy d'autorisation).

## Hiérarchie des tests

1. **Tests unitaires** (sans persistance) : logique métier pure, formatage, calculs
2. **Tests unitaires** (avec base de données) : logique métier qui dépend de la persistance (ex : scope portant une règle de gestion, validation complexe métier)
3. **Tests d'intégration** : controllers, routes, middleware, API — vérifier le comportement métier de bout en bout, pas la mécanique du framework

**Règle de performance** : les tests unitaires de logique pure doivent être < [X]ms chacun.
JAMAIS utiliser la base de données pour tester de la logique pure.

## Conventions de nommage
- Fichiers : [convention ex: UserTest.php, test_user.py, user.test.ts]
- Méthodes/fonctions : [convention ex: test_it_does_something, itDoesX]
- Descriptions : [convention]

## Emplacement des fichiers
- Tests unitaires : [ex: tests/Unit/]
- Tests d'intégration : [ex: tests/Feature/]
- Fixtures/Factories : [ex: tests/Factories/]

## Règles par type

### Tests unitaires
- [ex: Utiliser des objets créés en mémoire pour la logique pure]
- [ex: Jamais de factories pour des tests de méthodes simples]
- [ex: Toujours mocker les dépendances externes]

### Tests d'intégration
- [ex: Tester via les routes HTTP]
- [ex: Utiliser des transactions pour isoler les tests]

### Tests de sécurité
- [ex: Tester les accès non autorisés]
- [ex: Vérifier que les données d'un utilisateur ne sont pas accessibles à un autre]

## Commandes
- Tous les tests : [commande]
- Un fichier : [commande]
- Un test spécifique : [commande]
- Avec couverture : [commande]

## Interdictions
- JAMAIS utiliser la DB pour tester de la logique métier pure
- JAMAIS générer des tests sans demande explicite
- JAMAIS tester l'ORM (relations, CRUD, mapping) ni le framework (routing, DI, validation native)
- JAMAIS tester les getters/setters triviaux ni les bibliothèques tierces
- [Interdiction spécifique projet]
```

---

## Règles de maintenance
- Taille cible : ≤ 150 lignes
- Mettre à jour si le framework de test change
- Ne pas dupliquer les règles générales de `memory.md`
