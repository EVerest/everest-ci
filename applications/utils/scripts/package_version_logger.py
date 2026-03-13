##!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# SPDX-License-Identifier: Apache-2.0
# Copyright Pionix GmbH and Contributors to EVerest
#
"""
author: andreas.heinrich@pionix.de
Logs the versions of debian and python packages in a environment to a file
"""

import argparse
from pathlib import Path
import subprocess
import json
import platform


def get_debian_packages() -> list[dict[str, str, str]]:
    """
    Gets the list of installed debian packages using dpkg-query. Returns a 
    list of dictionaries with keys 'manager', 'name' and 'version'.
    """
    try:
        result = subprocess.run(
            [
                'dpkg-query',
                '-W',
                '-f', '${Package} ${Version}\n'
            ],
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True,
            check=True
        )
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f'Failed to get installed debian packages: {e.stderr}') from e

    if result.returncode != 0:
        raise RuntimeError(f'Failed to get installed debian packages: {result.stderr}')
    debian_packages = []

    for line in result.stdout.splitlines():
        line = line.strip()
        if not line:
            print('Warning: Skipping empty line')
            continue
        parts = line.split()
        if len(parts) < 2:
            print(f'Warning: Skipping malformed line: {line}')
            continue

        debian_packages.append(
            {
                'manager': 'dpkg',
                'name': parts[0],
                'version': parts[1]
            }
        )
    return debian_packages


def get_python_packages() -> list[dict[str, str, str]]:
    """
    Gets the list of installed python packages using pip. Returns a list of
    dictionaries with keys 'manager', 'name' and 'version'.
    """
    try:
        result = subprocess.run(
            [
                'pip',
                'list',
                '--format', 'json'
            ],
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True,
            check=True
        )
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f'Failed to get installed python packages: {e.stderr}') from e
    if result.returncode != 0:
        raise RuntimeError(f'Failed to get installed python packages: {result.stderr}')
    python_packages = []
    raw_packages = json.loads(result.stdout)
    for package in raw_packages:
        python_packages.append(
            {
                'manager': 'pip',
                'name': package['name'],
                'version': package['version']
            }
        )
    return python_packages


def get_npm_packages() -> list[dict[str, str, str]]:
    """
    Gets the list of globally installed npm packages using npm list -g. Returns a
    list of dictionaries with keys 'manager', 'name' and 'version'.
    """
    try:
        result = subprocess.run(
            ['npm', 'list', '-g', '--depth=0', '--json'],
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True,
            check=True
        )
    except FileNotFoundError:
        print('npm is not installed, skipping npm package logging')
        return []
    except subprocess.CalledProcessError as e:
        print(f'Warning: Failed to get installed npm packages: {e.stderr}, trying to parse stdout if available')
        if not e.stdout:
            raise RuntimeError(f'Failed to get installed npm packages: {e.stderr}') from e
        result = e

    try:
        raw_data = json.loads(result.stdout)
        dependencies = raw_data.get('dependencies', {})
        npm_packages = []
        for name, info in dependencies.items():
            npm_packages.append({
                'manager': 'npm',
                'name': name,
                'version': info.get('version', 'unknown')
            })
        return npm_packages
    except json.JSONDecodeError:
        raise RuntimeError(f'Failed to parse npm list output as JSON: {result.stdout}')


def get_cargo_packages() -> list[dict[str, str, str]]:
    """
    Gets the list of installed cargo packages using cargo install --list. Returns a
    list of dictionaries with keys 'manager', 'name' and 'version'.
    """
    try:
        result = subprocess.run(
            ['cargo', 'install', '--list'],
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True,
            check=True
        )
    except FileNotFoundError:
        print('cargo is not installed, skipping cargo package logging')
        return []
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f'Failed to get installed cargo packages: {e.stderr}') from e

    cargo_packages = []
    for line in result.stdout.splitlines():
        # Cargo Format: "package-name v1.2.3:"
        if line.endswith(':'):
            parts = line.replace(':', '').split(' v')
            if len(parts) == 2:
                cargo_packages.append({
                    'manager': 'cargo',
                    'name': parts[0].strip(),
                    'version': parts[1].strip()
                })
    return cargo_packages


def get_manual_binaries() -> list[dict[str, str, str]]:
    """
    Gets the list of manually installed binaries in /usr/local/bin. Returns a
    list of dictionaries with keys 'manager', 'name' and 'version'.
    """
    local_binaries = []
    if Path('/usr/local/bin').exists():
        local_binaries = Path('/usr/local/bin').glob('*')
    manual_binaries = []
    for binary in local_binaries:
        if not binary.is_file() or not binary.stat().st_mode & 0o111:
            continue

        manual_binaries.append({
            'manager': 'manual_binary',
            'name': binary.name,
            'version': 'unknown'
        })
    return manual_binaries


def get_os_pretty() -> str:
    """
    Gets the pretty name of the operating system from /etc/os-release. Returns a string.
    """
    if Path('/etc/os-release').exists():
        with open('/etc/os-release') as f:
            for line in f:
                if line.startswith('PRETTY_NAME='):
                    return line.split('=', 1)[1].strip().strip('"')
    return 'unknown'


def get_architecture() -> str:
    """
    Gets the architecture of the system using platform.machine(). Returns a string.
    """
    return platform.machine() or 'unknown'


def get_inventory() -> dict[dict[str, str], list[dict[str, str, str]]]:
    """
    Gets the inventory of installed packages and system metadata. Returns a dictionary
    with keys 'image_metadata' and 'installed_packages'.
    """
    installed_packages = []
    installed_packages.extend(get_debian_packages())
    installed_packages.extend(get_python_packages())
    installed_packages.extend(get_npm_packages())
    installed_packages.extend(get_cargo_packages())
    installed_packages.extend(get_manual_binaries())
    inventory = {
        'image_metadata': {
            'os_pretty': get_os_pretty(),
            'architecture': get_architecture()
        },
        'installed_packages': installed_packages
    }
    return inventory


def main():
    parser = argparse.ArgumentParser(
        description='logs the versions of debian and python packages in a environment to a file')

    parser.add_argument('--output-file', type=str, help='Output file to log the package versions', required=True)

    args = parser.parse_args()

    output_file = Path(args.output_file).expanduser().resolve()
    if output_file.exists():
        print(f'Output file {output_file} already exists, will be overwritten')
    output_file.parent.mkdir(parents=True, exist_ok=True)

    inventory = get_inventory()
    with open(output_file, 'w') as f:
        json.dump(inventory, f, indent=4)
    print(f'Package inventory logged to {output_file}')

    exit(0)


if __name__ == '__main__':
    main()
