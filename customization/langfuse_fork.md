# 🛠️ Setup Guide (Not required as part of users of this repository 
https://github.com/macayaven/langfuse-fork)

T## 🔐 One-Time Setup (Fork Initialization)

Only the maintainer should run this:

```bash
make bootstrap
```

This will:
- Clone the upstream Langfuse repo
- Rename `origin` and `upstream` appropriately
- Prevent accidental push to `upstream`
- Push code to your personal fork
- Copy the `docker-compose.override.yml`

📁 Script: `customization/scripts/housekeeping/bootstrap.sh`

---

## 🔁 Sync with Upstream

### Check if your fork is behind:
```bash
make check
```

### Merge changes from Langfuse upstream:
```bash
make update
```

---

## ✅ GitHub CLI (gh) setup

If using the GitHub CLI:
```bash
gh repo set-default macayaven/langfuse-fork
```
This ensures `gh pr`, `gh issue` etc. target your fork, not Langfuse’s upstream.

---

## ✅ Remote Configuration (Best Practice)

```bash
git remote -v
```
Should show:
```
origin    https://github.com/macayaven/langfuse-fork.git (fetch)
origin    https://github.com/macayaven/langfuse-fork.git (push)
upstream  https://github.com/langfuse/langfuse.git (fetch)
upstream  no_push (push)
```

If needed:
```bash
git remote set-url origin https://github.com/macayaven/langfuse-fork.git
git remote add upstream https://github.com/langfuse/langfuse.git
git remote set-url --push upstream no_push
```

---

## 🧪 CI / Automation

This repo include a GitHub Action to lint shell scripts and Docker Compose of the `customization/` folder:
- `.github/workflows/customization-lint.yml` – Lints shell scripts and Compose config

I still need to figure out the best way to maintain this fork and keep it in sync with upstream.

---

## 🧼 Linters (Shell + Docker Compose)

Install linters using:
```bash
make install-linters
```
This installs:
- `shellcheck` via apt
- `shfmt` downloaded from GitHub release (auto-detects platform)

Run lint checks:
```bash
make lint
```
This will check:
- Bash files in `customization/`
- Formatting with `shfmt`
- Docker Compose validity for `docker-compose.override.yml`

---

## 📄 Attribution

This fork respects the original Apache 2.0 license from Langfuse. All upstream files are left unmodified.

Customization includes only local setup helpers and docker overrides.

---

## 🙏 Acknowledgements

This setup guide and supporting scripts are built on top of the amazing [Langfuse](https://github.com/langfuse/langfuse) project.  
We are grateful to the Langfuse team for making such a well-documented and powerful observability platform available to the community.

🙋 Questions or changes? Contact [Carlos Crespo](https://github.com/macayaven).
