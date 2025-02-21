-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This var holds the configuration
local config = wezterm.config_builder()

-- Font
config.font_size = 12
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

-- Keybindings
config.keys = {
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- Pane navigation
	{
		key = "h",
		mods = "META|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "META|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "META|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "META|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
}

-- Tabs
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.hide_tab_bar_if_only_one_tab = true

-- Unix domain
config.unix_domains = {
	{
		name = "unix",
	},
}
-- Run `wezterm connect unix` by default
-- config.default_gui_startup_args = { "connect", "unix" }

-- SSH domains
-- Run `wezterm connect <domain_name>` to connect to the remote host
config.ssh_domains = {
	{
		-- Domain name
		name = "lovelace",
		-- Address of the remote host
		remote_address = "lovelace.local",
		-- username on the remote host
		username = "makmiller",
	},
	{
		name = "turing",
		remote_address = "turing.local",
		username = "makmiller",
	},
	{
		name = "leibniz",
		remote_address = "leibniz.local",
		username = "makmiller",
	},
}

-- Return the configuration to wezterm
return config
