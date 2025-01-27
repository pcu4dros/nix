# Steps to configure

## Install Nix

Install nix using the following command:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## Clone this repo

```bash
git clone git@github.com:pcu4dros/nix.git
```

## Run nix configuration

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" 
--switch --flake ~/nix#mini
```

## Validate darwin-rebuild command

Type the following command:

```bash
which darwin-rebuild
```

If everything has been done correctly, the following path is displayed:

```bash
/run/current-system/sw/bin/darwin-rebuild
```

## Re-building the configuration

```bash
darwin-rebuild switch --flake ~/nix#mini

