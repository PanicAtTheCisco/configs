#!/bin/bash

if [[ $EUID -ne 0 ]]
then
  printf 'Must be run as root, exiting!\n'
  tput cnorm
  exit 1
fi

mkdir /home/$SUDO_USER/configs
mkdir /home/$SUDO_USER/backup_configs

wget -O /home/$SUDO_USER/configs/.zshrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.zshrc
wget -O /home/$SUDO_USER/configs/.vimrc https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.vimrc
wget -O /home/$SUDO_USER/configs/.p10k.zsh https://raw.githubusercontent.com/PanicAtTheCisco/linux-configs/main/.p10k.zsh

installed = true
packagesNeeded="wget git zsh"
if [ -x "$(command -v apk)" ];       
then 
    sudo apk add --no-cache $packagesNeeded

elif [ -x "$(command -v apt-get)" ]; 
then 
    sudo apt install $packagesNeeded

elif [ -x "$(command -v dnf)" ];     
then 
    sudo dnf install $packagesNeeded
s
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

if [[ $installed == true ]]; then 
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    echo -n "Use zsh config? (y/n): "
    read zsh_config
    echo -n "Use p10k config? (y/n): "
    read p10k_config
    echo -n "Use vim config? (y/n): "
    read vim_config

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

    sudo chsh -s /usr/bin/zsh
fi

echo "Hack Nerd Font will have to be manually installed and enabled."
echo "May have to run 'p10k configure' to get icons to render correctly."

echo "Install finished, restart your terminal to complete!"