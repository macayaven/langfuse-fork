# 🧰 Langfuse Local Dev Tools

This is a small set of helper scripts and configs to run a self-hosted [Langfuse](https://github.com/langfuse/langfuse) instance locally — mainly for tracing and observability during development.

It’s a **fork** of the original Langfuse observability platform. This repo doesn’t change any core logic — it just adds some tooling to simplify setup and local usage.


## 🛠️ Setup

See [README_SETUP.md](./README_SETUP.md) for installation steps and prerequisites.


## 🔧 Useful Commands

```bash
make check-prereqs   # Verify Docker, Git, and Make are installed
make env             # Generate .env file with config options for each component
make up              # Start the Langfuse stack
make health          # Check if services are healthy
make down            # Stop the stack
make clean           # Remove containers, volumes, and networks

If you forget a command or want a quick reminder, just run:

make

It will show a list of available targets with descriptions.


📄 License

Langfuse is licensed under the Apache 2.0 License.
All original Langfuse code and configuration files belong to the Langfuse project.

This fork just adds a few tools to help with local setup and usage. Please retain this notice and the original license when redistributing.

---
