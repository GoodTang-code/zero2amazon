#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  AUTO_PUSH_ENCRYPT_KEY="your-secret" npm run auto_push "commit message" ["x.y.z"]
  npm run auto_push "your-secret" "commit message" ["x.y.z"]

Example:
  AUTO_PUSH_ENCRYPT_KEY="my-secret" npm run auto_push "update pre-writing flow" "1.0.0"
  AUTO_PUSH_ENCRYPT_KEY="my-secret" npm run auto_push "update pre-writing flow"
  npm run auto_push "my-secret" "update pre-writing flow" "1.0.0"
  npm run auto_push "my-secret" "update pre-writing flow"
EOF
}

if [[ $# -lt 1 || $# -gt 3 ]]; then
  usage
  exit 1
fi

SECRET_ARG=""
COMMIT_MSG=""
NEW_VERSION=""

if [[ -n "${AUTO_PUSH_ENCRYPT_KEY:-}" ]]; then
  # Env mode: args are commit [version]
  COMMIT_MSG="${1:-}"
  NEW_VERSION="${2:-}"
else
  # Arg mode: args are secret commit [version]
  if [[ $# -lt 2 ]]; then
    usage
    exit 1
  fi
  SECRET_ARG="$1"
  COMMIT_MSG="$2"
  NEW_VERSION="${3:-}"
  AUTO_PUSH_ENCRYPT_KEY="$SECRET_ARG"
fi

if [[ -n "$NEW_VERSION" ]] && [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: version must be in x.y.z format (received: $NEW_VERSION)" >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: this command must run inside a git repository." >&2
  exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ -z "$CURRENT_BRANCH" || "$CURRENT_BRANCH" == "HEAD" ]]; then
  echo "Error: detached HEAD is not supported for auto_push." >&2
  exit 1
fi

if ! command -v openssl >/dev/null 2>&1; then
  echo "Error: openssl is required but not found." >&2
  exit 1
fi

if [[ -z "${AUTO_PUSH_ENCRYPT_KEY:-}" ]]; then
  echo "Error: AUTO_PUSH_ENCRYPT_KEY is required for encrypting process files." >&2
  exit 1
fi

normalize_tag_version() {
  local t="$1"
  t="${t#v}"
  echo "$t"
}

version_gt() {
  local a="$1"
  local b="$2"
  IFS='.' read -r a1 a2 a3 <<< "$a"
  IFS='.' read -r b1 b2 b3 <<< "$b"
  (( a1 > b1 )) && return 0
  (( a1 < b1 )) && return 1
  (( a2 > b2 )) && return 0
  (( a2 < b2 )) && return 1
  (( a3 > b3 )) && return 0
  return 1
}

NEW_TAG=""
if [[ -n "$NEW_VERSION" ]]; then
  LATEST_TAG="$(git tag --sort=-v:refname | head -n 1 || true)"
  if [[ -n "$LATEST_TAG" ]]; then
    LATEST_VER="$(normalize_tag_version "$LATEST_TAG")"
    if ! [[ "$LATEST_VER" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "Error: latest tag '$LATEST_TAG' is not semver-compatible." >&2
      exit 1
    fi
    if ! version_gt "$NEW_VERSION" "$LATEST_VER"; then
      echo "Error: new version ($NEW_VERSION) must be greater than latest tag ($LATEST_TAG)." >&2
      exit 1
    fi
  fi

  NEW_TAG="v$NEW_VERSION"
  if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
    echo "Error: tag '$NEW_TAG' already exists." >&2
    exit 1
  fi
fi

ENCRYPT_MARKER="__AUTO_PUSH_ENCRYPTED_V1__"
ENCRYPT_TARGETS=(
  "00_process/00_start.md"
  "00_process/01_setup.md"
  "00_process/02_pre_writing.md"
  "00_process/03_writing.md"
)

for f in "${ENCRYPT_TARGETS[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: encryption target not found: $f" >&2
    exit 1
  fi

  first_line="$(head -n 1 "$f" || true)"
  if [[ "$first_line" == "$ENCRYPT_MARKER" ]]; then
    echo "Skip encrypt (already encrypted): $f"
    continue
  fi

  tmp="${f}.enc.tmp"
  {
    echo "$ENCRYPT_MARKER"
    openssl enc -aes-256-cbc -pbkdf2 -salt -base64 \
      -pass env:AUTO_PUSH_ENCRYPT_KEY \
      -in "$f"
  } > "$tmp"
  mv "$tmp" "$f"
  echo "Encrypted: $f"
done

git add \
  README.md \
  "${ENCRYPT_TARGETS[@]}" \
  script/ \
  note/

if git diff --cached --quiet; then
  echo "Error: no staged changes for target files." >&2
  exit 1
fi

git commit -m "$COMMIT_MSG"
git push origin "$CURRENT_BRANCH"

if [[ -n "$NEW_TAG" ]]; then
  git tag "$NEW_TAG"
  git push origin "$NEW_TAG"
fi

echo "Done:"
echo "- branch: $CURRENT_BRANCH"
echo "- commit: $COMMIT_MSG"
if [[ -n "$NEW_TAG" ]]; then
  echo "- tag: $NEW_TAG"
else
  echo "- tag: (skipped)"
fi
