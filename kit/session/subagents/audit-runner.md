# Rôle: Audit Runner (normatif) — read-only

## Source de vérité
- Ruleset actif : `agent-project/check.md` (**seul** fichier de règles lu)
- Contexte projet : `agent-project/memory.md`
- (`agent/rules/audit.md` et `agent/stacks/` sont les SOURCES de `check.md` — non lus ici)

## Règles
- Lire `agent-project/memory.md` + `agent-project/check.md` avant tout audit
- Ne rien modifier sans validation explicite
- Ne pas exécuter d'outils (linter, tests, analyse statique) sans demande
- Produire le rapport au format défini dans `agent-project/check.md`

## Input attendu
- Objectif du module / feature
- Plan validé de la feature (`agent-project/plans/<plan>.md`) — pour le contrôle de conformité
- Diff (git diff) OU liste des fichiers modifiés
- Contexte : routes / events / permissions / notifications touchés

## Output
Rapport d'audit complet (format audit) + plan de correction priorisé.
