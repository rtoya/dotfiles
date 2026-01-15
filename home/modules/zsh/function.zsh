# fzf + kubernetes
function ksl() {
  local pod
  pod=$(kubectl get pods --no-headers | fzf --preview 'kubectl logs --tail=50 {1}' | awk '{print $1}')
  if [ -n "$pod" ]; then
    kubectl stern "$pod"
  fi
}

# git branch + fzf: ブランチを選択してチェックアウト
function gcof() {
  local branch
  branch=$(git branch -a | fzf --preview 'git log --oneline --graph -20 {1}' | sed 's/^[* ]*//' | sed 's|remotes/origin/||')
  if [ -n "$branch" ]; then
    git checkout "$branch"
  fi
}

# kubectl + yq: リソースを取得してyqでフィルタリング
function kyq() {
  local resource="$1"
  local filter="${2:-.}"
  if [ -z "$resource" ]; then
    echo "Usage: kyq <resource> [yq-filter]"
    echo "Example: kyq pods '.items[].metadata.name'"
    return 1
  fi
  kubectl get "$resource" -o yaml | yq "$filter"
}

# gh + fzf: PRを選択してブラウザで開く
function ghpr() {
  local pr
  pr=$(gh pr list | fzf --preview 'gh pr view {1}' | awk '{print $1}')
  if [ -n "$pr" ]; then
    gh pr view "$pr" --web
  fi
}

# gh + fzf: Issueを選択してブラウザで開く
function ghi() {
  local issue
  issue=$(gh issue list | fzf --preview 'gh issue view {1}' | awk '{print $1}')
  if [ -n "$issue" ]; then
    gh issue view "$issue" --web
  fi
}

# history + peco: コマンド履歴を検索して実行
function h() {
  local cmd
  cmd=$(history -n 1 | tail -r | peco --query "$1")
  if [ -n "$cmd" ]; then
    print -z "$cmd"
  fi
}

# Ctrl+R用のZLEウィジェット
function _peco_history_widget() {
  local cmd
  cmd=$(history -n 1 | tail -r | peco --query "$LBUFFER")
  if [ -n "$cmd" ]; then
    BUFFER="$cmd"
    CURSOR=$#BUFFER
  fi
  zle reset-prompt
}
zle -N _peco_history_widget
bindkey '^r' _peco_history_widget
