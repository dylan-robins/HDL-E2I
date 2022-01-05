#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf-8
# *****************************************************************************#
from __future__ import annotations

import argparse
import re
import shlex
import subprocess
from dataclasses import dataclass, field
from itertools import chain
from pathlib import Path
from shutil import rmtree
from subprocess import Popen, run
from typing import Iterable, Union


@dataclass
class Target:
    """Representation of a VHDL file that can be compiled"""

    name: str
    path: Path
    dependencies: list[str] = field(default_factory=list)
    built: bool = False


@dataclass
class TargetDB:
    """Database listing all the VHDL targets to build"""

    hdl_compiler: str
    hdl_elaborator: str
    hdl_sim: str
    sim_opts: str
    lib_name: str

    targets: list[Target] = field(default_factory=list)

    def parse_targets(self, rtl_dirs: Iterable[Path], testbench_dirs: Iterable[Path]):
        """Populates the target list from a list of directories containing vhdl files"""

        for f in chain(*[dir.glob("*.vhd") for dir in chain(rtl_dirs, testbench_dirs)]):
            lines = f.read_text()
            matches = re.findall(r"^use TP_LIB.(\w+);$", lines, re.M)

            self.targets.append(
                Target(
                    name=f.stem,
                    path=f,
                    dependencies=matches,
                )
            )

    def get_target_by_name(self, name: str) -> Union[Target, None]:
        """Returns the target instance with the corresponding name if present in the list"""

        for target in self.targets:
            if target.name.lower() == name.lower():
                return target

        return None

    def compile_target(self, target: Target) -> bool:
        """Compiles the provided target and all it's dependencies"""

        ok: bool = True

        # build dependencies
        for dep_name in target.dependencies:
            dep = self.get_target_by_name(dep_name)
            if dep and not dep.built:
                ok &= self.compile_target(dep)
                if not ok:
                    print(
                        f"### Error: couldn't build dependencies for {dep.name}, skipping..."
                    )

            elif not dep:
                print(f"### Error: source not found for entity {dep_name}")
                ok = False

        if not ok:
            print(
                f"### Error: couldn't build dependencies for {target.name}, skipping..."
            )
            ok = False

        else:
            # finally, build target
            print(f"### Compiling {target.name} ({target.path})")

            cmd = f"{self.hdl_compiler} {target.path}"
            print(f" -> {cmd}")
            process = run(
                shlex.split(cmd),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            ok &= process.returncode == 0
            if not ok:
                print(process.stdout)
                print(process.stderr)

        if ok:
            target.built = True

        return ok

    def elaborate_target(self, target: Target) -> bool:
        """Elaborates the provided target"""

        if not target.built:
            print(f"Error: Can't elaborate a target that hasn't been built!")

        print(f"### Elaborating {target.name} ({target.path})")
        cmd = f"{self.hdl_elaborator} {target.name}"
        print(f" -> {cmd}")
        process = run(
            shlex.split(cmd),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        ok = process.returncode == 0
        if not ok:
            print(process.stdout)
            print(process.stderr)
        return ok

    def simulate_target(self, target: Target) -> bool:
        """Simulates the provided target"""

        if not target.built:
            print(f"Error: Can't simulate a target that hasn't been built!")

        print(f"### Simulating {target.name} ({target.path})")
        cmd = f"{self.hdl_sim} {target.name} {self.sim_opts}"
        print(f" -> {cmd}")
        process = run(
            shlex.split(cmd),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        ok = process.returncode == 0
        if not ok:
            print(process.stdout)
            print(process.stderr)
        return ok


def open_gui(hdl_viewer: str, sim_file: Path) -> bool:
    """Simulates the provided target"""

    print(f"### Opening gui")
    cmd = f"{hdl_viewer} {sim_file}"
    print(f" -> {cmd}")
    process = Popen(
        shlex.split(cmd),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return process.wait() == 0


def main(args: argparse.Namespace):
    print(f"### Cleaning working directory {args.work_dir}")
    rmtree(args.work_dir, ignore_errors=True)
    args.work_dir.mkdir(exist_ok=True)

    target_db = TargetDB(
        hdl_compiler=args.hdl_compiler,
        hdl_elaborator=args.hdl_elaborator,
        hdl_sim=args.hdl_sim,
        sim_opts=args.hdl_sim_opts,
        lib_name=args.lib_name,
    )

    target_db.parse_targets(args.rtl_dir, args.testbench_dir)

    for target_name in args.target:

        if target_name.endswith("_tb"):
            target = target_db.get_target_by_name(target_name[:-3])
            target_tb = target_db.get_target_by_name(target_name)
        else:
            target = target_db.get_target_by_name(target_name)
            target_tb = target_db.get_target_by_name(target_name + "_tb")

        if not target:
            print(f"Error: target not found '{target_name}'")
            exit(1)

        if not target_tb:
            print(f"Error: testbench not found for target '{target_name}'")
            exit(1)

        if not target_db.compile_target(target_tb):
            exit(1)

        if not target_db.elaborate_target(target_tb):
            exit(1)

        if not target_db.simulate_target(target_tb):
            exit(1)

        if args.gui and not open_gui(args.hdl_viewer, args.sim_file):
            exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("target", type=str, nargs="+", help="Target to build")

    parser.add_argument(
        "--rtl_dir",
        type=Path,
        nargs="+",
        help="Directories containing rtl sources",
        default=[Path("rtl")],
    )
    parser.add_argument(
        "--testbench_dir",
        type=Path,
        nargs="+",
        help="Directories containing testbench sources",
        default=[Path("test")],
    )
    parser.add_argument(
        "--work_dir",
        type=Path,
        help="Directory in which to place intermediate files",
        default=Path("work"),
    )
    parser.add_argument(
        "--lib_name",
        type=str,
        help="Name of the library",
        default="TP_LIB",
    )
    parser.add_argument(
        "--stop_time",
        type=str,
        help="Time at which to halt the simulation",
        default="100ns",
    )
    parser.add_argument(
        "--gui",
        action="store_true",
        help="If present, will open the generated wave traces in the provided gui application",
    )

    args = parser.parse_args()

    args.sim_file = args.work_dir / f"{args.lib_name}.ghw"
    hdl_opts = " ".join(
        [
            f"--workdir={args.work_dir}",
            f"--work={args.lib_name}",
            f"--ieee=synopsys",
            f"-fexplicit",
            f"--std=08",
        ]
    )
    args.hdl_sim_opts = " ".join(
        [
            f"--wave={args.sim_file}",
            f"--stop-time={args.stop_time}",
        ]
    )

    args.hdl_compiler = f"ghdl -a {hdl_opts}"
    args.hdl_elaborator = f"ghdl -e {hdl_opts}"
    args.hdl_sim = f"ghdl -r {hdl_opts}"
    args.hdl_viewer = f"gtkwave"

    main(args)
