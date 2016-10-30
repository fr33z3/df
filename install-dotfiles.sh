dev="$HOME/Developer"
dotfiles="$dev/yungb/dotfiles"

if [[ -d "$dotfiles" ]]; then
  echo "Symlinking dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

link() {
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}

for location in $(find home -name '.*'); do
  file="${location##*/}"
  file="${file%.sh}"
  link "$dotfiles/$location" "$HOME/$file"
done

if [[ `uname` == 'Darwin' ]]; then
  user="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
  if [ -d "$user"  ]; then
    echo "sublime user dir exists backing up..."
    mkdir -pv bak && mv "$user" bak/original-sublime-user
  fi
  ln -sv $(pwd)/sublime/User "$user"
  ln -svf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin
fi

# git pull && git submodule update --init --recursive
setopt EXTENDED_GLOB
for rcfile in "$dotfiles"/home/zprezto/runcoms/^README.md(.N); do
  ln -svf "$rcfile" "$HOME/.${rcfile:t}"
done
lm -svf $HOME"/.zprezto $dotfiles"/home/zprezto

# Install vim
export GIT_SSL_NO_VERIFY=true
mkdir -p ~/.vim/autoload
curl --insecure -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim

# vimrc
mv -v ~/.vimrc $(pwd)/bak/.vimrc.old 2> /dev/null
ln -sf $(pwd)/home/.vimrc ~/.vimrc

# nvim
mkdir -p ~/.config/nvim/autoload
ln -sf $(pwd)/home/.vimrc ~/.config/nvim/init.vim
ln -sf ~/.vim/autoload/plug.vim ~/.config/nvim/autoload/

vim +PlugInstall +qall
