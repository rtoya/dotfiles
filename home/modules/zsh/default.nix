{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # シンプルなプロンプト
      PROMPT='$ '

      # Load split zsh configs
      if [ -d "$HOME/.zshrc.d" ]; then
        for f in "$HOME/.zshrc.d"/*.zsh; do
          [ -r "$f" ] && source "$f"
        done
      fi
    '';
  };

  home.file.".zshrc.d".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/home/modules/zsh";
  home.file.".zshrc.d".recursive = true;
}
