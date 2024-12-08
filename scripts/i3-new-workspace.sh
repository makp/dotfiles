#!/bin/bash

WS_JSON=$(i3-msg -t get_workspaces)
for i in {1..10}; do
  if [[ $WS_JSON != *"\"num\":$i"* ]]; then
    i3-msg workspace number $i
    break
  fi
done

# i3-msg workspace $(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))

