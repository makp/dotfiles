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
    "nvim/": None,
    "yazi/": None,
    "aichat-config.yaml": None,
    "condarc": None,
    "config.fish": None,
    "gitconfig": None,
    "gitignore": None,
    "latexmkrc": None,
    "tmux.conf": None,
    "zlogin": "~/.zlogin",
    "zshrc": "~/.zshrc",
    "zshenv": None,
    "lazygit.yml": "~/.config/lazygit/config.yml",
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
