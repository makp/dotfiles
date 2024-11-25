#!/bin/sh -e

i3lock -c 616160

# Turn the screen off after a delay
sleep 60; pgrep i3lock && xset dpms force off
# xset turns the display off, but the pgrep bit makes
# sure that i3lock is still running before turning the screen off --
# this way if you unlock the screen within the first minute, your
# screen doesn't blink off while you're trying to do something.