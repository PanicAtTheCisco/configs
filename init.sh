#!/bin/bash

finishConfigs() {
    mkdir /home/$SUDO_USER/configs
    mkdir /home/$SUDO_USER/backup_configs

    wget -O /home/$SUDO_USER/configs/.zshrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.zshrc
    wget -O /home/$SUDO_USER/configs/.vimrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.vimrc
    wget -O /home/$SUDO_USER/configs/.p10k.zsh https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.p10k.zsh

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    read -i "Use zsh config? (y/n): " zsh_config
    read -i "Use p10k config? (y/n): " p10k_config
    read -i "Use vim config? (y/n): " vim_config

    if [[ "$zsh_config" == [yY] ]]; then
        mv /home/$SUDO_USER/.zshrc /home/$SUDO_USER/backup_configs/.zshrc_old
        cp /home/$SUDO_USER/configs/.zshrc /home/$SUDO_USER/.zshrc
    fi

    if [[ "$p10k_config" == [yY] ]]; then
        mv /home/$SUDO_USER/.p10k.zsh /home/$SUDO_USER/backup_configs/.p10k.zsh_old
        cp /home/$SUDO_USER/configs/.p10k.zsh /home/$SUDO_USER/.p10k.zsh
    fi

    if [[ "$vim_config" == [yY] ]]; then
        mv /home/$SUDO_USER/.vimrc /home/$SUDO_USER/backup_configs/.vimrc_old
        cp /home/$SUDO_USER/configs/.vimrc /home/$SUDO_USER/.vimrc
    fi

    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

    sudo chsh -s $(which zsh)
}

if [[ $EUID -ne 0 ]]
then
  printf 'Must be run as root, exiting!\n'
  tput cnorm
  exit 1
fi

packagesNeeded="wget git zsh"
#Alpine
if [ -x "$(command -v apk)" ];       
then 
    sudo apk add --no-cache $packagesNeeded
    finishConfigs

#Debian/Ubuntu
elif [ -x "$(command -v apt-get)" ]; 
then 
    sudo apt install $packagesNeeded
    finishConfigs

#Fedora/Red Hat
elif [ -x "$(command -v dnf)" ];     
then 
    sudo dnf install $packagesNeeded
    finishConfigs

#OpenSUSE
elif [ -x "$(command -v zypper)" ];  
then 
    sudo zypper install $packagesNeeded
    finishConfigs

#Arch
elif [ -x "$(command -v pacman)" ];  
then 
    sudo pacman -sS $packagesNeeded
    finishConfigs

#Alert if failed
else 
    echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; 
fi

echo "\nHack Nerd Font will have to be manually installed from "https://github.com/ryanoasis/nerd-fonts/releases" and enabled."
echo "May have to run 'p10k configure' to get icons to render correctly."

echo "Install finished, restart your terminal to complete!"