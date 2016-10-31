chsh -s /bin/zsh

dir="$HOME/Developer/yungb"
mkdir -p $dir
cd $dir
cd dotfiles
zsh install-dotfiles.sh
