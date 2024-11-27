#!/bin/bash

# Usage: clone-and-update-conda-env.sh source_env_name clone_env_name

SOURCE_ENV=$1
CLONE_ENV=$2

ENVFILE_PATH=/tmp/environment.yml

if [ -z "$SOURCE_ENV" ] || [ -z "$CLONE_ENV" ]; then
  echo "Usage: $0 source_env_name clone_env_name"
  exit 1
fi

# Export only the explicitly installed pkgs from the source env
conda env export --name "$SOURCE_ENV" --from-history >$ENVFILE_PATH

# Replace the source env name with the cloned env name
sed -i "s/name: .*/name: $CLONE_ENV/" $ENVFILE_PATH

# Remove the prefix line if it exists
sed -i '/^prefix:/d' $ENVFILE_PATH

# Make sure the env file is in good shape
$EDITOR $ENVFILE_PATH

# Create the new environment
conda env create --file $ENVFILE_PATH
