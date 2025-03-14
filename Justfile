set shell := ["fish", "-c"]

default:
    @just --list

alias hs := home-switch
home-switch:
    nix run home-manager/master -- switch --flake . --impure --show-trace

alias ss := system-switch
system-switch:
    sudo (which nix) run 'github:numtide/system-manager' -- switch --flake .

alias fmt := format
format:
    nix fmt **/*.nix

syncthing-up:
    docker compose -f compose/syncthing-docker-compose.yml up -d

syncthing-down:
    docker compose -f compose/syncthing-docker-compose.yml down

alias clean := clear
clear:
    nix store gc
