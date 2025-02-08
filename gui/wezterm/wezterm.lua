-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This var holds the configuration
local config = wezterm.config_builder()

-- Font
config.font_size = 12.0
config.font = wezterm.font("Hack Nerd Font")
-- config.line_height = 1.2

-- Opacity
config.window_background_opacity = 0.95

-- Color scheme
config.color_scheme = "GruvboxDark"

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Tabs
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.hide_tab_bar_if_only_one_tab = true

-- Return the configuration to wezterm
return config
