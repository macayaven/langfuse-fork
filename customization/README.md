# 🚀 Langfuse Onboarding Setup (User Guide)

📦 This repo is a **fork of [Langfuse](https://github.com/langfuse/langfuse)**, customized for internal onboarding and local self-hosting. All modifications are non-invasive and live under the `customization/` directory.

---

## 🧑‍💻 For Users

### ✅ Prerequisites
- WSL2 up and running in your laptop. 
- Docker + Docker Compose v2 ([Install Docker](https://docs.docker.com/get-docker/))
- Configure Docker to run sudoless ([Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/))
- Git client installed
- make command installed (can be added by installing the build-essentials package) 
```sudo apt-get install build-essential```

Check your environment with:
```bash
make check-prereqs
```

---

### 📦 Configure & Run
```bash
git clone https://github.com/macayaven/langfuse-fork.git
cd langfuse-fork/customization
git remote set-url origin https://github.com/macayaven/langfuse-fork.git
git remote set-url --push origin https://github.com/macayaven/langfuse-fork.git
git remote set-url --push upstream no_push # Prevent unintentional pushes to the official Langfuse repo 
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
make up              # Start Langfuse stack
make down            # Stop the stack
make health          # Check containers and endpoints
```

---

## 📍 Access Langfuse UI & Initial Setup

Once running, open:
👉 [http://localhost:3000](http://localhost:3000)

### First-Time Setup Steps once the server is up and running:

1. **Create a user account** - Sign up with your email
2. **Create an organization** - Give your organization a name
3. **Create a project** - Name your first project
4. **Generate API keys**:
   - Go to Project Settings > API Keys
   - Create a new key pair
   - Copy the values to your `.env` file of the client project to be instrumented:

```bash
# Add these to your .env file
LANGFUSE_PUBLIC_KEY=pk-lf-xxxxxxxxxxxx
LANGFUSE_SECRET_KEY=sk-lf-xxxxxxxxxxxx
LANGFUSE_HOST=http://localhost:3000
```

These keys will be used by your applications to connect to your Langfuse instance.

For full documentation and usage examples, refer to the official [Langfuse Docs](https://langfuse.com/docs).

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

This project is a intended to simplify the deployment of [Langfuse](https://github.com/langfuse/langfuse), which is licensed under the [Apache 2.0 License](LICENSE).

Please retain this notice and the original license when redistributing.

---

## 🙏 Acknowledgements

This setup guide and supporting scripts are built on top of the amazing [Langfuse](https://github.com/langfuse/langfuse) project.  
We are grateful to the Langfuse team for making such a well-documented and powerful observability platform available to the community.