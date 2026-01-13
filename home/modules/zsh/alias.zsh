alias e='exit'
alias ll='ls -l'

# vim
alias vim='nvim'
alias vi='nvim'

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

# kubernetes
alias k='kubectl'
alias ks='kustomize'

# krew plugins
alias kx='kubectl ctx'
alias kn='kubectl ns'
alias st='kubectl stern'
alias neat='kubectl neat'
alias knode='kubectl node-shell'
alias ksniff='kubectl sniff'
alias kall='kubectl get-all'
alias ktree='kubectl tree'
alias ktail='kubectl tail'
alias kstatus='kubectl status'
alias kscore='kubectl score'
alias kex='kubectl iexec'
alias kdd='kubectl datadog'
alias krc='kubectl resource-capacity'
alias krolesum='kubectl rolesum'
alias kvu='kubectl view-utilization'
alias kosvc='kubectl open-svc'

# mise
alias claude='mise exec -- claude'
