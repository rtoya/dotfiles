local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- colors
config.color_scheme = "nord"
config.window_background_opacity = 0.90

-- font
-- config.font = wezterm.font("Firge35Nerd Console")
config.font_size = 13.0

config.color_scheme = 'AdventureTime'
return config
