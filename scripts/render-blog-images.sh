#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMG_ROOT="$ROOT_DIR/assets/images"

if [[ ! -d "$IMG_ROOT" ]]; then
  echo "No assets/images directory found; skipping render step."
  exit 0
fi

if command -v rsvg-convert >/dev/null 2>&1; then
  RENDERER="rsvg-convert"
elif command -v convert >/dev/null 2>&1; then
  RENDERER="convert"
elif command -v magick >/dev/null 2>&1; then
  RENDERER="magick"
else
  echo "No SVG renderer available (rsvg-convert/convert/magick)."
  exit 1
fi

echo "Using renderer: $RENDERER"

count=0
while IFS= read -r -d '' svg; do
  png="${svg%.svg}.png"

  case "$RENDERER" in
    rsvg-convert)
      rsvg-convert -o "$png" "$svg"
      ;;
    convert)
      convert "$svg" "$png"
      ;;
    magick)
      magick "$svg" "$png"
      ;;
  esac

  count=$((count + 1))
  echo "Rendered: ${svg#$ROOT_DIR/} -> ${png#$ROOT_DIR/}"
done < <(find "$IMG_ROOT" -type f -name '*.svg' -print0)

echo "Rendered $count image(s)."
