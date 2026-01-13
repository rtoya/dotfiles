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
    ├── home.nix           # メイン設定（パッケージ、プログラム設定）
    ├── hosts/
    │   └── mbp.nix        # MacBook Pro固有設定
    └── modules/
        ├── krew/
        │   └── default.nix       # krewモジュール（kubectlプラグイン管理）
        ├── mise/
        │   ├── default.nix       # miseモジュール
        │   └── config.toml       # mise設定ファイル
        ├── nixvim/
        │   └── default.nix       # NixVimモジュール（Neovim設定）
        ├── wezterm/
        │   ├── default.nix       # Weztermモジュール
        │   └── wezterm.lua       # Wezterm設定ファイル
        └── zsh/
            ├── default.nix       # zshモジュール
            ├── alias.zsh         # エイリアス定義
            ├── basic.zsh         # 基本設定
            └── function.zsh      # カスタム関数
```

## コマンド

```bash
# 設定を適用
nix run github:nix-community/home-manager -- switch --flake .#mbp

# flake.lockを更新
nix flake update
```

## 開発ワークフロー

1. 設定ファイル（`.nix`または`home/modules/`内のファイル）を編集
2. `nix run github:nix-community/home-manager -- switch --flake .#mbp`で適用
3. 変更をコミット

## 管理対象ツール

### パッケージ（home.packages）
- **awscli2**: AWS CLI
- **eza**: ls代替コマンド
- **gat**: catのシンタックスハイライト版
- **git**: バージョン管理
- **kubectl**: Kubernetes CLI
- **kustomize**: Kubernetesマニフェスト管理
- **mise**: 開発ツールバージョン管理
- **tree**: ディレクトリツリー表示
- **xh**: HTTPリクエストツール

### プログラム（programs.*）
- **fzf**: ファジーファインダー
- **gh**: GitHub CLI
- **krew**: kubectlプラグインマネージャー
- **mise**: 開発ツールバージョン管理（claude-code等）

### モジュール（home/modules/）
- **nixvim**: Neovim設定（Nix管理）
- **wezterm**: ターミナルエミュレーター
- **zsh**: シェル設定（Starshipプロンプト）

### その他
- **moralerspace**: プログラミング用日本語フォント

## 新しいモジュールの追加方法

1. `home/modules/<tool>/default.nix`にモジュールを作成
2. 必要に応じて同ディレクトリに設定ファイルを配置（例: `config.toml`, `*.lua`）
3. `home/home.nix`の`toolDirs`リストにパスを追加
