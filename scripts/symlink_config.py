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


def create_symlinks(key):
    path = Path(CONFIG_MAP[key]).expanduser()

    if path.exists():
        print(f"Symlink already exists: {path}")
        input("Press Enter to remove it and create a new one...")
        os.remove(path)

    # Create parent directories if they don't exist
    path.parent.mkdir(parents=True, exist_ok=True)

    source = Path(key).resolve()

    os.symlink(source, path)
    print(f"Symlink created: {source} -> {path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create symlinks for config files.")
    parser.add_argument("config", help="Config file to symlink")

    args = parser.parse_args()

    create_symlinks(args.config)
