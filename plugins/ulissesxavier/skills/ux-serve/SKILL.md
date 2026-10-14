---
name: ux-serve
description: Starts the app's servers for a UlissesXavier evaluation and stops them afterwards — reuses whatever the developer already has running, starts only what is missing, waits until healthy, and at the end kills only the process trees it started, with logs kept outside the repository. Used by the ulissesxavier agent; also handy by hand ("start the app for the UX evaluation", "stop the evaluation servers").
---

# Servers for the evaluation

The evaluator should not depend on the developer leaving servers running,
and should leave the machine exactly as it found it.

```bash
bash "${CLAUDE_SKILL_DIR}/serve.sh" up      # before the evaluation
bash "${CLAUDE_SKILL_DIR}/serve.sh" down    # always at the end, also after a failure
bash "${CLAUDE_SKILL_DIR}/serve.sh" status
```

Run from the project root (the profile path is the optional second
argument, default `.claude/ux-profile.md`).

## The `servers` block in the profile

```servers
api | backend | uv run uvicorn app.main:app --port 8000 | http://localhost:8000/health
web | .       | npm run dev -- --port 5173 --strictPort | http://localhost:5173/
```

`name | folder (relative to the root) | command | health URL`, in start
order (the API before the frontend that calls it).

- **Fix the ports** (`--port … --strictPort` for Vite): a dev server that
  slides to the next free port would no longer match the health URL.
- **Development or production build.** A dev server serves unbundled
  modules and framework dev-mode code, so its load and interaction timings
  are not representative; Vite's own docs offer `vite preview` as "an easy
  way to check if the production build looks OK in your local environment"
  (vite.dev, "Deploying a Static Site — Testing the App Locally"). If the
  evaluation will report Core Web Vitals, prefer
  `npm run build && npx vite preview --port 4173 --strictPort` for the web
  line; otherwise the dev server is fine and starts faster — and the report
  must then say the timings come from a dev build.

## What the script guarantees

- A server whose health URL already answers is **reused and never stopped**
  — it is the developer's.
- What it starts, it records (PID, and on Windows the native PID) in a temp
  folder outside the repository, with its log; `down` kills the **whole
  tree** (`taskkill /T` on Windows, descendants via `pgrep -P` elsewhere),
  checks the URL stopped answering, and deletes the folder.
- A server that exits or is not healthy within 180 s (`UX_SERVE_TIMEOUT`)
  fails `up` with the last lines of its log; run `down` and report it —
  never "fix" the project to make it start.
- If an earlier evaluation was interrupted, `up` recognizes the servers it
  had started and `down` stops them then.
