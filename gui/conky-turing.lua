-- Conky configuration file for the turing machine
-- !ln -s %:p ~/.conkyrc

conky.config = {
	alignment = "top_left",
	xinerama_head = 1, -- screen number
	gap_x = 30, -- add padding to the left
	gap_y = 30,
	xftalpha = 0.8,

	-- options for preventing flickering
	double_buffer = true, -- double-buffer extension (DBE) support -- update window fast enough
	own_window = true,

	-- font
	use_xft = true,
	font = "Hack Nerd Font:size=8.5",

	-- windows settings
	own_window_type = "override",
	-- another possible value is "desktop"
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
	maximum_width = 300, -- pixels

	-- colors
	color1 = "gray23",
	color5 = "9F9F1A",
}

conky.text = [[
#
# Internet
#
${color1}${font Hack Nerd Font:size=16}${font}   ${upspeed wlp8s0}${color1}
${upspeedgraph wlp8s0 20 darkred white}
${font Hack Nerd Font:size=16}${font}   ${downspeed wlp8s0}
${downspeedgraph wlp8s0 20 darkred white}
${font Hack Nerd Font:size=14}${font}   ${wireless_link_qual_perc wlp8s0} %
${wireless_link_bar wlp8s0}


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
Core 4: ${cpubar cpu4 7,145}  ${freq 5}MHz ${cpu cpu4}%
Core 5: ${cpubar cpu5 7,145}  ${freq 6}MHz ${cpu cpu5}%
Core 6: ${cpubar cpu6 7,145}  ${freq 7}MHz ${cpu cpu6}%

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

${hr 1}
${color darkred}${top_mem name 1}${top_mem mem 1}
${color 051404}${top_mem name 2}${top_mem mem 2}
${top_mem name 3}${top_mem mem 3}
${top_mem name 4}${top_mem mem 4}
${top_mem name 5}${top_mem mem 5}
${hr 1}


#
# GPU
#
${color5}${font}GPU: ${nvidia modelname} | Temp: ${nvidia gputemp}/${nvidia gputempthreshold} C
${nvidiabar 7,245 gpuutil}  ${nvidia gpuutil}%

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
