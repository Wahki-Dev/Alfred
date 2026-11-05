# Kit agent — Comment ça marche

Ce dossier `agent/` cadre le travail d'une IA de code (Claude Code, Cursor, Copilot…) sur ce projet.
Il est installé et mis à jour par le script du dépôt du kit : **ne pas le modifier à la main**, la
prochaine mise à jour l'écrase. Version installée : `VERSION`.
v1 : stacks PHP (Laravel, Symfony, CakePHP). Les règles universelles s'appliquent à toute stack.

## Au quotidien

1. Tu formules ta demande (« ajoute l'export CSV des factures »).
2. L'IA écrit un plan dans `agent-project/plans/`, le fait relire, te le présente.
3. Tu réponds **OK** (ou « OK sans tests », ou tes ajustements).
4. L'IA implémente toutes les étapes d'affilée, lance les tests et les vérifications du projet.
5. En fin de feature : audit, revue sécurité si la feature est sensible, rapport.

Changement trivial (libellé, couleur) : l'IA l'applique directement et te montre le diff.
Reprise : « reprends le plan export-csv ». Commandes : `commands.md`.

## Les trois couches

| Où | Quoi | Qui l'écrit |
|---|---|---|
| `agent/` | Règles du kit, identiques pour tous les projets d'une même version | le kit |
| `agent-project/rules.md` | Règles de **ton équipe** : ajouts, désactivations, sévérités, portées | l'équipe |
| `agent-project/` (autres fichiers) | Mémoire du projet : stack, architecture, règles métier, plans | l'IA, après ta validation |

Priorité : `rules.md` > direction technique > stack > règles universelles. Les règles marquées `socle`
(sécurité de base) ne se désactivent pas.

## Structure

```
agent/
  AGENT.md              ← point d'entrée, lu à chaque session (routing + non-négociables)
  commands.md           ← commandes (init, audit, architecture, cdc, roadmap, audit fichiers agent)
  rules/
    workflow.md         ← parcours : qualification, plan, implémentation, fin de feature
    audit.md            ← règles universelles (identifiants, sévérités) + procédure d'audit
    tests.md            ← politique de tests
    ponytail.md         ← parcimonie : réutiliser avant d'écrire
    maintenance.md      ← cohérence des fichiers agent-project/
  stacks/php/           ← règles PHP, Laravel, Symfony, CakePHP + aide à la décision (init)
  technical-directions/ ← custom (par défaut) et ddd-lite (DDD ciblé sur le métier complexe)
  blueprints/           ← modèles des fichiers agent-project/
  session/              ← sous-agents (revues) et template de plan
  modules/recettage.md  ← module optionnel QA (Notion + Userback)
```

## Après une mise à jour du kit

Commiter `agent/` (le diff montre ce qui a changé) et lire le CHANGELOG du kit. Si une règle visée par
`agent-project/rules.md` a changé d'identifiant ou disparu, l'IA le signale au démarrage de session.
