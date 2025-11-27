# 🛠️ Ubuntu Dev Setup (Justfile Automation)

This repository provides a complete, automated development environment setup for Ubuntu using **Justfile**.  
The goal is to provision a clean, consistent, and productivity-focused developer machine with minimal manual steps.

All commands and comments inside the `Justfile` are written in English.  
This README explains how to use the setup and what gets installed.

---

## 🚀 What the setup does automatically

Running `just setup` will:

### ✔️ System
- Update and upgrade the system
- Install core development dependencies

### ✔️ Docker
- Install Docker and Docker Compose
- Apply a lightweight Docker configuration optimized for laptops (lower RAM usage)

### ✔️ Terminal (interactive choice)
During the setup you can choose to install:
- **Ghostty**, or  
- **Kitty**, or  
- Skip terminal installation

### ✔️ Editor (interactive choice)
You will also be asked whether to install:
- **VS Code**, or  
- **Cursor**, or  
- No editor

### ✔️ Shell (Zsh customization)
The setup installs and configures:
- Zsh
- Oh My Zsh
- Powerlevel10k theme
- Plugins:
  - zsh-autosuggestions  
  - zsh-syntax-highlighting
- Sets Zsh as the default shell

### ✔️ ASDF
- Installs ASDF (version manager), ready for language installations

### ✔️ Ruby (installed automatically)
- Installs Ruby build dependencies
- Installs **Ruby via ASDF**
- Sets Ruby as the global version
- Installs Bundler

_No Rails projects are created and no Rails commands are triggered._

### ✔️ Projects directory structure
Automatically creates:

```

~/projects
ruby
python
node
mobile
infra
experiments
docs

````

---

## ▶️ How to use

Clone your setup repository:

```bash
git clone <your-repo-url>
cd <folder>
````

Ensure `just` is installed:

```bash
sudo apt install just
```

Run the full setup:

```bash
just setup
```

---

## 🧩 Interactive installation

During the process, you will see prompts like:

```
Which terminal do you want to install? (ghostty/kitty/none)
Which editor do you want to install? (vscode/cursor/none)
```

Respond using the options exactly as shown:

Examples:

* `ghostty`
* `kitty`
* `vscode`
* `cursor`
* `none`

---

## ✔️ After the setup

Once `just setup` finishes:

* Docker is ready
* Zsh is fully customized
* Terminal/editor installed (if selected)
* ASDF is configured
* Ruby is installed and ready
* Projects directory structure is ready

You **do not** need to run ASDF commands manually to install Ruby —
the Justfile handles the full installation automatically.

---

## 🔧 Optional future additions

If needed, the Justfile can be extended to support:

* GitHub CLI or GitLab CLI installation
* LazyGit
* Automatic VS Code extension installation
* Node or Python installation via ASDF
* PostgreSQL/Redis setup
* Custom Zsh aliases and functions
* `just doctor` (environment validation)
* `just upgrade ruby` (automated Ruby version upgrades)

Just request the feature and it can be added.

---

## 📄 License

Private project.
Used for personal machine bootstrapping.

---

## 💬 Support

If you want enhancements, simplifications, or new automation features, feel free to ask.


