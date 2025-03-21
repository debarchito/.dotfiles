# .dotfiles

The **(.)dotfiles** for my **Pop!_OS** setup.

# Usage

Install _Nix_ using the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer).

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Then, you can simply run:

```sh
git clone https://github.com/debarchito/.dotfiles.git ~
cd .dotfiles
chmod +x setup*.sh
./setup.sh
```

Optionally, the _proprietary_ fonts can be installed using the following command:

```sh
./setup-fonts.sh
```

I kept this step separate because I don't need these fonts all the time.

# Additional Links (Optional)

- **LibreWolf (addons outside the base configuration)**
  - [Firefox Color Theme (Catppuccin Mocha Mauve)](https://color.firefox.com/?theme=XQAAAAJEBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcajvXaAE3RJ0F_F447xQs-L1kFlGgDKq4IIvWciiy4upusW7OvXIRinrLrwLvjXB37kvhN5ElayHo02fx3o8RrDShIhRpNiQMOdww5V2sCMLAfehhpkvCNGPFQ9qpGpx7BgGSYPGUMFXC1Ua9FaxHdWOc93hEJrTCm7pTY2gENlkIGOUk-0q5koU7B1u0Ej-oMph40xEOeck_YUJD52Bwer09STdlto8FTe2opihD2FyRdpJyZydtlY3dK_RO373JUB4GPAs2saJone2-92ozhdZDXTzFe1BzECDYiTLKw8wgkHlYGBfEaHwiRhB6Xx67wrqMSr8VhLm8d-NCA1DySJVtxxWJN-qabWQpDds2gw6dhs97Ngt5Z_6ZhJ5vv31xfjj2v6iK816VOdJaIaQu4xsqHAytxXRLJQ8LtmF0BsXZI5kUVsRJUHALGJAvl388n-yyQfaq8ZWuCO1uYG0bY0rpdgDBrLU8Zs70Yys-ht5xVnF2swtAuEg4AJnPqvbES86v_PMIzk)
  - [LanguageTool (Extension)](https://addons.mozilla.org/en-US/firefox/addon/languagetool/)
  - [Don't track me Google (Extension)](https://addons.mozilla.org/en-US/firefox/addon/dont-track-me-google1/)
  - [Dictionary Everywhere (Extension)](https://addons.mozilla.org/en-US/firefox/addon/dictionary-anyvhere/)

# License

[MIT](/LICENSE)
