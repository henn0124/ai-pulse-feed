#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE_STR="${1:-$(date +%Y-%m-%d)}"
OUT_DIR="$REPO_DIR/assets/images/$DATE_STR"
OUT_FILE="$OUT_DIR/hero.svg"
mkdir -p "$OUT_DIR"

hash=$(printf "%s" "$DATE_STR" | sha256sum | awk '{print $1}')
hex_byte() {
  local i="$1"
  local idx=$(( (i - 1) % 32 ))
  local pos=$(( idx * 2 ))
  printf "%d" "0x${hash:$pos:2}"
}
rand_range() {
  local i="$1" min="$2" max="$3"
  local b; b=$(hex_byte "$i")
  echo $(( min + (b % (max - min + 1)) ))
}
pick_color() {
  local n="$1"
  case $(( n % 3 )) in
    0) echo "$a1" ;;
    1) echo "$a2" ;;
    *) echo "$a3" ;;
  esac
}

palettes=(
  "#0b1020 #1e3a8a #22d3ee #a78bfa #f0f9ff"
  "#111827 #0f766e #34d399 #93c5fd #eef2ff"
  "#1f2937 #7c3aed #22c55e #f59e0b #f8fafc"
  "#0f172a #1d4ed8 #06b6d4 #f97316 #ecfeff"
  "#0b132b #1c2541 #5bc0be #6fffe9 #f8fafc"
)
pidx=$(rand_range 1 0 4)
IFS=' ' read -r bg1 bg2 a1 a2 a3 <<< "${palettes[$pidx]}"

c1x=$(rand_range 2 10 90); c1y=$(rand_range 3 10 90); c1r=$(rand_range 4 180 460)
c2x=$(rand_range 5 10 90); c2y=$(rand_range 6 10 90); c2r=$(rand_range 7 160 420)
c3x=$(rand_range 8 10 90); c3y=$(rand_range 9 10 90); c3r=$(rand_range 10 140 380)
line_count=$(rand_range 11 14 28)
poly_count=$(rand_range 12 6 14)

cat > "$OUT_FILE" <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="900" viewBox="0 0 1600 900" role="img" aria-label="Abstract daily hero for $DATE_STR">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="$bg1"/>
      <stop offset="100%" stop-color="$bg2"/>
    </linearGradient>
    <filter id="blur" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="38"/>
    </filter>
  </defs>
  <rect width="1600" height="900" fill="url(#bg)"/>
  <circle cx="$((c1x*16))" cy="$((c1y*9))" r="$c1r" fill="$a1" opacity="0.28" filter="url(#blur)"/>
  <circle cx="$((c2x*16))" cy="$((c2y*9))" r="$c2r" fill="$a2" opacity="0.24" filter="url(#blur)"/>
  <circle cx="$((c3x*16))" cy="$((c3y*9))" r="$c3r" fill="$a3" opacity="0.22" filter="url(#blur)"/>
SVG

for i in $(seq 1 "$line_count"); do
  x1=$(rand_range $((20+i)) 0 1600)
  y1=$(rand_range $((40+i)) 0 900)
  x2=$(rand_range $((60+i)) 0 1600)
  y2=$(rand_range $((80+i)) 0 900)
  w=$(rand_range $((100+i)) 1 4)
  op=$(rand_range $((120+i)) 10 35)
  col=$(pick_color "$i")
  echo "  <line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" stroke=\"$col\" stroke-opacity=\"0.$op\" stroke-width=\"$w\"/>" >> "$OUT_FILE"
done

for i in $(seq 1 "$poly_count"); do
  x1=$(rand_range $((160+i)) 0 1600); y1=$(rand_range $((180+i)) 0 900)
  x2=$(rand_range $((200+i)) 0 1600); y2=$(rand_range $((220+i)) 0 900)
  x3=$(rand_range $((240+i)) 0 1600); y3=$(rand_range $((260+i)) 0 900)
  op=$(rand_range $((280+i)) 8 20)
  col=$(pick_color $((i+1)))
  echo "  <polygon points=\"$x1,$y1 $x2,$y2 $x3,$y3\" fill=\"$col\" fill-opacity=\"0.$op\"/>" >> "$OUT_FILE"
done

echo "</svg>" >> "$OUT_FILE"

grep -qi "<text\b" "$OUT_FILE" && { echo "❌ Generated SVG contains text node"; exit 1; }
echo "$OUT_FILE"
