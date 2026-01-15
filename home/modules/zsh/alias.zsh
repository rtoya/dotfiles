# [e] シェル終了
alias e='exit'
# [ll] 詳細リスト表示
alias ll='ls -l'

# vim
# [vim] Neovimを起動
alias vim='nvim'
# [vi] Neovimを起動
alias vi='nvim'

# git
# [g] git
alias g='git'
# [gb] ブランチ一覧
alias gb='git branch'
# [gc] AIコミット
alias gc='aicommits -a'
# [gce] 空コミット作成
alias gce='git commit --allow-empty -m "empty commit"'
# [gco] ブランチ切替
alias gco='git checkout'
# [gf] フェッチ
alias gf='git fetch'
# [gg] git grep
alias gg='git grep'
# [gm] マージ
alias gm='git merge'
# [gp] プッシュ
alias gp='git push'
# [gpush] 現在ブランチをプッシュ
alias gpush='gp origin $(gb --show-current)'
# [gst] ステータス表示
alias gst='git status -s -b'
# [gbd] マージ済みブランチ削除
alias gbd='git branch --merged | grep -Ev "main|master|develop" | xargs -I% git branch -D %'

# aws
# [asl] AWS SSOログイン
alias asl='aws sso login --profile'

# Terraform / Terragrunt
# [tf] terraform
alias tf='terraform'
# [tfi] terraform init (再設定)
alias tfi='terraform init -reconfigure -backend-config=local.tfbackend -upgrade'
# [tfp] terraform plan
alias tfp='terraform plan'
# [tfa] terraform apply
alias tfa='terraform apply'
# [tg] terragrunt
alias tg='terragrunt'
# [tgp] terragrunt plan
alias tgp='terragrunt plan'
# [tgpa] terragrunt plan -all
alias tgpa='terragrunt plan -all'
# [tga] terragrunt apply
alias tga='terragrunt apply'
# [tgaa] terragrunt apply -all
alias tgaa='terragrunt apply -all'

# kubernetes
# [k] kubectl
alias k='kubectl'
# [kg] kubectl get
alias kg='k get'
# [kgp] Pod一覧
alias kgp='kg pod'
# [ks] kustomize
alias ks='kustomize'

# krew plugins
# [kx] コンテキスト切替
alias kx='kubectl ctx'
# [kn] namespace切替
alias kn='kubectl ns'
# [st] ログストリーム (stern)
alias st='kubectl stern'
# [neat] YAML整形出力
alias neat='kubectl neat'
# [knode] ノードにシェル接続
alias knode='kubectl node-shell'
# [ksniff] パケットキャプチャ
alias ksniff='kubectl sniff'
# [kall] 全リソース取得
alias kall='kubectl get-all'
# [ktree] リソースツリー表示
alias ktree='kubectl tree'
# [ktail] 複数Podログ
alias ktail='kubectl tail'
# [kstatus] リソースステータス
alias kstatus='kubectl status'
# [kscore] マニフェストスコア
alias kscore='kubectl score'
# [kex] インタラクティブexec
alias kex='kubectl iexec'
# [kdd] Datadog連携
alias kdd='kubectl datadog'
# [krc] リソースキャパシティ
alias krc='kubectl resource-capacity'
# [krolesum] RBAC要約
alias krolesum='kubectl rolesum'
# [kvu] リソース使用率
alias kvu='kubectl view-utilization'
# [kosvc] サービスをブラウザで開く
alias kosvc='kubectl open-svc'

# Claude Code
# [claude] Claude Code起動
alias claude='mise exec -- claude'
