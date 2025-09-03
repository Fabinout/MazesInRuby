#!/usr/bin/env bash
# rerun_on_key.sh
# Relance un script Ruby à chaque pression de touche
# Usage:
#   ./rerun_on_key.sh [chemin/vers/script.rb] [args...]
# Exemples:
#   ./rerun_on_key.sh scripts/sidewinder_demo.rb 12
#   ./rerun_on_key.sh scripts/sidewinder_demo.rb 20 30
#   ./rerun_on_key.sh                 # défaut: scripts/sidewinder_demo.rb

set -euo pipefail

# Script Ruby cible (par défaut)
RUBY_SCRIPT_DEFAULT="scripts/sidewinder_demo.rb"

# Si un premier argument est fourni, c’est le script Ruby, sinon on utilise la valeur par défaut
if [[ $# -gt 0 ]]; then
  RUBY_SCRIPT="$1"
  shift
else
  RUBY_SCRIPT="$RUBY_SCRIPT_DEFAULT"
fi

# Vérification basique de l'existence du script Ruby
if [[ ! -f "$RUBY_SCRIPT" ]]; then
  echo "Erreur: script Ruby introuvable: $RUBY_SCRIPT" >&2
  echo "Usage: $0 [chemin/vers/script.rb] [args...]" >&2
  exit 1
fi

# Restaure le terminal en cas d'interruption
cleanup() {
  stty echo icanon 2>/dev/null || true
}
trap cleanup EXIT INT

while true; do
  clear
  ruby "$RUBY_SCRIPT" "$@"
  echo
  echo "Appuyez sur une touche pour régénérer, 'q' pour quitter..."
  IFS= read -r -s -n1 key || break
  [[ "${key:-}" =~ ^[qQ]$ ]] && break
done
