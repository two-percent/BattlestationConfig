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
	sudo mkdir /root/logs
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

THEME_OK=$(sudo cat /root/.zshrc | grep 'ZSH_THEME="agnoster"')
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

read -p "Update system? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Updating system..."
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get dist-upgrade
	# save space
	sudo apt autoremove
fi


# Install Packages Here

sudo apt-get -y install aha python3-venv neo4j

# install pipx, if needed
if [ -z $(which pipx) ]
then
	echo "Installing pipx..."
	python3 -m pip install pipx
	python3 -m pipx ensurepath
	# Update path without reloading ZSH and breaking script = janky bash oneliner
	pipxLoc=$(cat ~/.zshrc | grep "export PATH" | grep -v "#" | cut -d'"' -f2)
	export PATH=$PATH:$pipxLoc
fi

# Install virtualenv managed CME (much more stable and isolated python dependencies)
DIR=~/.local/pipx/venvs/crackmapexec/
if [ ! -d "$DIR" ]; then
	echo "Installing CME..."
	pipx install crackmapexec
else
	echo "User CME already available..."
fi

# Download operational tooling - Make function for this? May be unnecessary
mkdir ~/tools
git clone https://github.com/carlospolop/PEASS-ng ~/tools/PEASS-ng
git clone https://github.com/optiv/ScareCrow ~/tools/ScareCrow
git clone https://github.com/mzet-/linux-exploit-suggester ~/tools/linux-exploit-suggester
git clone https://github.com/PowerShellMafia/PowerSploit/ ~/tools/PowerSploit
git clone https://github.com/fox-it/BloodHound.py ~/tools/BloodHound-Python
git clone https://github.com/CompassSecurity/BloodHoundQueries ~/tools/BloodHoundQueries
git clone https://github.com/TheWover/donut ~/tools/donut
git clone https://github.com/FortyNorthSecurity/EXCELntDonut ~/tools/EXCELntDonut
git clone https://github.com/orlyjamie/mimikittenz ~/tools/Mimikittenz
git clone https://github.com/lgandx/Responder ~/tools/Responder

# BloodHound latest release download
DIR=~/tools/BloodHound/
if [ ! -d "$DIR" ]; then
	directory=$(curl -L https://github.com/BloodHoundAD/BloodHound/releases/latest | grep BloodHound-linux-x64.zip | grep href | cut -d'"' -f2)
	base="https://github.com"
	target="$base$directory"
	wget -P ~/tools/BloodHound $target
	unzip ~/tools/BloodHound/BloodHound-linux-x64.zip -d ~/tools/BloodHound
	mv ~/tools/BloodHound/BloodHound-linux-x64/* ~/tools/BloodHound
	rm -r ~/tools/BloodHound/BloodHound-linux-x64/
	rm ~/tools/BloodHound/BloodHound-linux-x64.zip
	chmod +x ~/tools/Bloodhound/BloodHound
	wget https://raw.githubusercontent.com/CompassSecurity/BloodHoundQueries/master/customqueries.json -O ~/.config/bloodhound/customqueries.json
	systemctl enable neo4j
	systemctl start neo4j
else
	echo "BloodHound already installed..."
fi

read -p "Reboot? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	exit 1
fi

sudo reboot