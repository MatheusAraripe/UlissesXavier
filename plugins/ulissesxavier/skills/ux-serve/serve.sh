#!/usr/bin/env bash
# UlissesXavier — starts the app's servers for an evaluation and stops them
# afterwards, leaving the machine as it was.
#
#   bash serve.sh up     [profile]   start what is not running, wait until healthy
#   bash serve.sh down   [profile]   stop only what `up` started (whole process tree)
#   bash serve.sh status [profile]
#
# The servers come from a fenced block in the profile (default
# .claude/ux-profile.md), one per line:  name | cwd | command | health URL
#
#   ```servers
#   api | backend | uv run uvicorn app.main:app --port 8000 | http://localhost:8000/health
#   web | .       | npm run dev -- --port 5173 --strictPort | http://localhost:5173/
#   ```
#
# A server whose health URL already answers is reused and never stopped:
# it belongs to the developer. Logs and PIDs live in a temp folder outside
# the repository, removed by `down`.
set -uo pipefail

ACTION="${1:-status}"
PROFILE="${2:-.claude/ux-profile.md}"
TIMEOUT="${UX_SERVE_TIMEOUT:-180}"
ROOT="$(pwd)"
KEY="$(printf '%s' "$ROOT" | cksum | cut -d' ' -f1)"
STATE="${TMPDIR:-/tmp}/ulissesxavier-$KEY"

[ -f "$PROFILE" ] || { echo "profile not found: $PROFILE" >&2; exit 1; }
SERVERS="$(awk '/^```servers[[:space:]]*$/{on=1; next} on && /^```/{exit} on && NF' "$PROFILE")"
[ -n "$SERVERS" ] || { echo "no \`\`\`servers block in $PROFILE — add one (see the ux-serve skill)" >&2; exit 1; }

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; echo "${s%"${s##*[![:space:]]}"}"; }
alive_url() { [ "$(curl -s -o /dev/null -m 3 -w '%{http_code}' "$1" 2>/dev/null)" != "000" ]; }

# Every descendant of a PID (Linux and macOS), deepest first.
tree() { local c; for c in $(pgrep -P "$1" 2>/dev/null); do tree "$c"; echo "$c"; done; }
stop_tree() {
  local pid="$1" winpid="${2:-}"
  if [ -n "$winpid" ] && command -v taskkill >/dev/null 2>&1; then
    taskkill //F //T //PID "$winpid" >/dev/null 2>&1 || true
  fi
  if kill -0 "$pid" 2>/dev/null; then
    local all; all="$(tree "$pid") $pid"
    kill -TERM $all 2>/dev/null || true
    sleep 2
    kill -KILL $all 2>/dev/null || true
  fi
}

# Port of a URL, and the PIDs listening on it. A server is only started on a
# port nobody answered on, so whatever listens there at `down` is ours —
# this catches children that left the process tree (npm on Windows does).
port_of() {
  local p; p="$(printf '%s' "$1" | sed -n 's#^[a-z]*://[^/:]*:\([0-9][0-9]*\).*#\1#p')"
  [ -n "$p" ] && echo "$p" || { case "$1" in https*) echo 443 ;; *) echo 80 ;; esac; }
}
listeners() {
  if command -v netstat >/dev/null 2>&1 && command -v taskkill >/dev/null 2>&1; then
    netstat -ano 2>/dev/null | awk -v p=":$1" '$0 ~ /LISTEN/ && $2 ~ p"$" {print $NF}' | sort -u
  elif command -v lsof >/dev/null 2>&1; then
    lsof -nP -iTCP:"$1" -sTCP:LISTEN -t 2>/dev/null | sort -u
  fi
}
stop_port() {
  local p
  for p in $(listeners "$1"); do
    [ "$p" = 0 ] && continue
    if command -v taskkill >/dev/null 2>&1; then taskkill //F //T //PID "$p" >/dev/null 2>&1 || true
    else kill -TERM "$p" 2>/dev/null; sleep 1; kill -KILL "$p" 2>/dev/null || true; fi
  done
}

case "$ACTION" in
up)
  mkdir -p "$STATE"
  FAILED=0
  while IFS='|' read -r name cwd cmd url; do
    name="$(trim "$name")"; cwd="$(trim "$cwd")"; cmd="$(trim "$cmd")"; url="$(trim "$url")"
    [ -n "$name" ] || continue
    if alive_url "$url"; then
      if [ -f "$STATE/$name.pid" ]; then echo "$name: running (started by an earlier evaluation; will stop at down)"
      else echo "$name: already running — reused, will NOT be stopped"; fi
      continue
    fi
    ( cd "$ROOT/$cwd" && exec nohup bash -c "$cmd" > "$STATE/$name.log" 2>&1 ) &
    pid=$!
    echo "$pid" > "$STATE/$name.pid"
    [ -r "/proc/$pid/winpid" ] && cat "/proc/$pid/winpid" > "$STATE/$name.winpid"
    printf '%s: starting (%s) ' "$name" "$cmd"
    waited=0
    until alive_url "$url"; do
      if ! kill -0 "$pid" 2>/dev/null; then echo "— exited"; tail -n 15 "$STATE/$name.log" | sed 's/^/    /'; FAILED=1; break; fi
      if [ "$waited" -ge "$TIMEOUT" ]; then echo "— not healthy after ${TIMEOUT}s"; tail -n 15 "$STATE/$name.log" | sed 's/^/    /'; FAILED=1; break; fi
      sleep 2; waited=$((waited + 2))
    done
    alive_url "$url" && echo "— healthy after ${waited}s"
  done <<< "$SERVERS"
  [ "$FAILED" = 0 ] || { echo "some server failed: run 'serve.sh down' and report it"; exit 1; }
  ;;
down)
  [ -d "$STATE" ] || { echo "nothing started by UlissesXavier here"; exit 0; }
  # reverse start order: the frontend before the API it calls
  while IFS='|' read -r name cwd cmd url; do
    name="$(trim "$name")"; url="$(trim "$url")"
    [ -f "$STATE/$name.pid" ] || continue
    stop_tree "$(cat "$STATE/$name.pid")" "$(cat "$STATE/$name.winpid" 2>/dev/null || true)"
    stop_port "$(port_of "$url")"
    sleep 1
    if alive_url "$url"; then echo "WARNING: $name still answers at $url — check for an orphan process"
    else echo "$name: stopped"; fi
  done <<< "$(printf '%s\n' "$SERVERS" | awk '{l[NR]=$0} END {for (i=NR; i>0; i--) print l[i]}')"
  rm -rf "$STATE"
  ;;
status)
  while IFS='|' read -r name cwd cmd url; do
    name="$(trim "$name")"; url="$(trim "$url")"
    [ -n "$name" ] || continue
    owner="developer"; [ -f "$STATE/$name.pid" ] && owner="UlissesXavier"
    if alive_url "$url"; then echo "$name: up ($owner) $url"; else echo "$name: down $url"; fi
  done <<< "$SERVERS"
  ;;
*) echo "usage: serve.sh up|down|status [profile]" >&2; exit 2 ;;
esac
