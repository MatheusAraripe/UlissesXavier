---
name: ux-profile
description: Build or update the project's UX profile (.claude/ux-profile.md) that the UlissesXavier evaluator reads before every run — scans the repository for signals about who uses the product, then asks the developer a few short, direct questions to fill what the code cannot tell. Use before the first UlissesXavier evaluation in a project, when the audience or the product changed, or when the user asks to set up or review the UX profile.
---

# UX profile — interview the developer

UlissesXavier evaluates a product through the eyes of its users, so it needs
to know who they are. Part of that is in the code; the rest only the
developer knows. This skill gets both, quickly, and writes
`.claude/ux-profile.md`.

Speak to the developer **in the language they are using**. Write the
profile in that language too.

## 1. Scan first (silently, cheaply)

Use Glob/Grep, not full reads. Look for:

- `README*`, `CLAUDE.md`, `docs/`, product or design documents, ADRs;
- `package.json` / `pyproject.toml` (name, description, keywords);
- routes and page names; sign-up form fields (they reveal what the product
  wants to know about its users); onboarding and landing copy;
  `i18n`/`locales` folders;
- analytics events, plan or pricing names, feature flags;
- existing personas, research notes, FAQ or support text;
- how the app runs locally (scripts, ports, `.env.example`) and whether
  there is a health endpoint;
- an existing `.claude/ux-profile.md` (then you are updating, not creating —
  show what you would change).

From that, form a hypothesis: product, main users, their tasks, device,
domain. Note which file each inference came from.

## 2. Ask — short and direct

Use **AskUserQuestion**, at most **two rounds of up to four questions**.
Ask **only what the scan did not answer**; for each question offer 2–4
options built from your hypothesis (the recommended one first), and the
user can always type their own. Keep each question to one line and each
option label to a few words.

The bank, in order of value:

1. **Who is the main user?** (role / profession / age range)
2. **Experience with this kind of product?** (first time · occasional ·
   daily power user)
3. **Main device?** (desktop · phone · tablet · mixed)
4. **The one task that must be effortless?**
5. **How often do they use it?** (daily · weekly · once)
6. **What is at stake for them, and in what state do they arrive?**
   (money · health · a work deadline · leisure; calm · rushed · anxious)
7. **Any constraint?** (accessibility, low-end devices, slow network,
   language, regulated domain)
8. **Which products do they already use for this?** (they will expect it to
   work like those — Jakob's law)
9. **What must the evaluator never touch?** (real accounts, paid APIs,
   destructive actions, emails sent)
10. **Test account** — only if the app has login: how will the evaluator
   get one? Options: *I'll give it in the chat when I call the evaluator* ·
   *Note the login here, the password in an environment variable* · *Skip
   screens behind login*. Record only the login (and the variable's name, if
   chosen) — never the password in the file, never a personal account.

Facts the scan usually answers — ask only if it did not: how the servers
start (commands, ports, health URL — and whether to evaluate the dev server
or a production build), how to log in (a test account or an already-open session; **never ask for a
personal password**), where design decisions and the backlog are recorded.

Before asking, show the hypothesis in two or three lines, so the developer
corrects it instead of starting from zero.

## 3. Write the profile

Write `.claude/ux-profile.md` with this structure. Mark anything still
inferred and unconfirmed with `(inferred — confirm)`.

~~~markdown
# UX profile — <product>

## Product
One paragraph: what it does, for whom, in which domain.

## Users and tasks
| Persona | Experience | Device | Frequency | Top tasks (concrete, in order) |
|---|---|---|---|---|

What is at stake for them and their usual state of mind: …
Known constraints: …
Reference products the users already know (Jakob's law): …

## How to reach the app
The evaluator starts and stops these itself (ux-serve skill); whatever is
already running is reused and left alone. Fix the ports.

```servers
api | backend | <command> --port 8000 | http://localhost:8000/health
web | .       | npm run dev -- --port 5173 --strictPort | http://localhost:5173/
```

- Dev server or production build (`vite preview`)? The dev server starts
  faster; only a production build gives representative load and
  interaction times.
## Test account
The evaluator uses only accounts the developer gives it — in the chat when
calling it, or here — and never creates one.
- Login: <e-mail or user> / "given in the chat"
- Password: "given in the chat" or the environment variable `UX_TEST_PASSWORD`
  — never written in this file
- The evaluation may create and change data in this account.
- Or: "none — the app has no login" / "skip screens behind login".

## Safety limits
- Real data: what is real and must not be deleted or edited.
- Destructive actions to avoid: …
- Paid or rate-limited calls (and the maximum per sweep): …
- Things the evaluator may create, and how to clean them up: …
- How to test destructive flows safely (e.g. intercept `fetch` and answer
  `DELETE` with a fake 204).

## Screens and flows to walk
Ordered list, with routes.

## Decisions and backlog
- Where the design decisions are recorded (files, sections).
- Where the open items / backlog live.
- Feedback folder (reports and PDFs, one subfolder per date and run):
  `feedback/`.

## Known quirks (not app defects)
~~~

## 4. Close

Tell the developer, in two or three lines: the path written, the personas
and top task captured, what is still marked as inferred, and that they can
now ask for an evaluation ("use the ulissesxavier agent to evaluate the
app", or with a focus: "only the checkout", "only mobile", "only what
changed in this branch").
