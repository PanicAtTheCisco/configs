#!/bin/bash

finishConfigs() {
    mkdir ~/configs
    mkdir ~/backup_configs

    wget -O ~/configs/.zshrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.zshrc
    wget -O ~/configs/.vimrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.vimrc
    wget -O ~/configs/.p10k.zsh https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.p10k.zsh

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    mv ~/.zshrc ~/backup_configs/.zshrc_old
    cp ~/configs/.zshrc ~/.zshrc

    mv ~/.p10k.zsh ~/backup_configs/.p10k.zsh_old
    cp ~/configs/.p10k.zsh ~/.p10k.zsh

    mv ~/.vimrc ~/backup_configs/.vimrc_old
    cp ~/configs/.vimrc ~/.vimrc

    #TODO: Install Hack Nerd Font

    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh}/plugins/zsh-syntax-highlighting
}

packagesNeeded="wget curl git zsh"
#Alpine
if [ -x "$(command -v apk)" ];       
then 
    sudo apk add --no-cache $packagesNeeded

#Debian/Ubuntu
elif [ -x "$(command -v apt-get)" ]; 
then
    $packagesNeeded += " nala"
    sudo apt install $packagesNeeded -y

#Fedora/Red Hat
elif [ -x "$(command -v dnf)" ];     
then
    sudo dnf install $packagesNeeded -y

#OpenSUSE
elif [ -x "$(command -v zypper)" ];  
then
    sudo zypper install $packagesNeeded -y

#Arch
elif [ -x "$(command -v pacman)" ];  
then
    sudo pacman -sS $packagesNeeded -y

#Alert if failed
else
    echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; 
    exit 1
fi

finishConfigs

echo ""
echo "Hack Nerd Font will have to be manually installed from "https://github.com/ryanoasis/nerd-fonts/releases" and enabled."
echo "May have to run 'p10k configure' to get icons to render correctly."
sleep(2)
echo "Install finished, log out and back in to complete!"