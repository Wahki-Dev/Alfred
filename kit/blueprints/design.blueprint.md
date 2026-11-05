# Template — Génération de agent-project/design.md

> Ce fichier explique à l'IA COMMENT générer `agent-project/design.md` pour un nouveau projet.

---

## Processus de création

### Étape 1 — Analyse visuelle du projet

Explorer :
- Les fichiers de styles/thème (`tailwind.config.js`, `variables.css`, `theme.ts`, etc.)
- Les composants UI existants (boutons, formulaires, cartes, modals, etc.)
- La structure des layouts (headers, sidebars, footers)
- Les conventions de nommage des classes CSS / composants
- Les icônes utilisées (lib, taille standard)
- Les couleurs définies (palette, sémantique)

### Étape 2 — Rédiger le draft

Documenter ce qui existe réellement dans le projet.
Ne pas inventer de règles qui ne sont pas appliquées.
Proposer pour validation.

---

## Structure de agent-project/design.md

```markdown
# Design System — [Nom du projet]

> Framework UI : [ex: TailwindCSS 3, Bootstrap 5, Material UI]
> Dernière mise à jour : [date]

## Changelog
- [date] : Création initiale

## Fondations

### Palette de couleurs
[Couleurs principales + sémantique]
- Primaire : [valeur]
- Secondaire : [valeur]
- Succès / Erreur / Attention / Info : [valeurs]

### Typographie
- Police principale : [nom]
- Tailles utilisées : [liste]
- Poids : [liste]

### Icônes
- Librairie : [ex: Heroicons, Lucide, FontAwesome]
- Taille standard : [ex: w-4 h-4 pour inline, w-5 h-5 pour boutons]
- Convention : [ex: toujours dans un conteneur fixe]

## Composants disponibles

### Boutons
[Lister les composants de boutons existants avec leur usage]
- [Composant] : [quand l'utiliser]

### Formulaires / Inputs
[Lister les composants de formulaire]
- [Composant] : [usage]

### Cartes / Conteneurs
[Lister les composants de conteneur]
- [Composant] : [usage]

### Navigation
[Composants de navigation : navbar, sidebar, breadcrumb, tabs]

### Feedback / États
[Badges, alertes, toasts, loaders]

## Layouts

### Structure générale
[Décrire la structure de page type]

### Layouts par contexte
[Si plusieurs layouts (admin, public, auth) : les décrire]

## Règles de développement UI

### Obligations
- TOUJOURS utiliser les composants existants avant du HTML brut
- [Règle spécifique projet]

### Interdictions
- INTERDIT : HTML brut quand un composant existe
- [Interdiction spécifique projet]

### Parité des pages
[Règles de cohérence entre pages similaires : vue/édit, liste/détail]

### Fallbacks visuels
- Afficher `—` quand une valeur est vide
- [Autre convention]

## Référence de style
[Pointer vers un fichier ou une page du projet qui fait référence en termes de style]
- Page de référence : [chemin ou URL]
```

---

## Règles de maintenance de design.md

- **Taille cible** : ≤ 200 lignes
- Pointer vers les fichiers de composants réels, ne pas les redocumenter ici
- Mettre à jour quand un nouveau composant est ajouté au projet
- Ne pas dupliquer les règles qui sont dans `memory.md`
