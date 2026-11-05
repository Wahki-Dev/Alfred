#!/bin/sh
# Installe ou met à jour le kit agent dans le projet courant (à lancer depuis la racine du projet).
#   Dernière version : curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh
#   Version précise  : curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh -s -- v1.3.0
# Variables optionnelles : AGENT_KIT_VERSION (version), AGENT_KIT_URL (dépôt git du kit, ex : un fork).
set -eu

KIT_URL="${AGENT_KIT_URL:-https://github.com/Wahki-Dev/Alfred.git}"
VERSION="${1:-${AGENT_KIT_VERSION:-}}"

fail() {
  echo "Erreur : $1" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || fail "git est requis."

if [ -d agent/project ]; then
  fail "agent/project/ existe (ancienne installation). Déplacer son contenu vers agent-project/, supprimer agent/project/, puis relancer."
fi
if [ -d agent ] && [ ! -f agent/AGENT.md ]; then
  fail "agent/ existe mais ne contient pas AGENT.md : ce n'est pas le kit, installation annulée."
fi

if [ -z "$VERSION" ]; then
  VERSION=$(git ls-remote --tags --refs --sort=-v:refname "$KIT_URL" 'refs/tags/v*' | head -n 1 | sed 's#.*refs/tags/##')
  [ -n "$VERSION" ] || fail "aucune version publiée trouvée sur $KIT_URL."
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$VERSION" -c core.autocrlf=false "$KIT_URL" "$TMP/src" \
  || fail "impossible de récupérer la version $VERSION depuis $KIT_URL."
[ -f "$TMP/src/kit/AGENT.md" ] || fail "la version $VERSION ne contient pas kit/AGENT.md."

PREVIOUS=""
[ -f agent/VERSION ] && PREVIOUS=$(cat agent/VERSION)

rm -rf agent
cp -R "$TMP/src/kit" agent
printf '%s\n' "$VERSION" > agent/VERSION

copy_missing() {
  (cd "$1" && find . -type f) | while IFS= read -r rel; do
    rel=${rel#./}
    if [ ! -e "$2/$rel" ]; then
      mkdir -p "$(dirname "$2/$rel")"
      cp "$1/$rel" "$2/$rel"
      echo "  créé : $2/$rel"
    fi
  done
}

copy_missing "$TMP/src/agent-project-template" agent-project
copy_missing "$TMP/src/bootstrap" .

(cd "$TMP/src/bootstrap" && find . -type f) | while IFS= read -r rel; do
  rel=${rel#./}
  grep -q 'agent/AGENT.md' "$rel" || echo "Attention : $rel existe déjà sans référence à agent/AGENT.md, ajouter l'instruction à la main (voir agent/README.md)."
done

if [ -n "$PREVIOUS" ]; then
  echo "Kit agent mis à jour : $PREVIOUS -> $VERSION"
  echo "À faire : commiter agent/, puis lancer la commande 'regen check' dans l'IDE."
else
  echo "Kit agent $VERSION installé dans agent/"
  echo "À faire : commiter agent/ et agent-project/, puis lancer la commande 'init' dans l'IDE."
fi
