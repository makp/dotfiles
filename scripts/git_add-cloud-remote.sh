#!/bin/bash

# Default values
remote_name="b2"
remote_dir="git-annex-content"

# Check if first argument is provided (remote name)
if [ -n "$1" ]; then
  remote_name="$1"
fi

# Check if second argument is provided (remote_dir)
if [ -n "$2" ]; then
  remote_dir="$2"
fi

# Run the git annex command
git annex initremote "$remote_name" \
  type=rclone \
  rcloneremotename=b2 \
  rcloneprefix="$remote_dir" \
  rclonelayout=nodir

echo "Remote '$remote_name' initialized with remote_dir '$remote_dir'"
