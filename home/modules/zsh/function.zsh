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

# [rdspw] RDSクラスタ選択 → マスターパスワード取得 (fzf) [aws,rds,fzf,secretsmanager]
function rdspw() {
  local profile="" show=0
  while [ $# -gt 0 ]; do
    case "$1" in
      -p|--profile) profile="$2"; shift 2 ;;
      -s|--show)    show=1; shift ;;
      -h|--help)
        cat <<'USAGE'
Usage: rdspw [-p|--profile <profile>] [-s|--show]

  RDSクラスタをfzfで選択し、マスターパスワードを取得してクリップボードにコピーする。
  MasterUserSecret(RDS管理シークレット)があればそこから取得し、
  無い場合はSecrets Manager / SSM Parameter Storeの候補をfzfで選択する。

Options:
  -p, --profile   AWSプロファイル (省略時は $AWS_PROFILE、未設定ならfzfで選択)
  -s, --show      パスワードをマスクせず標準出力に表示する
USAGE
        return 0 ;;
      *) profile="$1"; shift ;;
    esac
  done

  local cmd
  for cmd in aws jq fzf; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found." >&2; return 1; }
  done

  # プロファイル決定
  [ -z "$profile" ] && profile="${AWS_PROFILE:-}"
  if [ -z "$profile" ]; then
    profile=$(aws configure list-profiles | fzf --prompt='AWS Profile> ' --height=40%)
    [ -z "$profile" ] && { echo "Cancelled."; return 0; }
  fi

  # 認証確認（期限切れならSSOログインを提案）
  if ! aws sts get-caller-identity --profile "$profile" >/dev/null 2>&1; then
    echo "Credentials for '$profile' are invalid or expired."
    if read -q "?Run 'aws sso login --profile $profile'? [y/N] "; then
      echo ""
      aws sso login --profile "$profile" || return 1
    else
      echo ""
      return 1
    fi
  fi

  local tmp
  tmp=$(mktemp -t rdspw.XXXXXX) || return 1
  if ! aws rds describe-db-clusters --profile "$profile" --output json >"$tmp" 2>/dev/null; then
    echo "Error: failed to describe DB clusters (profile: $profile)." >&2
    rm -f "$tmp"
    return 1
  fi

  local cluster
  cluster=$(
    jq -r '.DBClusters[] | [.DBClusterIdentifier, .Engine, .MasterUsername, .Status] | @tsv' "$tmp" \
      | column -t -s $'\t' \
      | fzf --prompt='RDS Cluster> ' --height=80% \
            --preview "jq -r --arg id {1} '.DBClusters[] | select(.DBClusterIdentifier==\$id) | {DBClusterIdentifier, Engine, EngineVersion, Endpoint, ReaderEndpoint, Port, DatabaseName, MasterUsername, Status, MasterUserSecret: (.MasterUserSecret.SecretArn // \"none\")}' $tmp" \
            --preview-window=right:55% \
      | awk '{print $1}'
  )
  if [ -z "$cluster" ]; then
    echo "Cancelled."
    rm -f "$tmp"
    return 0
  fi

  local username endpoint port secret_arn
  username=$(jq -r --arg id "$cluster" '.DBClusters[] | select(.DBClusterIdentifier==$id) | .MasterUsername' "$tmp")
  endpoint=$(jq -r --arg id "$cluster" '.DBClusters[] | select(.DBClusterIdentifier==$id) | .Endpoint' "$tmp")
  port=$(jq -r --arg id "$cluster" '.DBClusters[] | select(.DBClusterIdentifier==$id) | .Port' "$tmp")
  secret_arn=$(jq -r --arg id "$cluster" '.DBClusters[] | select(.DBClusterIdentifier==$id) | .MasterUserSecret.SecretArn // empty' "$tmp")
  rm -f "$tmp"

  local password="" source_desc=""
  if [ -n "$secret_arn" ]; then
    # RDS管理シークレット: {"username":"...","password":"..."}
    local secret_string
    secret_string=$(aws secretsmanager get-secret-value --profile "$profile" \
      --secret-id "$secret_arn" --query SecretString --output text 2>/dev/null)
    if [ -z "$secret_string" ]; then
      echo "Error: failed to read secret: $secret_arn" >&2
      return 1
    fi
    password=$(printf '%s' "$secret_string" | jq -r '.password // empty' 2>/dev/null)
    source_desc="secretsmanager: ${secret_arn##*:secret:}"
  else
    # 管理シークレット無し: Secrets Manager / SSM から候補を選択
    echo "No MasterUserSecret on '$cluster'. Searching Secrets Manager / SSM..."
    local candidates selected kind name
    candidates=$(
      {
        aws secretsmanager list-secrets --profile "$profile" \
          --query 'SecretList[].Name' --output text 2>/dev/null \
          | tr '\t' '\n' | sed 's|^|secretsmanager\t|'
        aws ssm describe-parameters --profile "$profile" \
          --query 'Parameters[].Name' --output text 2>/dev/null \
          | tr '\t' '\n' | sed 's|^|ssm\t|'
      } | sed '/^\(secretsmanager\|ssm\)\t$/d'
    )
    if [ -z "$candidates" ]; then
      echo "Error: no secrets or parameters found in profile '$profile'." >&2
      return 1
    fi
    # クラスタ名から環境名/サービス名を初期クエリにする (例: wevox-prd-front-cluster -> front)
    local hint
    hint=$(printf '%s' "$cluster" | sed -E 's/-cluster$//; s/^[a-z0-9]+-(prd|prod|stg|dev)-//')
    selected=$(printf '%s\n' "$candidates" | column -t -s $'\t' \
      | fzf --prompt='Secret> ' --height=60% --query "$hint")
    [ -z "$selected" ] && { echo "Cancelled."; return 0; }
    kind=$(printf '%s' "$selected" | awk '{print $1}')
    name=$(printf '%s' "$selected" | awk '{print $2}')
    case "$kind" in
      secretsmanager)
        local raw
        raw=$(aws secretsmanager get-secret-value --profile "$profile" \
          --secret-id "$name" --query SecretString --output text 2>/dev/null)
        password=$(printf '%s' "$raw" | jq -r '.password // .PASSWORD // empty' 2>/dev/null)
        [ -z "$password" ] && password="$raw"
        ;;
      ssm)
        password=$(aws ssm get-parameter --profile "$profile" --name "$name" \
          --with-decryption --query Parameter.Value --output text 2>/dev/null)
        ;;
    esac
    source_desc="$kind: $name"
  fi

  if [ -z "$password" ]; then
    echo "Error: could not extract a password." >&2
    return 1
  fi

  printf '%s' "$password" | pbcopy
  echo ""
  echo "cluster   : $cluster"
  echo "endpoint  : $endpoint:$port"
  echo "username  : $username"
  echo "source    : $source_desc"
  if [ "$show" -eq 1 ]; then
    echo "password  : $password"
  else
    echo "password  : ${password:0:2}$(printf '%*s' $(( ${#password} - 2 )) '' | tr ' ' '*')  (copied to clipboard)"
  fi
}
