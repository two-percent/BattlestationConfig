#!/bin/bash
echo "Running this script will reboot your machine."
read -p "Continue? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	exit 1
fi

echo "Installing Sublime Text..."

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

echo "Installing Oh-My-Zsh..."

sudo apt-get install zsh curl git fonts-powerline
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
# install for user and root
sh install.sh --unattended
sudo sh install.sh --unattended
rm install.sh

echo "Setting up logging..."
sudo mkdir /root/logs
mkdir ~/logs
cat BashMod.txt >> ~/.bashrc
cat BashMod.txt | sudo tee -a /root/.bashrc
cat ZshMod.txt >> ~/.zshrc
cat ZshMod.txt | sudo tee -a /root/.zshrc
sed -i 's/^ZSH_THEME.*/ZSH_THEME="agnoster"/' ~/.zshrc
sudo sed -i 's/^ZSH_THEME.*/ZSH_THEME="agnoster"/' /root/.zshrc
chsh -s /bin/bash
sudo chsh -s /bin/bash

echo "Updating system..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade

echo "Rebooting because why not..."
sudo reboot