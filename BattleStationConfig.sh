apt-get install zsh curl git fonts-powerline
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv vimconfig ~/.vimrc
mv zshrc ~/.zshrc
echo "Vim plugins will be installed on next run. Please logout and log back in.\n"
