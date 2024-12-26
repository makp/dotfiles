#!/bin/bash

USED_WS=$(swaymsg -t get_workspaces | jq '.[].num')

for i in {1..10}; do
  if ! grep -q "$i$" <<<"$USED_WS"; then
    swaymsg workspace number $i
    break
  fi
done
