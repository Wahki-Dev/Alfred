# Directions techniques

Sources portables utilisées pendant `init` pour proposer une direction technique.

Ces fichiers ne sont pas des fichiers projet finaux.
Ils servent à générer `agent-project/architecture.md` via `agent/blueprints/architecture.blueprint.md`.

## Directions disponibles

- `custom.md` : **base** — contrôleurs fins → services (thin controller / fat service), adaptée au framework et au besoin réel.
- `ddd-lite.md` : **hybride** — base `custom` partout + DDD ciblé uniquement sur le coeur métier complexe (jamais full DDD par défaut).
- `ddd-guide-pratique.md` : **tutoriel** décision + process + exemples (IA et humain). « DDD ou classique ? », « j'ai mon use case, et après ? », « ça va dans le Domaine ou l'Application ? ».
- `ddd-light-hexagonal-guide.md` : annexe détaillée de `ddd-lite`, à appliquer **uniquement** sur la zone métier complexe.

## Règles d'usage

- Toujours proposer, jamais imposer.
- Sur projet existant, documenter d'abord l'architecture réelle.
- Sur projet vierge, utiliser `custom` par défaut si aucun choix explicite n'est validé. `ddd-lite` seulement si un coeur métier complexe est identifié — et il reste hybride.
- Les règles détaillées retenues vont dans `agent-project/architecture.md`.
- `agent-project/memory.md` ne garde qu'un résumé et le lien vers `agent-project/architecture.md`.
