# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 - 2023 Pionix GmbH and Contributors to EVerest
import json
from pathlib import Path
import argparse


class IncludePathRewriter:
    def __init__(self, working_dir: Path, keep_dir: Path, ignore_dirs: list[Path]):
        self._working_dir = working_dir
        self._keep_dir = keep_dir
        self._ignore_dirs = ignore_dirs

    def __call__(self, include: str) -> tuple[bool, str]:
        include_dir = Path(include)

        absolut_include_dir = (include_dir if include_dir.is_absolute() else self._working_dir / include_dir).resolve()

        patched_include = str(absolut_include_dir)

        for to_ignore in self._ignore_dirs:
            if absolut_include_dir.is_relative_to(to_ignore):
                return True, patched_include

        if absolut_include_dir.is_relative_to(self._keep_dir):
            return False, patched_include

        return True, patched_include


def patch_command(command: str, include_rewriter: IncludePathRewriter) -> str:
    patched_args: list[str] = []

    args = command.split()

    arg_pos = 0

    while arg_pos < len(args):
        arg = args[arg_pos]

        if arg == "-I":
            ignore, patched_include = include_rewriter(args[arg_pos+1])
            patched_args.append('-isystem' if ignore else '-I')
            patched_args.append(patched_include)
            arg_pos += 2
            continue
        elif arg.startswith("-I"):
            ignore, patched_include = include_rewriter(arg[2:])
            patched_args.append('-isystem' if ignore else '-I')
            patched_args.append(patched_include)
        else:
            patched_args.append(arg)

        arg_pos += 1

    return ' '.join(patched_args)


def main():
    parser = argparse.ArgumentParser(description='Test')
    parser.add_argument('-S', metavar='source', required=True, help='source directory')
    parser.add_argument('-B', metavar='build', required=True, help='build directory')

    args = parser.parse_args()

    source_dir = Path(args.S).resolve(strict=True)
    build_dir = Path(args.B).resolve(strict=True)

    ignore_dirs = [build_dir]

    commands_file = build_dir / 'compile_commands.json'

    commands_json = json.loads(commands_file.read_bytes())

    for command_context in commands_json:
        dir = Path(command_context['directory'])
        cmd = command_context['command']

        include_rewriter = IncludePathRewriter(dir, source_dir, ignore_dirs)
        patched_cmd = patch_command(cmd, include_rewriter)
        # write back
        command_context['command'] = patched_cmd

    print(json.dumps(commands_json, indent=2))
