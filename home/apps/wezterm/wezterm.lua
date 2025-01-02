local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.max_fps = 120
config.font_size = 13.0
config.front_end = "WebGpu"
config.default_prog = { "fish" }
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

return config
