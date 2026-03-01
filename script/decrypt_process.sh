#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash script/decrypt_process.sh "your-secret"
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

AUTO_PUSH_ENCRYPT_KEY="$1"
ENCRYPT_MARKER="__AUTO_PUSH_ENCRYPTED_V1__"

TARGETS=(
  "00_process/00_start.md"
  "00_process/01_setup.md"
  "00_process/02_pre_writing.md"
  "00_process/03_writing.md"
)

if ! command -v openssl >/dev/null 2>&1; then
  echo "Error: openssl is required but not found." >&2
  exit 1
fi

for f in "${TARGETS[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: target file not found: $f" >&2
    exit 1
  fi

  first_line="$(head -n 1 "$f" || true)"
  if [[ "$first_line" != "$ENCRYPT_MARKER" ]]; then
    echo "Skip decrypt (not encrypted by auto_push marker): $f"
    continue
  fi

  tmp="${f}.dec.tmp"
  if ! tail -n +2 "$f" | openssl enc -d -aes-256-cbc -pbkdf2 -a -pass env:AUTO_PUSH_ENCRYPT_KEY > "$tmp"; then
    rm -f "$tmp"
    echo "Error: failed to decrypt $f (wrong secret or corrupted file)." >&2
    exit 1
  fi

  mv "$tmp" "$f"
  echo "Decrypted: $f"
done

echo "Done."
