# Template — Génération de agent-project/security.md

> Ce fichier explique à l'IA COMMENT utiliser `agent-project/security.md` pour un projet.
> `security.md` est un **journal d'audits**, pas un fichier de règles génériques.
>
> **Alimentation** : les sections de `security.md` sont produites par le sous-agent
> `agent/session/subagents/security-reviewer.md`, déclenché en gate bloquant à la fin d'une
> feature `securite: requise` (voir `agent/rules/workflow.md` §8). Écriture après validation.

---

## Quand créer / utiliser ce fichier

Une feature est à enjeu sécurité dès qu'elle touche :
- Authentification / session (login, logout, reset password)
- Mots de passe (création, mise à jour, reset)
- Rôles et permissions (authorization, gates, guards)
- Écriture de données utilisateur sur son propre compte ou celui d'un autre
- Endpoints publics ou API exposée
- Upload de fichiers par l'utilisateur

---

## Structure de agent-project/security.md

```markdown
# Journal de Sécurité — [Nom du projet]

> Toute feature à enjeu sécurité doit faire l'objet d'une section dans ce fichier.
> Dernière mise à jour : [date]

---

## [Feature : Authentification] — Audité le [date]

### Périmètre
[Ce que la feature permet de faire]

### Fichiers concernés
- [liste des fichiers]

### Garanties vérifiées
- [Garantie 1] → [extrait de code ou explication]
- [Garantie 2] → [extrait de code ou explication]

### Limites assumées
- [Compromis sécurité/UX accepté par l'utilisateur le [date]]

### Durcissements optionnels (non appliqués)
- [Option 1] : [description + code prêt à appliquer]

### Verdict
| Question | Réponse |
|---|---|
| Qui peut faire quoi ? | [réponse] |
| Authentification requise sur les endpoints sensibles ? | Oui / Non |
| Données isolées par utilisateur (ownership / IDOR) ? | Oui / Non |
| Entrées validées et sorties échappées (injections / XSS) ? | Oui / Non |
| CSRF protégé sur les mutations ? | Oui / Non |
| En-têtes présents (CORS/CSP/HSTS) ? | Oui / Non / N/A |
| Secrets hors code/dépôt (env/vault) ? | Oui / Non |
| Aléa cryptographiquement sûr (tokens/secrets) ? | Oui / Non / N/A |
| Rate limiting anti-bruteforce (auth) ? | Oui / Non / N/A |
| Pas de fuite d'infos (logs / erreurs / stockage client) ? | Oui / Non |
| Dépendances sans vulnérabilité connue ? | Oui / Non |

---

## [Feature suivante] — Audité le [date]
[idem]
```

---

## Règles de maintenance de security.md

- Chaque section a une **date d'audit**
- Après modification d'une feature auditée : **mettre à jour** la section + date
- Si un durcissement optionnel est appliqué : le déplacer vers "Garanties vérifiées"
- Si une nouvelle limite est acceptée : la tracer dans "Limites assumées"
- **Ne pas supprimer** les sections — les marquer `[ARCHIVÉ]` si la feature est supprimée
- Taille : pas de limite stricte (chaque audit peut être détaillé), mais éviter les redondances
