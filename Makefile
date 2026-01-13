.PHONY: install-nix setup-flakes switch setup

# Nixをインストール
install-nix:
	@if command -v nix >/dev/null 2>&1; then \
		echo "Nix is already installed, skipping..."; \
	else \
		curl -L https://nixos.org/nix/install | sh; \
	fi

# Flakes機能を有効化
setup-flakes:
	@if [ -f ~/.config/nix/nix.conf ] && grep -q 'experimental-features.*flakes' ~/.config/nix/nix.conf 2>/dev/null; then \
		echo "Flakes is already enabled, skipping..."; \
	else \
		mkdir -p ~/.config/nix; \
		echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf; \
		echo "Flakes enabled"; \
	fi

# 設定を適用
switch:
	nix run github:nix-community/home-manager -- switch -b backup --flake .#mbp

# 初回セットアップ（Nix未インストールの場合）
setup: install-nix setup-flakes switch
