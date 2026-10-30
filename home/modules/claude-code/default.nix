{ config, pkgs, lib, ... }:
{
  # Claude Code本体は自動更新を効かせるため、Nixではなく公式のネイティブインストーラで入れる
  # (~/.local/bin/claude に配置される。PATHは zsh/basic.zsh で追加済み)
  home.activation.installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -x "$HOME/.local/bin/claude" ]; then
      export PATH="${pkgs.curl}/bin:${pkgs.bash}/bin:/usr/bin:/bin:$PATH"
      echo "Installing Claude Code..."
      $DRY_RUN_CMD bash -c "curl -fsSL https://claude.ai/install.sh | bash" \
        || echo "Failed to install Claude Code, skipping..."
    fi
  '';
}
