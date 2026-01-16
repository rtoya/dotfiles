# [e] シェル終了 [shell]
alias e='exit'
# [ls] ezaでリスト表示 [shell,eza]
alias ls='eza'
# [ll] 詳細リスト表示 [shell,eza]
alias ll='eza -la'

# vim
# [vim] Neovimを起動 [nvim]
alias vim='nvim'
# [vi] Neovimを起動 [nvim]
alias vi='nvim'

# git
# [g] git [git]
alias g='git'
# [gb] ブランチ一覧 [git]
alias gb='git branch'
# [gc] AIコミット [git,aicommits]
alias gc='aic'
# [gce] 空コミット作成 [git]
alias gce='git commit --allow-empty -m "empty commit"'
# [gco] ブランチ切替 [git]
alias gco='git checkout'
# [gf] フェッチ [git]
alias gf='git fetch'
# [gg] git grep [git]
alias gg='git grep'
# [gm] マージ [git]
alias gm='git merge'
# [gp] プッシュ [git]
alias gp='git push'
# [gpush] 現在ブランチをプッシュ [git]
alias gpush='gp origin $(gb --show-current)'
# [gst] ステータス表示 [git]
alias gst='git status -s -b'
# [gbd] マージ済みブランチ削除 [git]
alias gbd='git branch --merged | grep -Ev "main|master|develop" | xargs -I% git branch -D %'

# aws
# [asl] AWS SSOログイン [aws]
alias asl='aws sso login --profile'

# Terraform / Terragrunt
# [tf] terraform [terraform]
alias tf='terraform'
# [tfi] terraform init (再設定) [terraform]
alias tfi='terraform init -reconfigure -backend-config=local.tfbackend -upgrade'
# [tfp] terraform plan [terraform]
alias tfp='terraform plan'
# [tfa] terraform apply [terraform]
alias tfa='terraform apply'
# [tg] terragrunt [terragrunt]
alias tg='terragrunt'
# [tgp] terragrunt plan [terragrunt]
alias tgp='terragrunt plan'
# [tgpa] terragrunt plan -all [terragrunt]
alias tgpa='terragrunt plan -all'
# [tga] terragrunt apply [terragrunt]
alias tga='terragrunt apply'
# [tgaa] terragrunt apply -all [terragrunt]
alias tgaa='terragrunt apply -all'

# kubernetes
# [kubectl] kubecolorでカラー出力 [k8s,kubecolor]
alias kubectl='kubecolor'
# [k] kubectl [k8s]
alias k='kubectl'
# [kd] kubectl describe [k8s]
alias kd='k describe'
# [kd] kubectl describe pod [k8s]
alias kdp='k describe pod'
# [kg] kubectl get [k8s]
alias kg='k get'
# [kgp] Pod一覧 [k8s]
alias kgp='kg pod'
# [ks] kustomize [k8s,kustomize]
alias ks='kustomize'

# krew plugins
# [kx] コンテキスト切替 [k8s,krew]
alias kx='kubectl ctx'
# [kn] namespace切替 [k8s,krew]
alias kn='kubectl ns'
# [st] ログストリーム [k8s,krew,stern]
alias st='kubectl stern'
# [neat] YAML整形出力 [k8s,krew]
alias neat='kubectl neat'
# [knode] ノードにシェル接続 [k8s,krew]
alias knode='kubectl node-shell'
# [ksniff] パケットキャプチャ [k8s,krew]
alias ksniff='kubectl sniff'
# [kall] 全リソース取得 [k8s,krew]
alias kall='kubectl get-all'
# [ktree] リソースツリー表示 [k8s,krew]
alias ktree='kubectl tree'
# [ktail] 複数Podログ [k8s,krew]
alias ktail='kubectl tail'
# [kstatus] リソースステータス [k8s,krew]
alias kstatus='kubectl status'
# [kscore] マニフェストスコア [k8s,krew]
alias kscore='kubectl score'
# [kex] インタラクティブexec [k8s,krew]
alias kex='kubectl iexec'
# [kdd] Datadog連携 [k8s,krew,datadog]
alias kdd='kubectl datadog'
# [krc] リソースキャパシティ [k8s,krew]
alias krc='kubectl resource-capacity'
# [krolesum] RBAC要約 [k8s,krew]
alias krolesum='kubectl rolesum'
# [kvu] リソース使用率 [k8s,krew]
alias kvu='kubectl view-utilization'
# [kosvc] サービスをブラウザで開く [k8s,krew]
alias kosvc='kubectl open-svc'

# Claude Code
# [claude] Claude Code起動 [claude,mise]
alias claude='mise exec -- claude'
