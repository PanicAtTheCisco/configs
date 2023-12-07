#!/bin/bash

installed = true
packagesNeeded='wget git zsh'
if [ -x "$(command -v apk)" ];       
then 
    sudo apk add --no-cache $packagesNeeded

elif [ -x "$(command -v apt-get)" ]; 
then 
    sudo apt-get install $packagesNeeded

elif [ -x "$(command -v dnf)" ];     
then 
    sudo dnf install $packagesNeeded

elif [ -x "$(command -v zypper)" ];  
then 
    sudo zypper install $packagesNeeded

elif [ -x "$(command -v pacman)" ];  
then 
    sudo pacman -sS $packagesNeeded

else 
    echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; 
    $installed = false
fi

mkdir ~/configs
mkdir ~/backup_configs

wget -O ~/configs/.zshrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.zshrc
wget -O ~/configs/.vimrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.vimrc
wget -O ~/configs/.p10k.zsh https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.p10k.zsh

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
        mv ~/.zshrc ~/backup_configs/.zshrc_old
        mv ~/configs/.zshrc ~/.zshrc
    fi
    
    if [$p10k_config == 'y' || $p10k_config == 'Y'];
    then
        mv ~/.p10k.zsh ~/backup_configs/.p10k.zsh_old
        mv ~/configs/.p10k.zsh ~/.p10k.zsh
    fi

    if [$vim_config == 'y' || $vim_config == 'Y'];
    then
        mv ~/.vimrc ~/backup_configs/.vimrc_old
        mv ~/configs/.vimrc ~/.vimrc
    fi

    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

echo "Font will have to be manually installed and enabled."
echo "May have to run 'p10k configure' to get icons to render correctly."

echo "Install finished, restart your terminal to complete!"