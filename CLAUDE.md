# CLAUDE.md

このファイルはClaude Codeがこのリポジトリを操作する際のガイドです。

## プロジェクト概要

Nix Flakes + Home Managerを使用したmacOS（Apple Silicon/aarch64-darwin）向けdotfiles管理システム。

## ディレクトリ構造

```
dotfiles/
├── flake.nix              # Nix Flakeエントリーポイント（依存関係・プロファイル定義）
├── flake.lock             # 依存関係ロックファイル
└── home/
    ├── home.nix           # メイン設定（パッケージ、シェル、Git等）
    ├── hosts/
    │   └── mbp.nix        # MacBook Pro固有設定
    ├── modules/
    │   ├── mise.nix       # miseモジュール
    │   └── wezterm.nix    # Weztermモジュール
    ├── files/
    │   ├── mise/config.toml    # mise設定
    │   └── wezterm/wezterm.lua # Wezterm設定
    └── zshrc.d/
        └── alias.zsh      # シェルエイリアス
```

## コマンド

```bash
# 設定を適用
nix run github:nix-community/home-manager -- switch --flake .#mbp

# flake.lockを更新
nix flake update
```

## 開発ワークフロー

1. 設定ファイル（`.nix`または`home/files/`内のファイル）を編集
2. `nix run github:nix-community/home-manager -- switch --flake .#mbp`で適用
3. 変更をコミット

## 管理対象ツール

- **mise**: 開発ツールバージョン管理（claude-code等）
- **Wezterm**: ターミナルエミュレーター
- **zsh**: シェル（Starshipプロンプト）
- **eza**: ls代替コマンド
- **git**: バージョン管理
- **gh**: GitHub CLI

## 新しいモジュールの追加方法

1. `home/modules/<tool>.nix`にモジュールを作成
2. 必要に応じて`home/files/<tool>/`に設定ファイルを配置
3. `home/home.nix`の`imports`に追加される（ディレクトリ自動読み込み）
