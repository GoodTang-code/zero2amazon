#!/usr/bin/env bash
set -euo pipefail

# Reset project root to keep only:
# - 00_process/
# - note/
# - README.md
# Default mode is dry-run. Use --apply to execute deletion and --yes to skip confirmation.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPLY=false
YES=false

usage() {
  cat <<'USAGE'
Usage: bash 00_process/reset_project.sh [--apply] [--yes]

Options:
  --apply   Execute deletion (default is dry-run)
  --yes     Skip interactive confirmation (only meaningful with --apply)
  -h, --help  Show this help message
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    --yes) YES=true ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

cd "$ROOT_DIR"

KEEP=("00_process" "note" "README.md")
TO_DELETE=()

while IFS= read -r -d '' path; do
  name="$(basename "$path")"
  keep=false
  for k in "${KEEP[@]}"; do
    if [[ "$name" == "$k" ]]; then
      keep=true
      break
    fi
  done
  if [[ "$keep" == false ]]; then
    TO_DELETE+=("$path")
  fi
done < <(find . -mindepth 1 -maxdepth 1 -print0)

if [[ ${#TO_DELETE[@]} -eq 0 ]]; then
  echo "Nothing to delete. Project already matches target layout."
  exit 0
fi

echo "Project root: $ROOT_DIR"
echo "Will keep: 00_process/ , note/ , README.md"
echo "Will delete (${#TO_DELETE[@]} items):"
for p in "${TO_DELETE[@]}"; do
  echo "  - ${p#./}"
done

if [[ "$APPLY" == false ]]; then
  echo
  echo "Dry-run only. Re-run with --apply to execute deletion."
  exit 0
fi

if [[ "$YES" == false ]]; then
  echo
  read -r -p "Type del to confirm: " confirm
  if [[ "$confirm" != "del" ]]; then
    echo "Cancelled."
    exit 1
  fi
fi

for p in "${TO_DELETE[@]}"; do
  rm -rf -- "$p"
done

echo "Reset complete. Remaining root items:"
ls -la
