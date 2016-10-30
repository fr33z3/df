if [[ `uname` == 'Darwin' ]]; then

  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      brew update
      brew install tmux \
      z vim trash \
      m-cli tig htop vim bash zsh \
      elixir rbenv iterm2 \
      git git-extras mas fzf \
      ssh-copy-id
  fi

  # http://github.com/sindresorhus/quick-look-plugins
  echo 'Installing Quick Look plugins...'
    brew tap caskroom/cask
    brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package
    brew cask install spectacle \
    font-dejavu-sans \
    font-inconsolata \
    font-meslo-lg \
    font-ubuntu \
    font-fira-code \
    font-inconsolata-g-for-powerline \
    font-meslo-lg-for-powerline \
    font-hermit \
    font-input

fi
