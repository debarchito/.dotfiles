local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.max_fps = 120
config.font_size = 13.0
config.front_end = "WebGpu"
config.enable_tab_bar = false
config.default_prog = { "fish" }
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false

return config
