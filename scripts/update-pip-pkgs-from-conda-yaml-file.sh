#!/bin/bash

# Check if the input file exists
if [ ! -f "conda_pkgs.yml" ]; then
  echo "Error: conda_pkgs.yml file not found"
  exit 1
fi

# Extract pip packages from conda environment file
pip_packages=$(awk '/^  - pip:/{f=1;next} f{if(/^[a-zA-Z]/ || /^$/) exit; print}' conda_pkgs.yml |
  sed -e 's/^      - //' |
  grep -v '^[[:space:]]*$')

if [ -z "$pip_packages" ]; then
  echo "No pip packages found in conda_pkgs.yml"
  exit 0
fi

# Create a temporary requirements file
temp_req=$(mktemp)
echo "$pip_packages" >"$temp_req"

# Install packages
pip install -r "$temp_req"

# Clean up
rm "$temp_req"
