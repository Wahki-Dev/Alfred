# Blueprint — agent-project/security.md (socle sécurité du projet)

> `security.md` décrit le **socle** de sécurité du projet et les **limites assumées**. Ce n'est ni un journal
> d'audits ni une liste de failles : la revue de chaque feature est écrite dans son plan
> (`agent/rules/workflow.md` §5).
> Créé à l'`init` (projet web ou API), revérifié par `audit fichiers agent`. Écriture après validation.

---

## Création (à l'`init`)

Analyser, sans lancer de commande hors vérification déclarée :
- mécanisme d'authentification et d'autorisation (guards, policies, voters, middlewares) ;
- configuration des en-têtes et du transport (SEC-23 de `agent/rules/audit.md`) : HTTPS, HSTS, CSP,
  `X-Content-Type-Options`, `frame-ancestors`, CORS ;
- gestion des secrets (fichiers d'environnement ignorés par git) ;
- outil d'audit des dépendances disponible (`composer audit`, `npm audit`).

Ce qui ne peut pas être vérifié dans le code (configuration serveur, proxy) est noté « à confirmer ».

## Structure

```markdown
# Sécurité — [Nom du projet]

> Dernière vérification : [AAAA-MM-JJ]

## Socle
- Authentification : [mécanisme]
- Autorisation : [mécanisme, où sont les règles]
- En-têtes et transport : HTTPS [ok / à confirmer] · HSTS [...] · CSP [...] · CORS [...]
- Secrets : [emplacement, ignorés par git : oui / non]
- Audit des dépendances : [commande]

## Limites assumées
- [AAAA-MM-JJ] [règle concernée, ex : SEC-14] — [périmètre exact] — [raison] — validé par [nom]
```

## Règles

- Aucun détail exploitable : pas de code vulnérable, pas de liste de failles non corrigées. Une faiblesse
  connue non corrigée devient un ticket, pas une ligne de ce fichier.
- Une limite assumée est datée, précise son périmètre, et n'est ajoutée qu'après validation explicite.
- Une limite sur une règle `socle` (SEC-01 à SEC-08) est une exception ponctuelle, jamais une
  désactivation générale.
- Aucun secret ni donnée personnelle dans ce fichier.
