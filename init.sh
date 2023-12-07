#!/bin/bash

if [[ $EUID -ne 0 ]]
then
  printf 'Must be run as root, exiting!\n'
  tput cnorm
  exit 1
fi

installed = true
packagesNeeded='wget git zsh'
if [ -x "$(command -v apk)" ];       
then 
    apk add --no-cache $packagesNeeded

elif [ -x "$(command -v apt-get)" ]; 
then 
    apt-get install $packagesNeeded

elif [ -x "$(command -v dnf)" ];     
then 
    dnf install $packagesNeeded
s
elif [ -x "$(command -v zypper)" ];  
then 
    zypper install $packagesNeeded

elif [ -x "$(command -v pacman)" ];  
then 
    pacman -sS $packagesNeeded

else 
    echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; 
    $installed = false
fi

chsh -s /usr/bin/zsh

mkdir /home/$SUDO_USER/configs
mkdir /home/$SUDO_USER/backup_configs

wget -O /home/$SUDO_USER/configs/.zshrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.zshrc
wget -O /home/$SUDO_USER/configs/.vimrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.vimrc
wget -O /home/$SUDO_USER/configs/.p10k.zsh https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.p10k.zsh

git clone https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip -q Hack.zip -d ~/HackNF

if [ $installed ]; 
then 
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    read -p "Use zsh config? (y/n): " zsh_config
    read -p "Use p10k config? (y/n): " p10k_config
    read -p "Use vim config? (y/n): " vim_config

    if [$zsh_config == 'y' || $zsh_config == 'Y'];
    then
        mv /home/$SUDO_USER/.zshrc /home/$SUDO_USER/backup_configs/.zshrc_old
        mv /home/$SUDO_USER/configs/.zshrc /home/$SUDO_USER/.zshrc
    fi
    
    if [$p10k_config == 'y' || $p10k_config == 'Y'];
    then
        mv /home/$SUDO_USER/.p10k.zsh /home/$SUDO_USER/backup_configs/.p10k.zsh_old
        mv /home/$SUDO_USER/configs/.p10k.zsh /home/$SUDO_USER/.p10k.zsh
    fi

    if [$vim_config == 'y' || $vim_config == 'Y'];
    then
        mv /home/$SUDO_USER/.vimrc /home/$SUDO_USER/backup_configs/.vimrc_old
        mv /home/$SUDO_USER/configs/.vimrc /home/$SUDO_USER/.vimrc
    fi

    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

echo "Font will have to be manually installed and enabled."
echo "May have to run 'p10k configure' to get icons to render correctly."

echo "Install finished, restart your terminal to complete!"