export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

BASE=$HOME

# Options
# --------------------------------------------------------------------

### Append to the history file
shopt -s histappend

### Check the window size after each command ($LINES, $COLUMNS)
shopt -s checkwinsize

### Better-looking less for binary files
[ -x /usr/bin/lesspipe    ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

# Environment variables
# --------------------------------------------------------------------

### man bash
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

export EDITOR=vim
export LANG=en_US.UTF-8
[ "$PLATFORM" = 'Darwin' ] ||
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib

# Aliases
# --------------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd.='cd ..'
alias cd..='cd ..'
alias l='ls -alF'
alias ll='ls -l'
alias hc="history -c"
alias h="history"
alias which='type -p'
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

alias brews='brew list -1'
alias bubo='brew update && brew outdated'
alias bubc='brew upgrade && brew cleanup'
alias bubu='bubo && bubc && mas upgrade'
alias bcu='brew cask list | xargs brew cask install --force'

alias myip='curl icanhazip.com'

alias glog='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
alias gaa='git add --all'
alias gl='git pull'
alias gf='git diff'
alias gp='git push'
alias gss='git status -s'
alias gci='git commit'
alias gco='git checkout'

alias rs='rails s'
alias rc='rails c'

alias bi='bundle install'
alias bu='bundle update'
alias be='bundle exec'

alias subl='open -a "Sublime Text"'
alias e="$EDITOR"

### Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi

# Ruby
# --------------------------------------------------------------------

if [[ -s /usr/local/bin/rbenv ]]; then
  eval "$(rbenv init -)"
fi


# Z integration
# --------------------------------------------------------------------
source `brew --prefix`/etc/profile.d/z.sh

# iTerm
# --------------------------------------------------------------------
# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# https://github.com/rgcr/m-cli
# --------------------------------------------------------------------
export PATH=$PATH:/usr/local/m-cli

# golang
# --------------------------------------------------------------------
export GOPATH=$HOME/go_path

# PS1
# --------------------------------------------------------------------

miniprompt() {
  unset PROMPT_COMMAND
  PS1="\[\e[38;5;168m\]> \[\e[0m\]"
}

if [ "$PLATFORM" = Linux ]; then
  PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
  PS1="$PS1\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
  PS1="\[\e[34m\]\u\[\e[1;32m\]@\[\e[0;33m\]\h\[\e[35m\]:"
  PS1="$PS1\[\e[m\]\w\[\e[1;31m\]> \[\e[0m\]"
fi

# Shortcut functions
# --------------------------------------------------------------------

genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=27
  LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c ${l} | xargs
}

passgen() {
  genpasswd $1 | pbcopy && pbpaste | xargs echo && echo '=> Password copied to pasteboard.'
}

# Pull recursively all the git repos in the directories
git_pull_recursive () {
  find `pwd` -type d -name .git \
  | xargs -n 1 dirname \
  | sort \
  | while read line; do echo $line && cd $line && git pull; done
}

# OSX only functions
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias tac='tail -r'
  o() {
    open --reveal "${1:-.}"
  }
  # c - browse chrome history
  c() {
    local cols sep
    export cols=$(( COLUMNS / 3 ))
    export sep='{::}'

    cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
    sqlite3 -separator $sep /tmp/h \
      "select title, url from urls order by last_visit_time desc" |
    ruby -ne '
      cols = ENV["cols"].to_i
      title, url = $_.split(ENV["sep"])
      len = 0
      puts "\x1b[36m" + title.each_char.take_while { |e|
        if len < cols
          len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
        end
      }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
    fzf --ansi --multi --no-hscroll --tiebreak=index |
    sed 's#.*\(https*://\)#\1#' | xargs open
  }
fi
