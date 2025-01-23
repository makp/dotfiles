conky.config = {
	-- out_to_x = no,
	-- out_to_wayland = yes,
	alignment = "top_left",
	gap_x = 30, -- add padding to the left
	gap_y = 30,
	xftalpha = 0.8,

	-- options for preventing flickering
	double_buffer = true, -- double-buffer extension (DBE) support -- update window fast enough

	-- font
	use_xft = true,
	font = "Hack Nerd Font:size=9",

	-- windows settings
	own_window = true,
	own_window_type = "override",
	own_window_transparent = true,
	own_window_hints = "undecorated,below,sticky,skip_taskbar,skip_pager",

	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	stippled_borders = 1,
	--border_margin 1
	border_width = 1,
	default_shade_color = "black",
	default_outline_color = "black",

	use_spacer = "none",
	no_buffers = true,
	uppercase = false,
	update_interval = 3, -- seconds

	maximum_width = 250, -- pixels

	-- colors
	color1 = "gray23",
	color5 = "9F9F1A",
}

conky.text = [[
#
# Internet
#
${color1}${font Hack Nerd Font:size=16}${font}   ${upspeed wlp2s0}${color1}
${upspeedgraph wlp2s0 20 darkred white}
${font Hack Nerd Font:size=16}${font}   ${downspeed wlp2s0}
${downspeedgraph wlp2s0 20 darkred white}
${font Hack Nerd Font:size=14}${font}   ${wireless_link_qual_perc wlp2s0} %
${wireless_link_bar wlp2s0}


#
# CPU
#
${color 10470e}${font Hack Nerd Font:size=16} ${font}${hwmon 0 temp 1} C; ${font} Gov.: ${execi 5 head /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor}
${loadgraph 20 000000 ffffff yellow -t}
${font}Load: ${loadavg}

${cpugraph 20 000000 ffffff}
Core 0: ${cpubar cpu0 7,145}  ${freq 1}MHz ${cpu cpu0}%
Core 1: ${cpubar cpu1 7,145}  ${freq 2}MHz ${cpu cpu1}%
Core 2: ${cpubar cpu2 7,145}  ${freq 3}MHz ${cpu cpu2}%
Core 3: ${cpubar cpu3 7,145}  ${freq 4}MHz ${cpu cpu3}%
# Core 0: ${cpu cpu0}% ${cpubar cpu0 8,115} ${freq 1}MHz
# Core 1: ${cpu cpu1}% ${cpubar cpu1 8,115} ${freq 2}MHz
# Core 2: ${cpu cpu2}% ${cpubar cpu2 8,115} ${freq 3}MHz
# Core 3: ${cpu cpu3}% ${cpubar cpu3 8,115} ${freq 4}MHz

${hr 1}
${color darkred}${top name 1}${top cpu 1}
${color 10470e}${top name 2}${top cpu 2}
${top name 3}${top cpu 3}
${top name 4}${top cpu 4}
${top name 5}${top cpu 5}
${hr 1}

#
# MEMORY
#
${color 10470e}${font Hack Nerd Font:size=16}${font}
RAM: $mem / $memmax
${membar 6}
Swap: $swap/$swapmax
${swapbar 6}
SSD: ${fs_free /} / ${fs_size /}
${fs_bar /}

# /home/: ${fs_free /home/} / ${fs_size /home/}
# ${fs_bar /home/}
# /tmp/: ${fs_free /tmp/} / ${fs_size /tmp/}
# ${fs_bar /tmp/}
# Root:    ${fs_free /} / ${fs_size /}
# ${fs_bar /}

${hr 1}
${color darkred}${top_mem name 1}${top_mem mem 1}
${color 051404}${top_mem name 2}${top_mem mem 2}
${top_mem name 3}${top_mem mem 3}
${top_mem name 4}${top_mem mem 4}
${top_mem name 5}${top_mem mem 5}
${hr 1}


#
# Battery
#
${color5}${font}Battery:${battery_percent}% ${battery_bar}

#
# System
#
${font Hack Nerd Font:size=16} ${font}Kernel: $kernel
${font Hack Nerd Font:size=16} ${font}Uptime: ${uptime_short}


#
# Datetime
#d8d8d8
${color bbbbba}${font Hack Nerd Font:size=14}${time %A %d, %Y}
     ${font Hack Nerd Font:size=30}${time %H:%M}
]]
