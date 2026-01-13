# dotfiles

## Setup

### Install Nix

```sh
curl -L https://nixos.org/nix/install | sh
```

### Activate flake

```sh
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF
```
