set shell := ["bash", "-cu"]

green := "`printf '\033[32m'`"
blue := "`printf '\033[34m'`"
yellow := "`printf '\033[33m'`"
reset := "`printf '\033[0m'`"

# ============================================
# MAIN SETUP ENTRYPOINT
# ============================================

setup: update docker ask-terminal ask-editor zsh asdf ruby projects
    @echo "{{green}}✔ System setup completed! Please restart your session.{{reset}}"


# ============================================
# SYSTEM UPDATE
# ============================================

update:
    @echo "{{blue}}Updating system...{{reset}}"
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y curl git wget unzip build-essential ca-certificates software-properties-common


# ============================================
# DOCKER
# ============================================

docker:
    @echo "{{blue}}Installing Docker & Docker Compose...{{reset}}"
    sudo apt install -y docker.io docker-compose-plugin
    sudo usermod -aG docker $USER

    @echo "{{blue}}Applying lightweight Docker config for laptops...{{reset}}"
    echo '{ "default-address-pools":[{"base":"172.17.0.0/16","size":24}] }' \
      | sudo tee /etc/docker/daemon.json > /dev/null

    sudo systemctl restart docker
    @echo "{{green}}✔ Docker installed and configured.{{reset}}"


# ============================================
# TERMINAL SELECTION
# ============================================

ask-terminal:
    @echo "{{yellow}}Which terminal do you want to install? (ghostty/kitty/none){{reset}}"
    read choice; \
    if [ "$$choice" = "ghostty" ]; then \
        just terminal-ghostty; \
    elif [ "$$choice" = "kitty" ]; then \
        just terminal-kitty; \
    else \
        echo "{{yellow}}Skipping terminal installation.{{reset}}"; \
    fi

terminal-ghostty:
    @echo "{{blue}}Installing Ghostty terminal...{{reset}}"
    sudo apt install -y flatpak
    flatpak install -y flathub com.mitchellh.ghostty || true

terminal-kitty:
    @echo "{{blue}}Installing Kitty terminal...{{reset}}"
    sudo apt install -y kitty


# ============================================
# EDITOR SELECTION
# ============================================

ask-editor:
    @echo "{{yellow}}Which editor do you want to install? (vscode/cursor/none){{reset}}"
    read choice; \
    if [ "$$choice" = "vscode" ]; then \
        just editor-vscode; \
    elif [ "$$choice" = "cursor" ]; then \
        just editor-cursor; \
    else \
        echo "{{yellow}}Skipping editor installation.{{reset}}"; \
    fi

editor-vscode:
    @echo "{{blue}}Installing VS Code...{{reset}}"
    wget -qO code.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
    sudo apt install -y ./code.deb
    rm code.deb

editor-cursor:
    @echo "{{blue}}Installing Cursor IDE...{{reset}}"
    wget -O cursor.deb "https://downloader.cursor.sh/linux/appImage?arch=x64&package=deb"
    sudo apt install -y ./cursor.deb
    rm cursor.deb


# ============================================
# ZSH + OH-MY-ZSH + POWERLEVEL10K
# ============================================

zsh:
    @echo "{{blue}}Installing Zsh + Oh My Zsh...{{reset}}"

    sudo apt install -y zsh
    if [ ! -d ~/.oh-my-zsh ]; then \
        RUNZSH=no CHSH=no sh -c \
        "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
    fi

    @echo "{{blue}}Installing Powerlevel10k theme...{{reset}}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ~/.oh-my-zsh/custom/themes/powerlevel10k || true

    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

    @echo "{{blue}}Installing Zsh plugins...{{reset}}"
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || true

    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || true

    sed -i 's/plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting /' ~/.zshrc

    chsh -s $(which zsh)

    @echo "{{green}}✔ Zsh environment configured.{{reset}}"


# ============================================
# ASDF (NO LANGUAGES, ONLY TOOL)
# ============================================

asdf:
    @echo "{{blue}}Installing ASDF...{{reset}}"
    if [ ! -d ~/.asdf ]; then \
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1; \
        echo '. "$$HOME/.asdf/asdf.sh"' >> ~/.zshrc; \
        echo '. "$$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc; \
    fi


# ============================================
# RUBY + BUILD DEPENDENCIES (NO RAILS COMMANDS)
# ============================================

ruby:
    @echo "{{blue}}Installing Ruby via ASDF...{{reset}}"

    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git || true

    @echo "{{blue}}Installing Ruby build dependencies...{{reset}}"
    sudo apt install -y autoconf patch build-essential rustc libssl-dev \
        libyaml-dev libreadline6-dev zlib1g-dev libgdbm-dev libncurses5-dev \
        libffi-dev libgdbm6 libdb-dev uuid-dev

    asdf install ruby latest
    asdf global ruby latest

    gem install bundler

    @echo "{{green}}✔ Ruby installed (NO Rails scaffolding).{{reset}}"


# ============================================
# PROJECT STRUCTURE
# ============================================

projects:
    @echo "{{blue}}Creating ~/projects directory structure...{{reset}}"

    mkdir -p ~/projects \
             ~/projects/ruby \
             ~/projects/node \
             ~/projects/python \
             ~/projects/mobile \
             ~/projects/infra \
             ~/projects/experiments \
             ~/projects/docs

    @echo "{{green}}✔ Project folders created.{{reset}}"
