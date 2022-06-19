#!/bin/bash

# If Sublime not installed, install it
REQUIRED_PKG="sublime-text"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG| grep "install ok installed")
if [ "" = "$PKG_OK" ]; then
	echo "Installing Sublime Text..."

	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install sublime-text -y
else
	echo "Sublime already installed..."
fi

# If Oh-My-Zsh not installed, install it
DIR=~/.oh-my-zsh/
if [ ! -d "$DIR" ]; then
	echo "Installing Oh-My-Zsh..."

	sudo apt-get install zsh curl git fonts-powerline
	wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	# install for user and root
	sh install.sh --unattended
	sudo sh install.sh --unattended
	rm install.sh
else
	echo "Oh-My-Zsh already installed..."
fi

# Generic user setup
DIR=~/logs/
if [[ ! -d "$DIR" ]]; then
	echo "Setting up log folder..."
	mkdir ~/logs
else
	echo "User log folder already set up..."
fi

BMOD_OK=$(cat ~/.bashrc | grep "_shell.log")
if [[ "" = "$BMOD_OK" ]]; then
	cat BashMod.txt >> ~/.bashrc
else
	echo "User .bashrc already configured..."
fi

ZMOD_OK=$(cat ~/.zshrc | grep "PROMPT='")
if [[ "" = "$ZMOD_OK" ]]; then
	cat ZshMod.txt >> ~/.zshrc
else
	echo "User ZSH prompt already updated..."
fi

THEME_OK=$(cat ~/.zshrc | grep "agnoster")
if [[ "" = "$THEME_OK" ]]; then
	sed -i 's/^ZSH_THEME.*/ZSH_THEME="agnoster"/' ~/.zshrc
else
	echo "User ZSH theme already updated..."
fi

# Root user setup
DIR=/root/logs/
if sudo [ ! -d "$DIR" ]; then
	echo "Setting up log folder..."
	mkdir /root/logs
else
	echo "Root log folder already set up..."
fi

BMOD_OK=$(sudo cat /root/.bashrc | grep "_shell.log")
if [[ "" = "$BMOD_OK" ]]; then
	cat BashMod.txt | sudo tee -a /root/.bashrc
else
	echo "Root .bashrc already configured..."
fi

ZMOD_OK=$(sudo cat /root/.zshrc | grep "PROMPT='")
if [[ "" = "$ZMOD_OK" ]]; then
	cat ZshMod.txt | sudo tee -a /root/.zshrc
else
	echo "Root ZSH prompt already updated..."
fi

THEME_OK=$(sudo cat /root/.zshrc | grep "agnoster")
if [[ "" = "$THEME_OK" ]]; then
	sudo sed -i 's/^ZSH_THEME.*/ZSH_THEME="agnoster"/' /root/.zshrc
else
	echo "Root ZSH theme already updated..."
fi


SHELL_OK=$(echo $SHELL)
if ! [ "$SHELL_OK" = "/bin/bash" ]; then
	echo "Setting user default shell..."
	chsh -s /bin/bash
else
	echo "User shell already set..."
fi

SHELL_OK=$(sudo echo $SHELL)
if [ ! "$SHELL_OK" = "/bin/bash" ]; then 
	echo "Setting root default shell..."
	sudo chsh -s /bin/bash
else
	echo "Root shell already set..."
fi

echo "Updating system..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade

read -p "Reboot? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	exit 1
fi

sudo reboot