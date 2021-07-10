# set timezone
export TZ='Asia/Shanghai'

# set LANG
export LANG='en_US.UTF-8'

# set alias
alias ls='ls --color=auto'
alias ll='ls -l'
alias l='ls -lah'
alias la='ls -lAh'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set repo mirror
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo'
