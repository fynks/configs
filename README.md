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
- `scripts/README.md` — the former Arch/EndeavourOS setup script, converted into copyable sections.

## Setup guide

The old `setup.sh` has been replaced by [`scripts/README.md`](scripts/README.md), with every section available as a copyable code block. The same guide is published on the site at [Arch Setup Script](docs/linux/setup-script.md).
