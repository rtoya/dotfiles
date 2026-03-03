# [zeno] zeno.zsh initialization [zsh,zeno,fzf]

# environment variables (must be set BEFORE sourcing zeno.zsh)
export ZENO_HOME="$HOME/.config/zeno"
export ZENO_ENABLE_SOCK=1
export ZENO_GIT_CAT="bat --color=always"
export ZENO_GIT_TREE="eza --tree"

# zeno.zsh source
if [ -d "$HOME/.local/share/zeno.zsh" ]; then
  source "$HOME/.local/share/zeno.zsh/zeno.zsh"
fi

# key bindings (after zeno.zsh loaded)
if (( $+functions[zeno-auto-snippet] )); then
  # space: auto snippet expansion
  bindkey ' ' zeno-auto-snippet

  # enter: expand snippet and accept line
  bindkey '^m' zeno-auto-snippet-and-accept-line

  # tab: use zeno-completion only with Ctrl+X Tab to avoid syntax-highlighting conflict
  bindkey '^x^i' zeno-completion

  # ctrl+r: history selection is now handled by atuin
  # bindkey '^r' zeno-history-selection

  # ctrl+x ctrl+m: accept line without snippet expansion
  bindkey '^x^m' accept-line

  # ctrl+x ctrl+z: toggle auto snippet
  bindkey '^x^z' zeno-toggle-auto-snippet

  # ctrl+x v: insert snippet
  bindkey '^xv' zeno-insert-snippet
fi
