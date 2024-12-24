---
title: Git
icon: git-branch
---
# Git Guide

### Fixing Git after a fresh install
1. Set you github username:
```bash
git config --global user.name "John Doe"
```
2. Set your github email:

(Get it from https://github.com/settings/emails)
```bash
git config --global user.email "johndoe@email.com"
```

1. If you have already committed and even after setting up the `username` and `email` you can't commit, run this from the local repo itself:
```bash
git commit --amend --reset-author
```
