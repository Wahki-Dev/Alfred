#!/usr/bin/env bash
# Test d'intégration de install.sh contre un dépôt de kit local (copie de l'arbre de travail).
# Usage : bash tests/install-test.sh
set -euo pipefail

REPO=$(cd "$(dirname "$0")/.." && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
INSTALLER="$REPO/install.sh"

fail() {
  echo "ÉCHEC : $*" >&2
  exit 1
}
ok() { echo "ok - $*"; }
g() { git -c user.name=ci -c user.email=ci@example.invalid -c init.defaultBranch=main "$@"; }

# Dépôt de kit local : v1.0.0 (stable) puis v1.1.0-rc1 (pré-version, ne doit pas être choisie).
KIT="$WORK/kit-repo"
mkdir "$KIT"
(cd "$REPO" && tar --exclude=./.git -cf - .) | (cd "$KIT" && tar xf -)
(
  cd "$KIT"
  g init -q
  g add -A
  g commit -qm "kit"
  g tag v1.0.0
  echo "pré-version" > rc.txt
  g add rc.txt
  g commit -qm "rc"
  g tag v1.1.0-rc1
)
export AGENT_KIT_URL="$KIT"
unset AGENT_KIT_VERSION || true

# Projet fixture.
APP="$WORK/app"
mkdir "$APP"
cd "$APP"
g init -q

# 1) Installation fraîche.
sh "$INSTALLER" >/dev/null 2>&1 || fail "installation fraîche"
[ -f agent/AGENT.md ] || fail "agent/AGENT.md absent"
[ "$(sed -n 1p agent/VERSION)" = "v1.0.0" ] || fail "VERSION ligne 1 : attendu v1.0.0, obtenu $(sed -n 1p agent/VERSION)"
sed -n 2p agent/VERSION | grep -qE '^[0-9a-f]{40}$' || fail "VERSION ligne 2 : SHA attendu"
[ ! -e agent.new ] || fail "agent.new/ laissé en place"
for f in agent-project/rules.md CLAUDE.md AGENTS.md .cursor/rules/global.mdc .github/copilot-instructions.md; do
  [ -f "$f" ] || fail "$f absent après installation"
done
ok "installation fraîche (v1.0.0, pré-version ignorée)"

# 2) Mise à jour : agent-project/ préservé.
echo "mémoire modifiée par l'équipe" > agent-project/memory.md
g add -A
g commit -qm "app"
sh "$INSTALLER" >/dev/null 2>&1 || fail "mise à jour"
[ "$(cat agent-project/memory.md)" = "mémoire modifiée par l'équipe" ] || fail "agent-project/memory.md écrasé"
[ "$(sed -n 1p agent/VERSION)" = "v1.0.0" ] || fail "VERSION après mise à jour"
ok "mise à jour : agent-project/ préservé"

# 3) Version explicite (pré-version demandée explicitement).
sh "$INSTALLER" v1.1.0-rc1 >/dev/null 2>&1 || fail "installation d'une version explicite"
[ "$(sed -n 1p agent/VERSION)" = "v1.1.0-rc1" ] || fail "version explicite non respectée"
ok "version explicite"

# 4) Refus si agent/project/ existe.
mkdir -p agent/project
if sh "$INSTALLER" >/dev/null 2>&1; then fail "aurait dû refuser agent/project/"; fi
rmdir agent/project
ok "refus si agent/project/ existe"

# 5) Refus hors racine du dépôt.
mkdir -p sub
if (cd sub && sh "$INSTALLER" >/dev/null 2>&1); then fail "aurait dû refuser un sous-dossier"; fi
[ ! -e sub/agent ] || fail "installation créée dans le sous-dossier"
ok "refus dans un sous-dossier"

# 6) Refus hors dépôt git.
NOGIT="$WORK/nogit"
mkdir "$NOGIT"
if (cd "$NOGIT" && sh "$INSTALLER" >/dev/null 2>&1); then fail "aurait dû refuser hors dépôt git"; fi
[ ! -e "$NOGIT/agent" ] || fail "installation créée hors dépôt git"
ok "refus hors dépôt git"

echo "install-test : OK"
