# [ksl] Pod選択 → sternでログ表示 [k8s,fzf,stern]
function ksl() {
  local pod
  pod=$(kubectl get pods --no-headers | fzf --preview 'kubectl logs --tail=50 {1}' | awk '{print $1}')
  if [ -n "$pod" ]; then
    kubectl stern "$pod"
  fi
}

# [gcof] ブランチ選択 → checkout [git,fzf]
function gcof() {
  local branch
  branch=$(git branch -a | fzf --preview 'git log --oneline --graph -20 {1}' | sed 's/^[* ]*//' | sed 's|remotes/origin/||')
  if [ -n "$branch" ]; then
    git checkout "$branch"
  fi
}

# [kyq] kubectl get を yq でフィルタ (例: kyq pods '.items[].metadata.name') [k8s,yq]
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

# [ghpr] PR選択 → ブラウザで開く [gh,fzf]
function ghpr() {
  local pr
  pr=$(gh pr list | fzf --preview 'gh pr view {1}' | awk '{print $1}')
  if [ -n "$pr" ]; then
    gh pr view "$pr" --web
  fi
}

# [ghi] Issue選択 → ブラウザで開く [gh,fzf]
function ghi() {
  local issue
  issue=$(gh issue list | fzf --preview 'gh issue view {1}' | awk '{print $1}')
  if [ -n "$issue" ]; then
    gh issue view "$issue" --web
  fi
}

# Ctrl+R history search is now handled by atuin

# [aic] AIコミットメッセージ生成 (Claude) [git,claude]
function aic() {
  # ステージングされた変更があるか確認
  local staged=$(git diff --cached --stat)
  if [ -z "$staged" ]; then
    echo "Error: No staged changes. Run 'git add' first."
    return 1
  fi

  echo "Generating commit message..."
  local diff=$(git diff --cached)
  local prompt="Generate a concise git commit message for the following diff.
Rules:
- Use conventional commits format (feat:, fix:, docs:, refactor:, etc.)
- Keep the first line under 50 characters
- Be specific about what changed
- Output ONLY the commit message, nothing else
- Do not use code blocks

Diff:
$diff"

  local message=$(claude -p "$prompt" 2>/dev/null)
  if [ -z "$message" ]; then
    echo "Error: Failed to generate commit message."
    return 1
  fi

  echo "\nGenerated message:"
  echo "─────────────────"
  echo "$message"
  echo "─────────────────"
  echo "\n[c]ommit / [e]dit / [r]egenerate / [q]uit?"
  read -k 1 choice
  echo ""

  case "$choice" in
    c)
      git commit -m "$message"
      ;;
    e)
      git commit -e -m "$message"
      ;;
    r)
      aic
      ;;
    *)
      echo "Aborted."
      ;;
  esac
}

# [gi] gitignore生成 (gibo + fzf) [git,gibo,fzf]
function create-gitignore() {
  local output_file="${1:-.gitignore}"

  # giboテンプレート一覧からfzfで選択（複数選択可）
  local selected
  selected=$(gibo list | fzf --multi --preview 'gibo dump {}' --preview-window=right:60% --prompt="gitignore template> ")

  if [ -z "$selected" ]; then
    echo "Cancelled."
    return 0
  fi

  # 選択したテンプレートをファイルに追記
  echo "$selected" | while read -r template; do
    gibo dump "$template" >> "$output_file"
  done

  echo "Generated: $output_file"

  # batがあればカラー表示、なければcat
  if command -v bat &> /dev/null; then
    bat "$output_file"
  else
    cat "$output_file"
  fi
}

# [octo] Octo.nvimを開く (例: octo pr list, octo issue 123) [nvim,octo,github]
function octo() {
  if [ $# -eq 0 ]; then
    nvim +Octo
  else
    nvim "+Octo $*"
  fi
}

# [af] alias/function 一覧表示 + fzf検索 [fzf,cheatsheet]
function af() {
  local zsh_dir="$HOME/.zshrc.d"
  local selected
  selected=$(
    grep -E "^# \[.+\]" "$zsh_dir/alias.zsh" "$zsh_dir/function.zsh" 2>/dev/null \
      | sed 's|.*:# \[\([^]]*\)\] \(.*\)|\1\t\2|' \
      | column -t -s $'\t' \
      | fzf --prompt="alias/function> " --height=100%
  )
  if [ -n "$selected" ]; then
    local cmd=$(echo "$selected" | awk '{print $1}')
    print -z "$cmd"
  fi
}

# [y] yazi終了時にカレントディレクトリを変更 [yazi]
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
