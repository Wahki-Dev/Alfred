# Workflow — Développement d'une feature ou d'une correction

> Parcours : demande → plan → revue → **OK de l'utilisateur** → implémentation continue → fin de feature.
> L'utilisateur n'intervient qu'une fois, sur le plan. L'agent ne s'arrête ensuite que pour une décision
> réellement bloquante, un impact absent du plan, ou à la demande de l'utilisateur.

---

## 1. Qualification

Avant tout, chercher un plan existant pour cette demande dans `agent-project/plans/` :
- plan `en_cours` → le reprendre à la première étape non cochée (relire alors `memory.md`, `rules.md` et
  les fichiers du routing concernés) ;
- plan `terminé` ou `abandonné` → nouvelle demande, nouveau plan.

Sinon, classer la demande. **Parcours rapide** seulement si **toutes** les conditions sont vraies :
- changement local et évident : libellé, texte statique, couleur, ajustement d'affichage borné à l'endroit demandé ;
- aucune logique, donnée, contrat, API, permission ;
- aucun effet de bord identifiable ;
- aucun impact global : composant partagé, thème, token de design, traduction réutilisée, règle métier, sécurité.

Au moindre doute → parcours standard. Imposent toujours le parcours standard : jobs, files, traitement
asynchrone, configuration, infrastructure, modèle de données, règle métier, sécurité, style ou composant partagé.

**Parcours rapide** : appliquer directement, puis répondre `Parcours rapide` + résumé du diff. Pas de plan,
pas de test. Si un effet de bord ou une décision apparaît en cours de route : s'arrêter et passer au
parcours standard.

---

## 2. Plan

Écrire le plan dans `agent-project/plans/AAAA-MM-JJ-HHMM-slug.md` (template :
`agent/session/doc-templates/plan.md`), après avoir lu les fichiers du routing (`agent/AGENT.md` §2) et
cherché l'existant réutilisable (échelle `agent/rules/ponytail.md`).

Le plan doit :
- découper le travail en **étapes à cocher**, chacune actionnable ;
- dire pour chaque exigence comment elle est **vérifiée** : test (`agent/rules/tests.md`, par défaut) ou commande ;
- lister les règles métier existantes concernées et les **nouvelles règles proposées** ;
- renseigner les **implications transverses**, une ligne par axe, `non concerné` + raison si besoin :
  code (appelants, contrats, régressions), asynchrone (files, jobs, cron, retries, blocage), exploitation
  (logs, alertes, reprise), infrastructure (config, ressources, déploiement) ;
- si la direction du projet est `ddd-lite` et que la feature crée une zone métier : appliquer le test de
  décision de `agent/technical-directions/ddd-lite.md`.

### Feature à enjeu sécurité

La feature est sensible si elle touche l'un de ces points :
authentification ou session · mots de passe · rôles et permissions · écriture de données utilisateur
(son compte ou celui d'un autre) · endpoint public ou API · upload · export de fichiers · appel HTTP vers
une URL fournie par l'utilisateur · webhook · paiement · données personnelles.

Sensible → `securite: requise` dans le front-matter, annoncé dans le plan : la revue sécurité de fin de
feature sera bloquante (§5).

### Revue (un passage)

Avant de présenter le plan : lancer `agent/session/subagents/plan-reviewer.md` sur le plan, appliquer
les corrections, et laisser les points qui demandent une décision dans « Questions ». Pas de seconde boucle.

### Arrêt obligatoire

Présenter un résumé du plan, son chemin, puis terminer par :

```
✋ Plan revu et présenté — en attente de ta validation.
Réponds OK pour lancer l'implémentation (ou « OK sans tests »), ou indique les ajustements.
```

Aucun code avant ce OK. « OK sans tests » → `tests: non` dans le front-matter.
Ajustement demandé → modifier le plan, puis le représenter.

---

## 3. Implémentation (continue)

Après le OK, passer le plan à `statut: en_cours` et enchaîner les étapes sans attendre :

1. Implémenter l'étape en montant l'échelle ponytail ; appliquer `agent-project/rules.md`.
2. Écrire les tests prévus (sauf `tests: non`) et lancer les commandes de vérification déclarées dans
   `memory.md` ; corriger jusqu'au vert, ou signaler ce qui reste rouge.
3. Cocher l'étape dans le plan.
4. Impact (code, asynchrone, exploitation, infrastructure) ou règle métier absent du plan → s'arrêter,
   compléter le plan, attendre l'accord sur cet écart.
5. Incident ou écart notable → une ligne dans « Notes d'implémentation » du plan.

Pas de relecture complète des fichiers projet entre deux étapes : ils sont déjà en contexte.

---

## 4. Code review (optionnelle)

Sur demande : lancer `agent/session/subagents/code-reviewer.md` avec le diff et l'objectif.

---

## 5. Fin de feature

Déclenchée automatiquement après la dernière étape, ou par « termine la feature ».

1. **Vérification** : lancer toutes les commandes déclarées (tests, lint, analyse statique ; audit des
   dépendances si `securite: requise`). Résultats réels dans le rapport.
2. **Audit** du diff de la feature selon `agent/rules/audit.md` (règles du kit + `agent-project/rules.md`).
3. **Revue sécurité** si `securite: requise` : `agent/session/subagents/security-reviewer.md`. Résultat
   dans la section « Revue sécurité » du plan. **Bloquant** : tant qu'une règle `socle` est violée, le plan
   ne passe pas `terminé`.
4. **Conformité au plan** : chaque étape cochée et réellement faite, rien d'oublié, rien hors périmètre
   sans accord.
5. **Règles métier** : écrire dans `agent-project/business-rules.md` celles validées avec le plan
   (`agent/blueprints/business-rules.blueprint.md`).
6. **Roadmap** (si `agent-project/roadmap.md` existe) : `agent/session/subagents/roadmap-manager.md`
   propose la mise à jour des tâches liées.
7. **Rapport** : vérifications, violations, revue sécurité, conformité. Corriger ce qui est CRITIQUE.
8. Passer le plan à `statut: terminé`.

Plan abandonné à la demande de l'utilisateur → `statut: abandonné`, rien n'est écrit dans `business-rules.md`.
