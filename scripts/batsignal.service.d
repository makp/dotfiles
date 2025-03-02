[Service]
# -p: Show message when battery begins charging/discharging
# -b : Enable battery notifications
# -w 20 : Warning notification at 20% battery
# -c 10 : Critical notification at 10% battery
# -d 5 : Depletion/shutdown warning at 5% battery
ExecStart=
ExecStart=/usr/bin/batsignal -p -w 20 -c 10 -d 5
