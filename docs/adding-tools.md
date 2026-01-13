# ツール追加ガイド

このリポジトリでは、4つのパターンでツールを追加できます。

## パターン1: パッケージのみ追加（最もシンプル）

設定ファイルが不要なCLIツールの場合。

### 手順

`home/home.nix` の `home.packages` にパッケージを追加:

```nix
home.packages = with pkgs; [
  awscli2
  eza
  git
  # ここに追加
  ripgrep  # 追加例
];
```

### 例

eza, tree, xh, gat, kubectl

---

## パターン2: 設定ファイル付きツール（シンボリンク）

独自の設定ファイルを持つツールの場合。設定ファイルをGit管理しつつ、適切な場所にシンボリンクを作成。

### 手順

1. モジュールディレクトリを作成:
   ```
   home/modules/<tool>/
   ├── default.nix      # Nix設定
   └── <config-file>    # 設定ファイル（例: config.toml）
   ```

2. `default.nix` を作成:
   ```nix
   { config, ... }:
   {
     xdg.configFile."<tool>/<config-file>".source =
       config.lib.file.mkOutOfStoreSymlink
         "${config.home.homeDirectory}/dotfiles/home/modules/<tool>/<config-file>";
   }
   ```

3. `home/home.nix` の `toolDirs` にパスを追加:
   ```nix
   toolDirs = [ ./modules/wezterm ./modules/mise ./modules/<tool> ];
   ```

### 例

mise, wezterm

### ポイント

- `mkOutOfStoreSymlink` を使用することで、設定ファイルを編集してもNix再ビルドなしで反映される
- XDG準拠のツールは `xdg.configFile` を使用
- それ以外は `home.file` を使用

---

## パターン3: Home Manager組み込みプログラム

Home Managerが公式サポートするプログラムの場合。`programs.<name>` で設定可能。

### 手順

`home/home.nix` に設定を追加:

```nix
programs.git = {
  enable = true;
  settings = {
    user.name = "your-name";
    user.email = "your-email@example.com";
  };
};
```

### 例

git, gh, fzf, zsh

### サポート一覧確認

```bash
# Home Managerのオプション検索
nix-shell -p home-manager --run "home-manager option programs"
```

または [Home Manager Options](https://nix-community.github.io/home-manager/options.html) を参照。

---

## パターン4: カスタムオプション付きモジュール（高度）

再利用可能なオプション付きモジュールを作成する場合。

### 手順

1. `home/modules/<tool>/default.nix` を作成:
   ```nix
   { config, pkgs, lib, ... }:

   let
     cfg = config.programs.<tool>;
   in
   {
     options.programs.<tool> = {
       enable = lib.mkEnableOption "<tool> description";

       # カスタムオプション
       plugins = lib.mkOption {
         type = lib.types.listOf lib.types.str;
         default = [ ];
         description = "List of plugins to install";
       };
     };

     config = lib.mkIf cfg.enable {
       home.packages = [ pkgs.<tool> ];

       # アクティベーションスクリプト等
       home.activation.install<Tool>Plugins = lib.mkIf (cfg.plugins != [ ]) (
         lib.hm.dag.entryAfter [ "writeBoundary" ] ''
           # インストールスクリプト
         ''
       );
     };
   }
   ```

2. `home/home.nix` で使用:
   ```nix
   programs.<tool> = {
     enable = true;
     plugins = [ "plugin1" "plugin2" ];
   };
   ```

### 例

krew

---

## パターン選択フローチャート

```
ツールを追加したい
    │
    ├─ 設定不要 → パターン1（パッケージのみ）
    │
    ├─ 設定ファイルあり
    │   │
    │   ├─ Home Manager対応 → パターン3（組み込み）
    │   │
    │   └─ 非対応 → パターン2（シンボリンク）
    │
    └─ 複雑な初期化/オプションが必要 → パターン4（カスタム）
```

---

## 変更の適用

```bash
make switch
```

または

```bash
nix run github:nix-community/home-manager -- switch --flake .#mbp
```
