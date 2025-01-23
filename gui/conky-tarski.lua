conky.config = {
   -- The script in myscripts is pointing to this file. No need to symlink.
   alignment = 'top_left',
   xftalpha = 0.8,

   -- options for preventing flickering
   double_buffer = true,-- double-buffer extension (DBE) support -- update window fast enough
   own_window = true,

   -- font
   use_xft = true,
   font = 'DejaVu Sans Book:size=8',

   -- windows settings
   own_window_type = 'override',
   -- another possible value is "desktop"
   own_window_transparent = true,
   own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

   draw_shades = false,
   draw_outline = false,
   draw_borders = false,
   stippled_borders = 1,
   --border_margin 1
   border_width = 1,
   default_shade_color = 'black',
   default_outline_color = 'black',

   use_spacer = 'none',
   no_buffers = true,
   uppercase = false,
   update_interval = 3,-- seconds

   maximum_width = 250,-- pixels

   -- colors
   default_color = '#BADCDD',
   color1 = 'gray23',-- #   # net
   color3 = '#698b22',-- ram
   color2 = 'darkgreen',-- cpu
   color4 = 'darkorange4',
   color5 = '#F8DF58',-- e-mail
   color6 = 'dodgerblue4',-- weather 
   color7 = 'yellow',-- system management


   --lua_load /home/makmiller/.conkyrcs/cpufreq.lua # function for printing the governor


};

conky.text = [[
${color gray7}${font OpenLogos:size=32}  t B U z 
 ${color1}${font PizzaDude Bullets:size=16}M${font} Up: ${upspeed eth0}${color1} Kb/s 
   ${downspeedgraph wlp2s0 20 darkred white}
   ${font PizzaDude Bullets:size=16}S${font} Down: ${downspeed wlp2s0} Kb/s 
   ${upspeedgraph wlp2s0 20 000000 ffffff}
   wi-fi signal: ${wireless_link_qual_perc wlp2s0} % ${wireless_link_bar wlp2s0} 	
  
  ${color3}${font PizzaDude Bullets:size=16}J${font}  Processes: $running_processes / $processes
     ${hr 2}
     HIGHEST MEM:
     ${color darkred}${top_mem name 1}${top_mem mem 1}
     ${color3}${top_mem name 2}${top_mem mem 2}
     ${top_mem name 3}${top_mem mem 3}
     ${hr 2}
          
     ${hr 2}
     HIGHEST CPU:
     ${color darkred}${top name 1}${top cpu 1}
     ${color3}${top name 2}${top cpu 2}
     ${top name 3}${top cpu 3}
     ${hr 2}	    

   /home/:   ${fs_free /home/} / ${fs_size /home/}
   ${fs_bar /home/}
   /usr/:    ${fs_free /usr/} / ${fs_size /usr/} 
   ${fs_bar /usr/}
   /var/:    ${fs_free /var/} / ${fs_size /var/} 
   ${fs_bar /var/}
   /tmp/:    ${fs_free /tmp/} / ${fs_size /tmp/} 
   ${fs_bar /tmp/}

   ${color2}${font StyleBats:size=16}A${font} Load: ${loadavg}   (${hwmon 0 temp 1} C) 
   ${cpugraph 20 000000 ffffff}
   Core 0: ${cpu cpu0}% ${cpubar cpu0 8,115} ${freq 1}MHz
   Core 1: ${cpu cpu1}% ${cpubar cpu1 8,115} ${freq 2}MHz
   Core 2: ${cpu cpu2}% ${cpubar cpu2 8,115} ${freq 3}MHz
   Core 3: ${cpu cpu3}% ${cpubar cpu3 8,115} ${freq 4}MHz
   # freq (MHz): ${freq 1} (core 0)  ${freq 2} (core 1) ${freq 3} (core 2) ${freq 4} (core 3)
   Governor: ${execi 300 head /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor}  
  
   RAM: $mem / $memmax     
   ${membar 6}
   Swap: $swap/$swapmax 
   ${swapbar 6}      

   ${color7}${font StyleBats:size=18}P${font}  Work:  ${uptime_short} (Linux $kernel)

   # sincro out: ${font DejaVu Sans Book:size=8:bold}${execi 500 sed -n 1p /home/makmiller/myscripts/log-files/sincro-out.log}${font}
   # sincro in : ${font DejaVu Sans Book:size=8:bold}${execi 500 sed -n 1p /home/makmiller/myscripts/log-files/sincro-in.log}${font}${color white}


 ${color white}${font Radio Space:size=16}${time %A %d %Y}
   ${font Radio Space:size=55}${time %H:%M} 


  

]];
