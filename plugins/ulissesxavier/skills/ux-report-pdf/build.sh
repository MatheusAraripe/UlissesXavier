#!/usr/bin/env bash
# UlissesXavier — builds the designed PDF from a markdown report.
#
#   bash build.sh <report.md> [--proof]
#
# Writes <report>.pdf next to the markdown and prints one short summary:
# page count, render errors (with the first messages) and, with --proof, a
# screenshot of every chart in a temporary folder (for the agent only). The
# HTML it renders from is temporary too: it is built next to the markdown,
# so relative image paths resolve, and deleted at the end. Only when no
# Chromium browser exists is it kept, as <report>.html, to print by hand.
# The markdown is the only thing the agent writes; nothing here needs editing.
set -euo pipefail

MD="${1:?usage: build.sh <report.md> [--proof]}"
PROOF="${2:-}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$MD" ] || { echo "report not found: $MD" >&2; exit 1; }
BASE="${MD%.md}"
PDF="$BASE.pdf"
HTML="$(dirname "$MD")/.ulissesxavier-build-$.html"
PNG="${TMPDIR:-/tmp}/ulissesxavier-proof-$(basename "$BASE").png"
trap 'rm -f "$HTML"' EXIT

# Absolute path in the form the browser understands (C:/… on Windows).
abs() { local d; d="$(cd "$(dirname "$1")" && (pwd -W 2>/dev/null || pwd))"; echo "$d/$(basename "$1")"; }
url() { echo "file:///$(abs "$1" | sed -e 's#^/##' -e 's/ /%20/g')"; }

# 1. Assemble: the markdown goes into the template. "<script" and
#    "</script" are neutralized so the report cannot close the script block
#    that holds it; the renderer restores them.
TMP="$(mktemp)"
sed -e 's#<\(/\{0,1\}\)\([sS][cC][rR][iI][pP][tT]\)#<\\\1\2#g' "$MD" > "$TMP"
awk -v f="$TMP" '/^@@REPORT@@$/ { while ((getline l < f) > 0) print l; next } { print }' "$HERE/template.html" > "$HTML"
rm -f "$TMP"

# 2. Find Chrome, Edge or Chromium. Never run `chrome --version` on Windows:
#    it opens a window in the user's browser.
LAD=""
if [ -n "${LOCALAPPDATA:-}" ]; then LAD="$(command -v cygpath >/dev/null 2>&1 && cygpath -u "$LOCALAPPDATA" || echo "$LOCALAPPDATA")"; fi
BROWSER=""
for c in "${CHROME:-}" \
  "/c/Program Files/Google/Chrome/Application/chrome.exe" \
  "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
  "$LAD/Google/Chrome/Application/chrome.exe" \
  "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
  "/c/Program Files/Microsoft/Edge/Application/msedge.exe" \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
  if [ -n "$c" ] && [ -f "$c" ]; then BROWSER="$c"; break; fi
done
if [ -z "$BROWSER" ]; then
  for n in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge; do
    if command -v "$n" >/dev/null 2>&1; then BROWSER="$(command -v "$n")"; break; fi
  done
fi
if [ -z "$BROWSER" ]; then
  trap - EXIT; mv "$HTML" "$BASE.html"; HTML="$BASE.html"
  echo "html: $(abs "$HTML")"
  echo "pdf: not generated — no Chrome, Edge or Chromium found."
  echo "     Open the HTML in a Chromium browser, Print > Save as PDF, margins Default, Background graphics on."
  exit 0
fi

# 3. Render with a throwaway profile, away from the user's own browser.
PROFILE="$(mktemp -d)"
PROFILE_ARG="$(command -v cygpath >/dev/null 2>&1 && cygpath -m "$PROFILE" || echo "$PROFILE")"
run() { "$BROWSER" --headless=new --disable-gpu --no-first-run --no-default-browser-check --user-data-dir="$PROFILE_ARG" "$@" 2>/dev/null; }

run --no-pdf-header-footer --generate-pdf-document-outline --print-to-pdf="$(abs "$PDF")" "$(url "$HTML")" >/dev/null || true
DOM="$(run --dump-dom "$(url "$HTML")" || true)"
ERRORS="$(printf '%s' "$DOM" | grep -o 'data-render-errors="[0-9]*"' | grep -o '[0-9][0-9]*' | head -1 || true)"
MESSAGES="$(printf '%s' "$DOM" | grep -o 'class="render-error">[^<]*' | sed 's/^[^>]*>//' | head -5 || true)"
if [ -n "$PROOF" ]; then
  run --hide-scrollbars --window-size=760,4200 --screenshot="$(abs "$PNG")" "$(url "$HTML")#proof" >/dev/null || true
fi
rm -rf "$PROFILE"

# 4. Summary.
PAGES="?"
if [ -f "$PDF" ]; then
  PAGES="$( (grep -a -o '/Type */Page\b' "$PDF" || true) | wc -l | tr -d ' ')"
fi
if [ -f "$PDF" ]; then echo "pdf: $(abs "$PDF") ($PAGES pages)"; else echo "pdf: FAILED"; fi
echo "render errors: ${ERRORS:-unknown}"
[ -n "$MESSAGES" ] && printf '%s\n' "$MESSAGES" | sed 's/^/  - /'
[ -n "$PROOF" ] && [ -f "$PNG" ] && echo "proof: $(abs "$PNG")"
exit 0
