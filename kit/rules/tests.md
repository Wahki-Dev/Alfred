# Tests — Politique unique du kit

> Lu pendant le plan, l'implémentation et l'audit. Identique pour tous les projets ; une équipe l'adapte
> dans `agent-project/rules.md` (ex : désactiver TEST-03 si elle teste aussi l'ORM).
> Ce qui est propre au projet (framework, dossiers, commande de test) est dans `agent-project/memory.md`.

---

## Principe

On teste **le métier** : règles de gestion, calculs, décisions, transitions d'état, cas limites et erreurs
du domaine. Les tests sont prévus **par défaut** dans le plan (« Vérification ») et lancés par l'agent.
L'utilisateur peut répondre « OK sans tests » : le plan passe `tests: non` et l'audit ne signale pas
l'absence de test pour ce plan.

## Règles

- **TEST-01** · CRITIQUE — Règle métier, calcul ou décision ajouté ou modifié → au moins un test qui l'exerce.
- **TEST-02** · CRITIQUE — Bug corrigé → test de non-régression qui échoue sans le correctif.
- **TEST-03** · MOYEN — Ne pas tester le framework ni l'ORM : relations, CRUD, mapping, migrations, routing, injection de dépendances, validation native, getters/setters triviaux, bibliothèques tierces. Exception : une règle métier portée par l'ORM ou le framework (scope, policy) se teste.
- **TEST-04** · MOYEN — Logique pure testée sans base de données ni framework démarré.
- **TEST-05** · CRITIQUE — L'agent lance la commande de test déclarée et rapporte le résultat réel ; un test non lancé est signalé « non vérifié ».
- **TEST-06** · MOYEN — Un test vérifie un comportement observable, pas l'implémentation (pas d'assertion sur des appels internes sans raison).
- **TEST-07** · MINEUR — Conventions de nommage et emplacement des tests de `agent-project/memory.md` respectées.

## Hiérarchie

1. Unitaire sans persistance : logique pure, calculs, value objects.
2. Unitaire avec base de test : règle métier qui dépend de la persistance (scope, contrainte).
3. Intégration : endpoint, contrôleur, middleware, autorisations — le comportement métier de bout en bout.

Les tests d'autorisation (accès refusé, données d'un autre utilisateur) font partie des features
`securite: requise`.

## Projet sans framework de test

À l'`init`, proposer d'en installer un (défaut de la stack : `agent/stacks/php/decisions.md`). En attendant,
toute logique non triviale laisse un check runnable minimal (script à base d'assertions), comme le
demande `agent/rules/ponytail.md`.
