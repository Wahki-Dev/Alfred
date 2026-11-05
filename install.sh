#!/bin/sh
# Installe ou met à jour le kit agent dans le projet courant (à lancer depuis la racine du dépôt git du projet).
#   Dernière version : curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh
#   Version précise  : curl -fsSL https://raw.githubusercontent.com/Wahki-Dev/Alfred/main/install.sh | sh -s -- v1.0.0
# Variables optionnelles : AGENT_KIT_VERSION (version), AGENT_KIT_URL (dépôt git du kit, ex : un fork).
set -eu

KIT_URL="${AGENT_KIT_URL:-https://github.com/Wahki-Dev/Alfred.git}"
VERSION="${1:-${AGENT_KIT_VERSION:-}}"

fail() {
  echo "Erreur : $1" >&2
  exit 1
}

warn() {
  echo "Attention : $1" >&2
}

command -v git >/dev/null 2>&1 || fail "git est requis."

TOP=$(git rev-parse --show-toplevel 2>/dev/null) \
  || fail "le dossier courant n'est pas dans un dépôt git. Lancer le script depuis la racine du projet."
[ "$(cd "$TOP" && pwd -P)" = "$(pwd -P)" ] \
  || fail "lancer le script depuis la racine du dépôt ($TOP), pas depuis un sous-dossier."

if [ -d agent/project ]; then
  fail "agent/project/ existe (ancienne installation). Déplacer son contenu vers agent-project/, supprimer agent/project/, puis relancer."
fi
if [ -d agent ] && [ ! -f agent/AGENT.md ]; then
  fail "agent/ existe mais ne contient pas AGENT.md : ce n'est pas le kit, installation annulée."
fi
if [ -d agent ] && [ -n "$(git status --porcelain -- agent 2>/dev/null)" ]; then
  warn "agent/ contient des modifications locales non commitées : elles vont être écrasées."
fi

if [ -z "$VERSION" ]; then
  # Dernière version stable : les pré-versions (tags contenant « - », ex : v1.1.0-rc1) sont ignorées.
  VERSION=$(git ls-remote --tags --refs --sort=-v:refname "$KIT_URL" 'refs/tags/v*' \
    | sed 's#.*refs/tags/##' | grep -v -- '-' | head -n 1 || true)
  [ -n "$VERSION" ] || fail "aucune version publiée trouvée sur $KIT_URL."
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP" agent.new' EXIT

git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$VERSION" -c core.autocrlf=false "$KIT_URL" "$TMP/src" \
  || fail "impossible de récupérer la version $VERSION depuis $KIT_URL."
[ -f "$TMP/src/kit/AGENT.md" ] || fail "la version $VERSION ne contient pas kit/AGENT.md."
SHA=$(git -C "$TMP/src" rev-parse HEAD)

PREVIOUS=""
[ -f agent/VERSION ] && PREVIOUS=$(head -n 1 agent/VERSION)

# Remplacement atomique : le nouveau kit est préparé dans agent.new/ avant de toucher à agent/.
rm -rf agent.new
cp -R "$TMP/src/kit" agent.new
printf '%s\n%s\n' "$VERSION" "$SHA" > agent.new/VERSION
rm -rf agent
mv agent.new agent

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
  grep -q 'agent/AGENT.md' "$rel" || warn "$rel existe déjà sans référence à agent/AGENT.md, ajouter l'instruction à la main (voir agent/README.md)."
done

if [ -n "$PREVIOUS" ]; then
  echo "Kit agent mis à jour : $PREVIOUS -> $VERSION ($SHA)"
  echo "À faire : relire le CHANGELOG, commiter agent/. L'agent signale au démarrage les identifiants de agent-project/rules.md inconnus du kit."
else
  echo "Kit agent $VERSION installé dans agent/ ($SHA)"
  echo "À faire : commiter agent/ et agent-project/, puis lancer la commande 'init' dans l'IDE."
fi
