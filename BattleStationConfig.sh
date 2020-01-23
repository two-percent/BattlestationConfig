apt-get install zsh curl git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv vimconfig ~/.vimrc
mv zshrc ~/.zshrc

echo "Please logout and log back in.\n"
