#!/usr/bin/env python3

import argparse
import os
from pathlib import Path

CONFIG_MAP = {
    "zlogin": "~/.zlogin",
    "lazygit.yml": "~/.config/lazygit/config.yml",
    "zshrc": "~/.zshrc",
    "teste.txt": "~/Downloads/teste",
}


def create_symlinks(config_file):
    source = Path(CONFIG_MAP[config_file]).expanduser()

    if source.exists():
        print(f"Symlink already exists: {source}")
        input("Press Enter to remove it and create a new one...")
        os.remove(source)

    # Create parent directories if they don't exist
    source.parent.mkdir(parents=True, exist_ok=True)

    destination = Path(config_file).resolve()

    os.symlink(destination, source)
    print(f"Symlink created: {source} -> {destination}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create symlinks for config files.")
    parser.add_argument("config", help="Config file to symlink")

    args = parser.parse_args()

    create_symlinks(args.config)
