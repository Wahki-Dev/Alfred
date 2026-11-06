# Règles projet

> Règles de l'équipe pour CE projet. Prioritaires sur celles du kit (`agent/rules/`, `agent/stacks/`,
> `agent/technical-directions/`). Lu par l'agent à chaque session : ces règles s'appliquent quand il code,
> pas seulement à l'audit.
> Écrit par l'équipe ; l'agent peut proposer une règle, jamais l'écrire sans validation.
> Jamais modifié par une mise à jour du kit.
>
> Les règles marquées `socle` dans le kit (SEC-01 à SEC-08) ne peuvent être ni désactivées ni rétrogradées.

## Ajouts

<!--
Format : - **PRJ-NN** · CRITIQUE|MOYEN|MINEUR — règle
         - Vérification : commande lancée par l'agent (optionnel)
Exemples :
- **PRJ-01** · CRITIQUE — Les montants sont des entiers en centimes, jamais des float.
- **PRJ-02** · MOYEN — Tout appel à une API externe passe par un client dédié (`app/Clients/`) avec timeout.
- **PRJ-03** · MOYEN — Les dates sont stockées en UTC et affichées dans le fuseau de l'utilisateur.
-->

## Désactivations

<!--
Format : - **ID** (rappel de la règle) — raison — AAAA-MM-JJ
Exemple :
- **LAR-05** (FormRequest) — on valide les entrées avec des DTO laravel-data — 2026-11-05
- **CUS-02** (pas de repository sans besoin) — l'équipe impose un repository par agrégat — 2026-11-05
-->

## Sévérités

<!--
Format : - **ID** : ANCIENNE → NOUVELLE — raison
Exemple :
- **PERF-01** : MOYEN → CRITIQUE — nos listes dépassent les 10 000 lignes
-->

## Portée

<!--
Format : - **ID**, **ID** : portée — raison
Exemple :
- **PHP-01** : nouveaux fichiers et fichiers modifiés uniquement — code legacy non typé
-->
