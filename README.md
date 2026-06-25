## 0. Showcase (dell-laptop)

![showcase (dell-laptop)](/media/one.png)

I didn't know what to add so I present an image of the host `dell-laptop` that I
daily drive. It's a configuration for [Niri](https://github.com/niri-wm/niri) +
[DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) adjusted
to fit my personal layout, color and functionality preferences.

## 1. Preparation (TODO)

Apply the disk layout using [disko](https://github.com/nix-community/disko):

> [!WARNING]\
> This will erase all existing data on disk!

```fish
run0 nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-community/disko/latest -- --mode destroy,format,mount \
  ./modules/hosts/<host>/_raw/disko-configuration.nix
```

> NOTE: Disko is not yet integrated with the broader configuration. It's part of
> a future plan.\
> TODO: I need to write more steps...

## 2. Applying the configurations

Clone this repository to `~/.dotfiles`. This is the assumption throughout the
steps.

```
git clone https://git.sr.ht/~debarchito/.dotfiles ~/.dotfiles
# or
git clone git@git.sr.ht:~debarchito/.dotfiles ~/.dotfiles
```

Fresh installs generate their fresh `/etc/nixos/hardware-configuration.nix`.
This is the configuration your system should build against. Override the old
hardware configuration using:

```fish
cp /etc/nixos/hardware-configuration.nix ~/.dotfiles/modules/hosts/<host>/_raw/hardware-configuration.nix
# DO NOT REPLACE ~/.dotfiles/modules/hosts/<host>/hardware-configuration.nix by mistake! Notice the "_raw".
```

When applying the NixOS configuration for the _first time_, pass these options
temporarily:

```fish
cd ~/.dotfiles
run0 nixos-rebuild switch --flake .#<host> \
  --option experimental-features \
    'nix-command flakes' \
  --option extra-substituters \
    'https://install.determinate.systems https://attic.xuyh0120.win/lantian' \
  --option extra-trusted-public-keys \
    'cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc='
```

This is 'cause the configuration depends on
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

The first activation is going to take a bit of time since it installs the
[Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git)
during this stage.

## 3. Templates

This repo also contains a templating engine alongside tailored development
templates. Get started using:

```fish
nix run sourcehut:~debarchito/.dotfiles#generate
```

Initialize a template (e.g Rust) using:

```fish
nix run sourcehut:~debarchito/.dotfiles#generate \
    rust ./hello-world \
    name="hello-world" description="Say hello to the world!"
```

Then run using:

```fish
nix run ./hello-world
```

## 4. Licensing

The repository is licensed under the [zlib](/LICENSE) license unless stated
otherwise.
