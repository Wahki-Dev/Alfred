# Ponytail — Philosophie de code (lazy senior)

> Règle universelle (portable, jamais spécifique à un projet ou une stack).
> **Process** : référencée par `agent/rules/workflow.md` (PLAN + IMPLEMENT).
> **Audit** : source de compilation de `agent-project/check.md` (voir `agent/blueprints/check.blueprint.md`).

Lazy = efficace, pas négligent. Le meilleur code est celui qu'on n'écrit pas.

---

## L'échelle (s'arrêter au premier barreau qui tient)

À monter APRÈS avoir compris le problème (lire la tâche + le code touché, tracer le flux réel
de bout en bout), jamais à la place :

1. Faut-il vraiment le construire ? (YAGNI)
2. Ça existe déjà dans ce codebase ? → réutiliser le helper/util/pattern existant.
3. La lib standard le fait déjà ? → l'utiliser.
4. Une fonctionnalité native de la plateforme le couvre ? → l'utiliser.
5. Une dépendance déjà installée le résout ? → l'utiliser.
6. Ça tient en une ligne ? → une ligne.
7. Seulement ensuite : écrire le minimum qui marche.

---

## Règles

- **Fix de bug = cause racine, pas symptôme** : un rapport nomme un symptôme. Grep tous les
  appelants de la fonction touchée, corriger la fonction partagée UNE fois (un garde là > un
  par appelant ; patcher juste le chemin du ticket laisse un appelant frère cassé).
- Pas d'abstraction non demandée. Pas de nouvelle dépendance évitable. Pas de boilerplate.
- Suppression > ajout. Ennuyeux > malin. Le moins de fichiers possible.
- Le plus petit diff qui marche gagne — mais seulement une fois le problème compris (un petit
  diff au mauvais endroit n'est pas lazy, c'est un 2e bug).
- À taille égale entre deux approches stdlib, prendre celle correcte sur les edge-cases (lazy
  = moins de code, pas l'algo le plus fragile).
- Marquer les simplifications intentionnelles par un commentaire `ponytail:` ; si le raccourci
  a un plafond connu (lock global, scan O(n²), heuristique naïve), le commentaire nomme le
  plafond et le chemin d'upgrade.

---

## PAS lazy sur

Comprendre le problème (lire en entier, tracer le flux réel avant de choisir un barreau), la
validation aux frontières de confiance, la gestion d'erreur qui évite la perte de données, la
sécurité, l'accessibilité, la calibration que le matériel réel exige (la plateforme n'est
jamais l'idéal du spec : une horloge dérive, un capteur lit faux), tout ce qui est
explicitement demandé.

Du code lazy sans son check est inachevé : toute logique non triviale laisse UN check runnable
(une démo/self-check à base d'assert, ou un petit fichier de test ; sans framework, sans
fixtures). Un one-liner trivial n'a pas besoin de test.
