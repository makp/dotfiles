#!/usr/bin/env python3

import argparse
import os
from pathlib import Path

CONFIG_MAP = {
    "gui/kitty": "~/.config/kitty",
    "gui/Xmodmap": "~/.Xmodmap",
    "gui/alacritty.toml": "~/.config/alacritty/alacritty.toml",
    "gui/conky-leibniz.lua": "~/.conkyrc",
    "gui/conky-tarski.lua": "~/.conkyrc",
    "gui/conky-turing.lua": "~/.conkyrc",
    "gui/ghostty-config": "~/.config/ghostty/config",
    "gui/i3-config": "~/.config/i3/config",
    "gui/mathematica-keyevents.tr": None,
    "gui/mathematica-menu.tr": None,
    "gui/mimeapps.list": "~/.config/mimeapps.list",
    "gui/sway-config": "~/.config/sway/config",
    "gui/xinitrc": "~/.xinitrc",
    "gui/zathurarc": "~/.config/zathura/zathurarc",
    "nvim/": "~/.config/nvim",
    "yazi/": None,
    "aichat-config.yaml": "~/.config/aichat/config.yaml",
    "config.fish": None,
    "gitconfig": "~/.gitconfig",
    "gitignore": "~/.gitignore_global",
    "latexmkrc": "~/.latexmkrc",
    "tmux.conf": "~/.config/tmux/tmux.conf",
    "zlogin": "~/.zlogin",
    "zshrc": "~/.zshrc",
    "zshenv": "~/.zshenv",
    "lazygit.yml": "~/.config/lazygit/config.yml",
}


def create_symlinks(config_file):
    value = CONFIG_MAP.get(config_file)

    if value is None:
        print(f"Config file not mapped: {config_file}")
        return

    source = Path(value).expanduser()

    if source.is_symlink():
        print(f"Symlink already exists: {source}")
        input("Press Enter to remove it and create a new one...")
        source.unlink()
    elif source.exists():
        print(f"File/directory already exists: {source}")
        input("Press Enter to remove it and create a new one...")
        source.unlink()

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
