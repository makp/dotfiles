#!/usr/bin/env python3

import subprocess
from pathlib import Path

import yaml


def update_pip_pkgs():
    conda_file = Path("conda_pkgs.yml")

    if not conda_file.exists():
        print("Error: conda_pkgs.yml file not found")
        return 1

    with open(conda_file, "r") as f:
        conda_pkgs = yaml.safe_load(f)

    # Get pip pkgs from the dependencies section
    dependencies = conda_pkgs.get("dependencies", [])
    pip_pkgs = next(
        (
            item["pip"]
            for item in dependencies
            if isinstance(item, dict) and "pip" in item
        ),
        None,
    )

    if not pip_pkgs:
        print("No pip packages found in conda_pkgs.yml")
        return 0

    # Install pip packages
    subprocess.run(["pip", "install"] + pip_pkgs)
    return 0


if __name__ == "__main__":
    update_pip_pkgs()
