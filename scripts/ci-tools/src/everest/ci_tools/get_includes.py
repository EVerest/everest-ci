# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 - 2023 Pionix GmbH and Contributors to EVerest
import json
from pathlib import Path
import argparse
import logging


def get_includes_from_command(command: str) -> list[Path]:
    retval: list[Path] = list()

    args = command.split()
    arg_pos = 1  # we don't care about the command itself

    while arg_pos < len(args):
        arg = args[arg_pos]

        if arg == "-I" or arg == "-isystem":
            retval.append(Path(args[arg_pos+1]))
            arg_pos += 2
            continue
        elif arg.startswith("-I"):
            retval.append(Path(arg[2:]))

        arg_pos += 1

    return retval


def get_include_paths(commands: any) -> set[Path]:
    include_paths: set[Path] = set()
    for ctx in commands:
        dir = Path(ctx['directory'])
        cmd = ctx['command']
        # file = ctx['file']

        paths = get_includes_from_command(cmd)
        resolved_paths = {path.resolve() if path.is_absolute() else (dir / path).resolve() for path in paths}
        include_paths.update(resolved_paths)

    return include_paths


def keep_include_path(include_path: Path, keep_paths: list[Path]) -> bool:
    for keep_path in keep_paths:
        if include_path.is_relative_to(keep_path):
            return True

    return False


def validate_include_paths(include_paths: list[Path]):
    for path in include_paths:
        if not path.exists():
            logging.warning(f'Include path {path} does not exist')


def main():
    parser = argparse.ArgumentParser(description='Test')
    parser.add_argument('--cpm-cache', default=None, help='CPM cache directory')
    parser.add_argument('-B', metavar='build', required=True, help='build directory')

    args = parser.parse_args()

    cpm_cache_dir = Path(args.cpm_cache).resolve(strict=True) if args.cpm_cache else None
    build_path = Path(args.B).resolve(strict=True)

    commands_file = build_path / 'compile_commands.json'

    commands_json = json.loads(commands_file.read_bytes())

    include_paths = [path for path in get_include_paths(
        commands_json) if keep_include_path(path, [build_path, cpm_cache_dir])]

    validate_include_paths(include_paths)

    for inc in sorted(include_paths):
        print(inc)
