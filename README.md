# Configs

Personal configuration files, setup guides and the VitePress website that documents them all in one place.

- **Live site:** [fynks.netlify.app](https://fynks.netlify.app)
- **Source:** [github.com/fynks/configs](https://github.com/fynks/configs)

## Quick start

```bash
bun install
bun run docs:dev      # local site with hot reload
bun run docs:build    # production build into docs/.vitepress/dist
bun run docs:preview  # preview the production build
```

Bun 1.4.5 is the package manager; the lockfile is `bun.lock`. The site uses VitePress 2 alpha.

## Repo layout

- `docs/` — VitePress site source: guides for Linux, Windows, browsers, Android and tools.
- `backups/` — exported config files (Fish shell, pacman, KDE shortcuts, JDownloader backup).
- `browsers/` — browser policies and extension configs.
- `docs/linux/Setup.md` — the Arch/EndeavourOS setup guide, with each step as a paste-and-run command.

## Setup guide

See [`docs/linux/Setup.md`](docs/linux/Setup.md), also published on the site at [Setup](https://fynks.netlify.app/linux/Setup).
