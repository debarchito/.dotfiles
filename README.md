## 1. Installation (TODO)

Apply the disk layout using [disko](https://github.com/nix-community/disko):

> [!WARNING]\
> This will erase all existing data on disk!

```fish
run0 nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-community/disko/latest -- --mode destroy,format,mount \
  ./modules/hosts/<host>/_raw/disko-configuration.nix
```

> TODO: I need to write more steps...

## 2. Applying configuration

When applying the NixOS configuration for the _first time_, pass these options
temporarily:

```fish
run0 nixos-rebuild switch --flake .#<host> \
  --option extra-substituters \
    "https://install.determinate.systems https://attic.xuyh0120.win/lantian" \
  --option extra-trusted-public-keys \
    "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
```

This is 'cause it depends on
[Determinate Nix](https://docs.determinate.systems/determinate-nix) and the
CachyOS kernel from
[xddxdd/nix-cachyos-kernel](https://github.com/xddxdd/nix-cachyos-kernel).
Substituters are required to avoid compiling these packages locally.

Once done, subsequent applications can be triggered using:

```fish
run0 nixos-rebuild switch --flake .#<host>
```

The [nh](https://github.com/nix-community/nh) utility is also available as an
alternative ([NH_FLAKE](https://github.com/nix-community/nh#nixos) is set to
`~/.dotfiles`):

```fish
nh os switch -c <host>
```

Now, apply the Home-Manager configuration using:

```fish
home-manager switch --flake .#<user>@<host>
# or:
nh home switch -c <user>@<host>
```

Lastly, run the setup script to apply all the impure adjustments:

```fish
nix run .#impure-setup
```

## 3. Templates

This repo also contains a templating engine alongside tailored development
templates. Get started using:

```fish
nix run github:debarchito/.dotfiles#generate
```

Initialize a template (e.g Rust) using:

```fish
nix run github:debarchito/.dotfiles#generate rust ./hello-world name="hello-world" description="Say hello to the world!"
```

Then run using:

```fish
nix run ./hello-world
```

## 4. Licensing

The repository is licensed under the [zlib](/LICENSE) license unless stated
otherwise.
