local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Macchiato"
--config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font("FiraCode Nerd Font", {weight = "Medium"})
-- config.font = wezterm.font("JetBrains Mono")
config.font_size = 10.0
config.hide_tab_bar_if_only_one_tab = true

return config
