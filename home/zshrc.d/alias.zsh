alias e='exit'
alias ll='ls -l'

# git
alias g='git'
alias gb='git branch'
alias gc='aicommits -a'
alias gce='git commit --allow-empty -m "empty commit"'
alias gco='git checkout'
alias gf='git fetch'
alias gg='git grep'
alias gm='git merge'
alias gp='git push'
alias gpush='gp origin $(gb --show-current)'
alias gst='git status -s -b'
alias gbd='git branch --merged | grep -Ev "main|master|develop" | xargs -I% git branch -D %'

# aws
alias asl='aws sso login --profile'

# mise
alias claude='mise exec -- claude'
