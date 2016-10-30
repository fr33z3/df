dir="$HOME/Developer/yungb"
mkdir -p $dir
cd $dir
git clone --recurse-submodules git://github.com/yungb/dotfiles.git
cd dotfiles
bash install-dotfiles.sh

chsh -s /bin/zsh
