# Recettage — Traitement des bugs et retours QA

<!--
INSTRUCTIONS D'INSTALLATION (supprimer après remplissage) :
Remplacer les 5 placeholders ci-dessous, puis sauvegarder ce fichier sous agent-project/recettage.md

| Placeholder                  | Description                              |
|------------------------------|------------------------------------------|
| {{USER_NAME}}                | Prénom et nom (ex: Vinc Dude)    |
| {{USER_NOTION_ID}}           | ID Notion (ex: user://989d6a07-...)      |
| {{NOTION_TRAITABLE_CURSOR_URL}} | URL vue Notion "traitable cursor"     |
| {{NOTION_A_TRAITER_VIEW_ID}} | ID vue Notion "à traiter" (fallback)     |
| {{USERBACK_VIEWER_URL}}      | URL base Userback (ex: https://app.userback.io/viewer/) |
-->

## Configuration

- Utilisateur cible : {{USER_NAME}}
- ID Notion : {{USER_NOTION_ID}}
- Vue principale : {{NOTION_TRAITABLE_CURSOR_URL}}
- Vue fallback : {{NOTION_A_TRAITER_VIEW_ID}}
- Userback viewer : {{USERBACK_VIEWER_URL}}

## Outils requis
- Notion MCP : recherche/récupération des cartes (priorité)
- Browserloop MCP : captures d'écran via URLs Userback
- Fallback : si MCP indisponible, informer l'utilisateur uniquement

---

## Workflow de traitement

### Phase 1 — Initialisation automatique (démarrage sans confirmation)
1. Lire `agent-project/memory.md`
2. Connexion MCP Notion (arrière-plan)
3. Récupérer les cartes depuis la vue : {{NOTION_TRAITABLE_CURSOR_URL}}
4. Traitement séquentiel (ordre de récupération, sans tri temporel)

### Phase 2 — Traitement unitaire par carte

#### Étape 1 : Annonce
Annoncer la carte avec 3 URLs distinctes :
- URL Carte Notion : lien direct vers la carte
- URL Plateforme : page concernée par la demande
- URL Userback : screenshot annoté ({{USERBACK_VIEWER_URL}}...)

#### Étape 2 : Classification

**SIMPLE**
- Interface/UI : textes, labels, boutons, CSS
- Cosmétique : couleurs, icônes, espacements
- Config évidente : valeurs manifestement incorrectes
- Critères : solution en < 2min, 1 fichier, aucun impact logique métier

**COMPLEXE** (investigation approfondie OBLIGATOIRE)
- Logique métier : statuts, workflows, transitions
- Architecture : services, contrôleurs, modèles multiples
- Données corrompues : migrations, formatage
- Intégrations : API, événements, systèmes externes
- Critères : flux métier, multiples composants, impacts transverses

#### Étape 3 : Traitement

**Si SIMPLE** :
1. Plan d'action détaillé (fichiers, logique, approche)
2. STOP — Attendre le feu vert explicite avant tout codage
3. Exécution selon plan validé uniquement
4. Vérification résultat
5. Demander si marquer `Traité = YES` — ne jamais le faire seul

**Si COMPLEXE** :
1. Diagnostic — Root Cause / Investigation approfondie
2. Plan d'action détaillé avec justifications
3. STOP — Attendre le feu vert explicite avant tout codage
4. Exécution selon plan validé uniquement
5. Vérification résultat
6. Demander si marquer `Traité = YES` — ne jamais le faire seul

### Phase 3 — Gestion des commentaires
- Priorité absolue : commentaires > demande initiale
- Questions → remonter à l'utilisateur
- Informations → intégrer au plan d'action

---

## Critères de filtrage (application stricte)

### Inclusion (ET logique)
1. Statut traitement : `Traité` ∈ {`NO`, `NULL`}
2. Assignation : {{USER_NAME}} présent dans `Tags` OU `Personne` (comparaison par ID uniquement)
3. Exclusions : `Sélection` ∉ {`FAQ`, `A préciser BBC`, `à l'étude chez WAC`}

### Algorithme de récupération
1. PRIORITÉ : Utiliser la vue pré-filtrée {{NOTION_TRAITABLE_CURSOR_URL}}
2. FALLBACK : Si problème → utiliser {{NOTION_A_TRAITER_VIEW_ID}}, appliquer filtre {{USER_NOTION_ID}}, appliquer les exclusions Sélection

---

## Schéma des propriétés Notion

- Tags (people) : utilisateurs assignés
- Personne (people) : assignations
- Sélection (select) : {FAQ, A préciser BBC, En cours WAC, à l'étude chez WAC}
- Traité (checkbox) : YES (vrai) | NO (faux) | NULL (faux par défaut)

---

## Méthodologie anti-erreurs

### Défaillances à éviter
- Recherche temporelle restrictive (focus sur cartes anciennes → cartes récentes ratées)
- Termes de recherche limités
- Tri chronologique défaillant

### Approche correcte
- Récupération exhaustive : scan complet sans restriction temporelle
- Recherche multiple avec termes variés
- Traitement séquentiel dans l'ordre de récupération

---

## Restrictions absolues

- JAMAIS écrire, modifier ou mettre à jour une carte Notion sans accord explicite
- JAMAIS coder sans plan présenté et feu vert obtenu
- JAMAIS marquer `Traité = YES` sans validation
- JAMAIS utiliser recherche plein texte pour filtrer People/Select
- JAMAIS persister les captures Browserloop dans le dépôt
- JAMAIS exécuter de commandes shell pour Notion
