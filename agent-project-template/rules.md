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
- **PRJ-01** · CRITIQUE — Tout texte affiché a une clé de traduction dans `lang/fr` ET `lang/es`.
- **PRJ-02** · MOYEN — Les scopes et relations Eloquent porteurs d'une règle sont testés avec la base de test.
-->

## Désactivations

<!--
Format : - **ID** (rappel de la règle) — raison — AAAA-MM-JJ
Exemple :
- **TEST-03** (ne pas tester l'ORM) — l'équipe teste aussi la couche ORM — 2026-11-05
-->

## Sévérités

<!--
Format : - **ID** : ANCIENNE → NOUVELLE — raison
Exemple :
- **LAR-06** : MINEUR → MOYEN — les composants Blade sont la norme de l'équipe
-->

## Portée

<!--
Format : - **ID**, **ID** : portée — raison
Exemple :
- **PHP-01** : nouveaux fichiers et fichiers modifiés uniquement — code legacy non typé
-->
