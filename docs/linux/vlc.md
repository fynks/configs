---
layout: doc
title: VLC Troubleshooting
description: Troubleshoot common VLC errors
---

If VLC shows codec errors (e.g., “codec not supported”), install the required plugins/codecs.

On Arch-based systems (pacman):
```bash
sudo pacman -S vlc-plugins-all
```

Notes:
- Restart VLC after installing plugins and try the file again.
