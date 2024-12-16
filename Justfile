set shell := ["fish", "-c"]

default:
    @just --list

alias hs := home-switch
home-switch:
    home-manager switch --flake . --impure --show-trace

alias ss := system-switch
system-switch:
    sudo (which nix) run 'github:numtide/system-manager' -- switch --flake .
