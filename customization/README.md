# 🚀 Langfuse Onboarding Setup (User Guide)

Welcome! This guide helps you run a full Langfuse stack locally with minimal setup.

---

## 🧑‍💻 For Users

### ✅ Prerequisites
- Docker + Docker Compose v2 ([Install Docker](https://docs.docker.com/get-docker/))
- Git and Make installed

Check your environment with:
```bash
make check-prereqs
```

---

### 📦 Setup & Run
```bash
git clone https://github.com/macayaven/langfuse-fork.git
cd langfuse-fork
make env         # Generate .env from template
make up          # Start the stack
make health      # Check that everything is healthy
```

---

### 🧹 Stop the stack
```bash
make down
```

---

## 🧠 Common Make Targets

```bash
make check-prereqs   # Ensure Docker, Git, Make, etc. are installed
make env             # Create .env from template
make up              # Start Langfuse stack
make down            # Stop the stack
make health          # Check containers and endpoints
```

---

## 📍 Access Langfuse UI

Once running, open:
👉 [http://localhost:3000](http://localhost:3000)

---

## 📋 Optional Add-ons

- `make lint`: Lint Docker Compose and shell scripts
- `make install-linters`: Install shellcheck, shfmt for local checks
- `make clean`: Stop the stack and remove all Docker resources (volumes, networks)

## 🛠️ Development Tips

### VS Code Settings

If you're using VS Code, add these settings to your local `.vscode/settings.json` file for better YAML support with Docker Compose overrides:

```json
{
  "yaml.customTags": [
    "!override sequence",
    "!override mapping",
    "!override scalar",
    "!reset sequence",
    "!reset mapping",
    "!reset scalar"
  ]
}
```

These settings help VS Code properly recognize the custom YAML tags used in our Docker Compose override files.

Enjoy tracing! ✨

---

## 📄 License and Attribution

This project is a customization layer on top of [Langfuse](https://github.com/langfuse/langfuse), which is licensed under the [Apache 2.0 License](LICENSE).

All original code and configuration files belong to the Langfuse project. This repo adds onboarding utilities, override configuration, and scripting to simplify local setup and internal collaboration.

Please retain this notice and the original license when redistributing.
