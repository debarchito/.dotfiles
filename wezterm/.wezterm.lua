local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.window_decorations = "RESIZE"
config.font_size = 13.0
config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"

return config
