---
layout: doc
title: Git
---
# Git Guide

## Initial Setup
1. Set you github username:
```bash
git config --global user.name "John Doe"
```
2. Set your [github email](https://github.com/settings/emails):

```bash
git config --global user.email "johndoe@email.com"
```
## Fix Commit Author
If you have already committed and even after setting up the `username` and `email` you can't commit, run this from the local repo itself:
```bash
# From within your repository
git commit --amend --reset-author

