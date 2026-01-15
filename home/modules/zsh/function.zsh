# [ksl] Pod選択 → sternでログ表示
function ksl() {
  local pod
  pod=$(kubectl get pods --no-headers | fzf --preview 'kubectl logs --tail=50 {1}' | awk '{print $1}')
  if [ -n "$pod" ]; then
    kubectl stern "$pod"
  fi
}

# [gcof] ブランチ選択 → checkout
function gcof() {
  local branch
  branch=$(git branch -a | fzf --preview 'git log --oneline --graph -20 {1}' | sed 's/^[* ]*//' | sed 's|remotes/origin/||')
  if [ -n "$branch" ]; then
    git checkout "$branch"
  fi
}

# [kyq] kubectl get を yq でフィルタ (例: kyq pods '.items[].metadata.name')
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

# [ghpr] PR選択 → ブラウザで開く
function ghpr() {
  local pr
  pr=$(gh pr list | fzf --preview 'gh pr view {1}' | awk '{print $1}')
  if [ -n "$pr" ]; then
    gh pr view "$pr" --web
  fi
}

# [ghi] Issue選択 → ブラウザで開く
function ghi() {
  local issue
  issue=$(gh issue list | fzf --preview 'gh issue view {1}' | awk '{print $1}')
  if [ -n "$issue" ]; then
    gh issue view "$issue" --web
  fi
}

# [h] 履歴検索 (peco)
function h() {
  local cmd
  cmd=$(history -n 1 | tail -r | peco --query "$1")
  if [ -n "$cmd" ]; then
    print -z "$cmd"
  fi
}

# Ctrl+R用のZLEウィジェット (内部関数)
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

# [af] alias/function 一覧表示 + fzf検索 → 選択でコマンドラインにセット
function af() {
  local zsh_dir="$HOME/.zshrc.d"
  local selected
  selected=$(
    grep -E "^# \[.+\]" "$zsh_dir/alias.zsh" "$zsh_dir/function.zsh" 2>/dev/null \
      | sed 's|.*:# \[\([^]]*\)\] \(.*\)|\1\t\2|' \
      | column -t -s $'\t' \
      | fzf --prompt="alias/function> " --height=100% --layout=reverse
  )
  if [ -n "$selected" ]; then
    local cmd=$(echo "$selected" | awk '{print $1}')
    print -z "$cmd"
  fi
}
