#!/usr/bin/env bash
# Vérifications statiques du kit : liens internes, identifiants de règles, catalogue des commandes.
# Usage : bash tests/check-kit.sh (depuis n'importe où)
set -euo pipefail
cd "$(dirname "$0")/.."

errors=0
err() {
  echo "ERREUR : $*" >&2
  errors=$((errors + 1))
}

# 1) Chaque chemin `agent/...` cité existe dans kit/.
while IFS= read -r p; do
  case "$p" in
    *'<'* | *'...'* | *'*'* | *'{'* | agent/VERSION) continue ;;
  esac
  f="kit/${p#agent/}"
  f="${f%/}"
  [ -e "$f" ] || err "chemin cité introuvable : $p (attendu : $f)"
done < <(grep -rhoE '`agent/[^` ]+`' kit bootstrap agent-project-template | tr -d '`' | sort -u)

# 2) Identifiants de règles : une définition par identifiant, aucun identifiant retiré réutilisé.
#    Une définition est une ligne de liste « - **ABC-01** · ... ».
ids=$(grep -rhoE '^[[:space:]]*- \*\*[A-Z]+-[0-9]{2}\*\*' kit \
  | grep -oE '[A-Z]+-[0-9]{2}' | grep -vE '^(PRJ|BR)-' || true)
if [ -n "$ids" ]; then
  dups=$(printf '%s\n' "$ids" | sort | uniq -d)
  [ -z "$dups" ] || err "identifiants définis plusieurs fois : $(echo "$dups" | tr '\n' ' ')"
  retired=$(grep -vE '^[[:space:]]*(#|$)' tests/retired-ids.txt || true)
  for id in $retired; do
    printf '%s\n' "$ids" | grep -qx "$id" && err "identifiant retiré réutilisé : $id"
  done
fi
echo "Identifiants de règles définis : $(printf '%s' "$ids" | grep -c . || true)"

# 3) Chaque commande de l'index de kit/commands.md a sa section « ## <commande> ».
#    Une section peut regrouper plusieurs commandes : « ## audit memory · audit check ».
cmds=$(awk '/^## Index des commandes/{f=1; next} f && /^## /{exit} f && /^\|/' kit/commands.md \
  | awk -F'|' '{print $2}' | grep -oE '`[^`]+`' | tr -d '`' \
  | sed -E 's/ *\[[^]]*\]//; s/^ +| +$//g' | grep -vE '^(Commande|—)$' || true)
headings=$(grep -E '^## ' kit/commands.md | sed -E 's/^## //' \
  | awk -F' · ' '{for (i = 1; i <= NF; i++) print $i}' \
  | sed -E 's/ *\[[^]]*\]//; s/ *\(.*\)//; s/^ +| +$//g')
while IFS= read -r c; do
  [ -n "$c" ] || continue
  printf '%s\n' "$headings" | grep -qxF "$c" || err "commande sans section dans kit/commands.md : $c"
done <<< "$cmds"

# 4) AGENT.md est lu à chaque session : alerte (non bloquante) s'il grossit.
lines=$(wc -l < kit/AGENT.md)
if [ "$lines" -gt 80 ]; then
  echo "Avertissement : kit/AGENT.md fait $lines lignes (> 80), il est lu à chaque session." >&2
fi

if [ "$errors" -gt 0 ]; then
  echo "$errors erreur(s)." >&2
  exit 1
fi
echo "check-kit : OK"
