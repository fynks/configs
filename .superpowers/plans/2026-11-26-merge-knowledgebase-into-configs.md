# Merge knowledgebase into configs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `/home/ali/Github/configs` into the single repo: VitePress site from knowledgebase, corrected links, Bun toolchain on VitePress 2 alpha, and `scripts/README.md` replacing `setup.sh`.

**Architecture:** Copy the knowledgebase `docs/` tree and `package.json` to the configs repo root, leaving `backups/` and `browsers/` in place. Edit the VitePress config and guide content in place so the site represents the configs repo. Convert the 957-line setup script into a 19-section Markdown guide, delete the script, then verify with a real VitePress build and a raw-asset link audit.

**Tech Stack:** VitePress `2.0.0-alpha.21` (npm `next`), Vue `^3.5.46`, PostCSS `^8.5.33`, Bun `1.4.5`, Git.

**Spec:** `.superpowers/specs/2026-11-26-merge-knowledgebase-into-configs-design.md`

**Plan location note:** plans live in `.superpowers/plans/` instead of `docs/superpowers/plans/` because `docs/` is the published VitePress root.

## Global Constraints

- Target repo directory is exactly `/home/ali/Github/configs`; `fynks/knowledgebase` is left untouched locally and on GitHub.
- `vitepress` must be pinned to exact `2.0.0-alpha.21`; other direct JS deps at latest stable; `bun` 1.4.5 is the package manager and `bun.lock` is committed.
- Site metadata and text are rebranded to Configs; existing `logo.svg`, `favicon.svg` and `favicon.ico` artwork are reused unchanged.
- Every `raw.githubusercontent.com/fynks/configs/...` URL must point to a file that exists in this repo.
- `scripts/setup.sh` is deleted; `scripts/README.md` contains all 19 sections, each as one copyable `bash` code block, with the shebang and `set -euo pipefail` at the top of the Configuration block.
- `bun run docs:build` must succeed; `docs/.vitepress/dist` and `docs/.vitepress/cache` stay ignored.

## Review Focus

- Stale asset paths: a `raw.githubusercontent.com/fynks/configs/...` link that points at a path not in the repo (e.g. the old `system/backups/` prefix) must be caught — Task 4 audits every URL against local files.
- VitePress 2 alpha config drift: an option valid in v1 but rejected/ignored in the alpha must surface — Task 3 runs a real `docs:build`.
- Script reconstruction loss: dropping the shebang/strict-mode lines or a section must not pass — Task 5 asserts 19 `## Section:` headings, 19+ `bash` blocks, and the preamble inside the first block.
- Missing PWA icons: a manifest referencing nonexistent PNG files must not pass — Task 7 asserts each declared icon exists.
- Stale script references: docs still telling users to run `./setup.sh` must not pass — Task 4 greps for the old invocation.

---

### Task 1: Copy site scaffolding into configs

**Files:**
- Create: `docs/` (full tree from knowledgebase), `package.json`
- Modify: `.gitignore`

**Interfaces:**
- Consumes: `/home/ali/Github/knowledgebase/docs/**`, `/home/ali/Github/knowledgebase/package.json`
- Produces: `docs/` site root at configs repo root, `package.json` ready for dependency edits

- [ ] **Step 1: Copy the site tree and package manifest**

```bash
cd /home/ali/Github/configs
cp -R /home/ali/Github/knowledgebase/docs ./docs
cp /home/ali/Github/knowledgebase/package.json ./package.json
```

- [ ] **Step 2: Merge ignore rules**

Replace `.gitignore` with the union of both repos' rules: `node_modules`, `pnpm-lock.yaml`, `retype.manifest`, `docs/.vitepress/dist`, `docs/.vitepress/cache`, `docs/apps.md`, `docs/stats.md`.

- [ ] **Step 3: Verify the copy**

Run: `find docs -type f | sort`
Expected: includes `docs/index.md`, `docs/.vitepress/config.mjs`, `docs/.vitepress/theme/index.js`, `docs/.vitepress/theme/style.css`, `docs/public/{favicon.ico,favicon.svg,images/logo.svg,site.webmanifest}` and all 10 guide pages.

- [ ] **Step 4: Commit**

```bash
git add docs package.json .gitignore
git commit -m "feat: bring VitePress site scaffolding into configs"
```

### Task 2: Install the Bun toolchain

**Files:**
- Modify: `package.json`
- Create: `bun.lock`

**Interfaces:**
- Consumes: `package.json` from Task 1
- Produces: `bun.lock`, pinned dependency versions used by all later build steps

- [ ] **Step 1: Pin dependencies**

In `package.json`: set `"name": "configs"`, keep the three `docs:*` scripts, and set `devDependencies` to `"vitepress": "2.0.0-alpha.21"`, `"vue": "^3.5.46"`, `"postcss": "^8.5.33"`. Update description and repository URL to the configs repo.

- [ ] **Step 2: Install with Bun**

Run: `bun install`
Expected: `bun.lock` created, no peer-dependency errors.

- [ ] **Step 3: Verify installed versions**

Run: `bun pm ls --all | grep -E 'vitepress@|vue@|postcss@'`
Expected: VitePress `2.0.0-alpha.21`, Vue `3.5.46`, PostCSS `8.5.33`.

- [ ] **Step 4: Commit**

```bash
git add package.json bun.lock
git commit -m "chore: pin VitePress alpha and stable deps with bun"
```

### Task 3: Rebrand VitePress config and verify the alpha build

**Files:**
- Modify: `docs/.vitepress/config.mjs`

**Interfaces:**
- Consumes: `docs/.vitepress/config.mjs` from Task 1, installed alpha from Task 2
- Produces: site title/nav/sidebar used by Tasks 4–7, build-verified config

- [ ] **Step 1: Update site metadata**

Set `title: 'Fynks Configs'`, a description naming configs/guides, og/twitter title and description matching it, and `apple-mobile-web-app-title: 'Configs'`. Keep `lang`, `ignoreDeadLinks`, `cleanUrls`, `lastUpdated`, `head` favicon/manifest links, local search options, outline, footer copyright, and the existing brand CSS.

- [ ] **Step 2: Add the setup-script entry**

Add `{ text: 'Arch Setup Script', link: '/linux/setup-script' }` to the Linux nav items and to the Linux sidebar items (Task 6 creates the target page). Footer message becomes `Personal configs & knowledge base`.

- [ ] **Step 3: Verify the alpha build**

Run: `bun run docs:build`
Expected: exit 0. If the alpha reports an unknown/renamed config key, fix only that key and re-run until it exits 0.

- [ ] **Step 4: Commit**

```bash
git add docs/.vitepress/config.mjs
git commit -m "feat: brand the VitePress site as Fynks Configs"
```

### Task 4: Correct content paths and stale script references

**Files:**
- Modify: `docs/jdownloader2.md`, `docs/linux/Setup.md`, `docs/browsers.md`

**Interfaces:**
- Consumes: site config nav from Task 3
- Produces: guides whose asset links resolve and no longer reference the deleted script

- [ ] **Step 1: Fix the broken JD2 backup path**

In `docs/jdownloader2.md`, replace `system/backups/jdownloader2_backup.jd2backup` with `backups/jdownloader2_backup.jd2backup`.

- [ ] **Step 2: Replace the stale script snippet**

In `docs/linux/Setup.md`, replace the `git clone ... && sudo ./setup.sh` block with a short note linking to `/linux/setup-script` and to `https://github.com/fynks/configs/blob/main/scripts/README.md`. Keep the rest of the page (mirrors, Chaotic AUR, KDE shortcuts, boot time, GPG) unchanged.

- [ ] **Step 3: Normalise other config-asset links**

For `policies.json`, `u_block_origin_configs.txt`, `kde-shortcuts.kksrc`, `config.fish` and the JD2 backup, use `https://raw.githubusercontent.com/fynks/configs/refs/heads/main/<path>` exactly.

- [ ] **Step 4: Audit every raw config URL against local files**

Run:
```bash
cd /home/ali/Github/configs
grep -rhoE --include='*.md' 'https://raw\.githubusercontent\.com/fynks/configs/[^ )"]+' docs scripts README.md 2>/dev/null \
  | sed -E 's#https://raw\.githubusercontent\.com/fynks/configs/(refs/heads/main|main)/##' \
  | sort -u | while read -r p; do test -e "$p" && echo "OK $p" || echo "MISSING $p"; done
```
Expected: every line starts `OK`; no `MISSING`.

- [ ] **Step 5: Confirm no stale script invocation remains**

Run: `grep -rn --include='*.md' 'setup\.sh' docs || true` (source only; generated `dist/` keeps stale pre-fix text)
Expected: no `./setup.sh` invocation (only prose explaining the guide may remain).

- [ ] **Step 6: Commit**

```bash
git add docs/jdownloader2.md docs/linux/Setup.md docs/browsers.md
git commit -m "fix: correct config asset links and setup guide references"
```

### Task 5: Convert setup.sh into scripts/README.md

**Files:**
- Delete: `scripts/setup.sh`
- Create: `scripts/README.md`

**Interfaces:**
- Consumes: `scripts/setup.sh` (957 lines, 19 `# Section:` markers) before deletion
- Produces: the canonical copyable setup guide; consumed by Task 6

- [ ] **Step 1: Write the README**

Create `scripts/README.md` with a title, a 3-line overview, a short "Usage" section, then one `## Section: <Name>` per section in the script's original order — Configuration, Core Functions, UI Elements, Cleanup, Validation, Username Detection, Package Management, Automatic Setup, Welcome and Help, Main Menu, Setup Functions, Necessary Packages, Disable Services, Fish Configuration, Optional Packages, Firefox Configuration, Summary, Exit, Main Execution. Under each heading, write 1–3 sentences explaining what that section does, followed by one ` ```bash ` fenced block containing that section's code verbatim. Put `#!/usr/bin/env bash` and `set -euo pipefail` at the top of the Configuration block. Use ` ``` ` only for code copied from the script so every block is directly copyable.

- [ ] **Step 2: Verify section and block coverage**

Run:
```bash
cd /home/ali/Github/configs
echo "sections: $(grep -c '^## Section:' scripts/README.md)"
echo "bash blocks: $(grep -c '^```bash' scripts/README.md)"
head -n 8 scripts/README.md
grep -n 'set -euo pipefail' scripts/README.md
```
Expected: `sections: 19`, `bash blocks: 19` or more, and the shebang plus `set -euo pipefail` inside the first bash block.

- [ ] **Step 3: Remove the script**

Run: `git rm scripts/setup.sh`
Expected: file removed from worktree and index.

- [ ] **Step 4: Commit**

```bash
git add scripts/README.md
git commit -m "docs: replace setup.sh with copyable section-by-section README"
```

### Task 6: Publish the setup guide on the site

**Files:**
- Create: `docs/linux/setup-script.md`

**Interfaces:**
- Consumes: `scripts/README.md` from Task 5, nav entry from Task 3
- Produces: `/linux/setup-script` page matching the nav link

- [ ] **Step 1: Write the site page**

Create `docs/linux/setup-script.md` with frontmatter (`layout: doc`, `title: Arch Setup Script`, short description), a link to `https://github.com/fynks/configs/blob/main/scripts/README.md`, then the same 19 sections and copyable code blocks as `scripts/README.md`, in the same order.

- [ ] **Step 2: Verify parity with the README**

Run:
```bash
cd /home/ali/Github/configs
diff <(grep '^## Section:' scripts/README.md) <(grep '^## Section:' docs/linux/setup-script.md)
echo "site sections: $(grep -c '^## Section:' docs/linux/setup-script.md)"
```
Expected: empty diff, `site sections: 19`.

- [ ] **Step 3: Verify the build resolves the new nav link**

Run: `bun run docs:build`
Expected: exit 0 with no dead-link warning for `/linux/setup-script`.

- [ ] **Step 4: Commit**

```bash
git add docs/linux/setup-script.md
git commit -m "docs: publish the Arch setup guide on the site"
```

### Task 7: Merge the root README and fix the web manifest

**Files:**
- Delete: `readme.md`
- Create: `README.md`
- Modify: `docs/public/site.webmanifest`

**Interfaces:**
- Consumes: merged repo layout from Tasks 1–6
- Produces: single root README and a manifest whose icons exist

- [ ] **Step 1: Write the root README**

Replace `readme.md` with `README.md` containing: what the repo holds, a link to the live site and the source repo, quick start (`bun install`, `bun run docs:dev`, `bun run docs:build`), a short repo layout (`docs/`, `backups/`, `browsers/`, `scripts/README.md`), and a pointer to the setup guide.

- [ ] **Step 2: Fix the manifest**

In `docs/public/site.webmanifest`: set `name` and `short_name` to `Configs`, keep the existing theme/background colours, remove the two nonexistent `web-app-manifest-*.png` icon entries, and declare one icon `{ "src": "/favicon.svg", "sizes": "any", "type": "image/svg+xml" }`.

- [ ] **Step 3: Verify referenced assets and branding**

Run:
```bash
cd /home/ali/Github/configs
grep -oE '"src": "[^"]+"' docs/public/site.webmanifest | sed 's/.*"\(.*\)"/\1/' | while read -r p; do test -e "docs/public${p}" && echo "OK $p" || echo "MISSING $p"; done
grep -rni 'knowledgebase' docs/.vitepress/config.mjs docs/public/site.webmanifest README.md || true
```
Expected: `OK /favicon.svg` only; no KnowledgeBase strings in the checked files.

- [ ] **Step 4: Commit**

```bash
git add -A README.md readme.md docs/public/site.webmanifest
git commit -m "docs: merge root README and fix web manifest"
```

### Task 8: Final verification

**Files:** none (fixups only if a verification fails)

**Interfaces:**
- Consumes: all prior tasks
- Produces: a clean, buildable, link-consistent repo

- [ ] **Step 1: Full build**

Run: `bun run docs:build`
Expected: exit 0.

- [ ] **Step 2: Final link audit**

Re-run the Task 4 Step 4 URL audit and confirm no `MISSING`.

- [ ] **Step 3: Branch state**

Run: `git status --short && git log --oneline -8`
Expected: clean worktree and the seven feature commits.

- [ ] **Step 4: Commit any fixups**

If a verification step failed and was fixed, commit with `git add -A && git commit -m "fix: final verification fixes"`. Otherwise no commit needed.
