# Changelog

Format : une section par version publiée (tag git `vX.Y.Z`), la plus récente en haut.

## [1.0.0] — non publiée

Première version distribuable.

- Kit regroupé dans `kit/`, installé dans `agent/` de chaque app par `install.ps1` / `install.sh`.
- Mémoire de l'app déplacée de `agent/project/` vers `agent-project/` (hors du kit, jamais
  écrasée par une mise à jour).
- Version installée écrite dans `agent/VERSION`.
- Fichiers de démarrage IDE créés à l'installation s'ils sont absents.
