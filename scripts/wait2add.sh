if uname -r | grep -qi "microsoft"; then
    # WSL
    if ! type "gnome-text-editor" &>/dev/null; then
        sudo apt install gnome-text-editor -y
    fi
else
    # Ubuntu
    if ! type "code" &>/dev/null; then
        wget -O ~/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" &&
            sudo apt install ~/vscode.deb -y &&
            rm -rf ~/vscode.deb
    fi
fi

sudo apt install zsh -y
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)/' ~/.zshrc
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc && sleep 2s && p10k configure
fi

if ! type "eza" &>/dev/null; then
    wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
    sudo mv eza /usr/local/bin/eza
    echo "alias lll='eza -lgSUumMioHh@ZF --smart-group --group-directories-first --no-quotes --icons --color --color-scale=all --color-scale-mode=gradient --git --git-repos --time-style iso --total-size -rs size -RTL 2'" >>~/.zshrc
    echo "alias lll='eza -lgSUumMioHh@ZF --smart-group --group-directories-first --no-quotes --icons --color --color-scale=all --color-scale-mode=gradient --git --git-repos --time-style iso --total-size -rs size -RTL 2'" >>~/.bashrc
fi

if ! type "git-credential-manager" &>/dev/null; then
    # assume that installer was copied to home dir
    sudo dpkg -i gcm-linux_amd64.2.4.1.deb &&
        git-credential-manager configure
    echo "export GPG_TTY=$(tty)" >>~/.zshrc
    echo "export GPG_TTY=$(tty)" >>~/.bashrc
fi

sudo apt install pass -y
if ! gpg --list-secret-keys | grep -qi "abc"; then
    gpg --gen-key && pass init "abc <xyz@gmail.com>"
fi

echo "[ ] Add ssh key"
