.PHONY: install-nix install-homebrew prepare switch setup

# 初回はシェルにPATHが通っていないため、フルパスで参照する
NIX := /nix/var/nix/profiles/default/bin/nix
DARWIN_REBUILD := /run/current-system/sw/bin/darwin-rebuild
BREW := /opt/homebrew/bin/brew

# Nixをインストール
install-nix:
	@if [ -x $(NIX) ]; then \
		echo "Nix is already installed, skipping..."; \
	else \
		curl -L https://nixos.org/nix/install | sh; \
	fi

# Homebrewをインストール（nix-darwinのhomebrewモジュールはbrew本体を入れない）
install-homebrew:
	@if [ -x $(BREW) ]; then \
		echo "Homebrew is already installed, skipping..."; \
	else \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

# 初回activationで失敗しやすい箇所を事前に整える
prepare:
	@# nix-darwinは/etc/synthetic.confが存在する前提で動く
	@if [ ! -f /etc/synthetic.conf ]; then \
		echo "Creating /etc/synthetic.conf..."; \
		echo 'nix' | sudo tee /etc/synthetic.conf >/dev/null; \
		sudo chmod 644 /etc/synthetic.conf; \
	fi
	@# ~/.configがroot所有だとhome-managerがリンクを作れない
	@if [ -d "$$HOME/.config" ] && [ -n "$$(find "$$HOME/.config" -user root -print -quit)" ]; then \
		echo "Fixing ownership of ~/.config..."; \
		sudo chown -R "$$(id -un)":staff "$$HOME/.config"; \
	fi

# 設定を適用（nix-darwin経由でhome-manager + homebrewも管理）
switch:
	@if [ -x $(DARWIN_REBUILD) ]; then \
		sudo $(DARWIN_REBUILD) switch --flake .#mbp; \
	else \
		echo "darwin-rebuild not found, bootstrapping via nix run..."; \
		sudo $(NIX) --extra-experimental-features 'nix-command flakes' \
			run --inputs-from . nix-darwin -- switch --flake .#mbp; \
	fi

# 初回セットアップ
setup: install-nix install-homebrew prepare switch
