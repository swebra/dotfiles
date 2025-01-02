import subprocess as sp
from pathlib import Path
from sys import argv, exit


def run_local_hook():
    hook_type = Path(argv[0]).name
    root = sp.check_output(["git", "rev-parse", "--show-toplevel"], text=True)
    local_hook = Path(root.strip(), ".git/hooks", hook_type)

    # print(f"Running hook {local_hook} with args {argv[1:]}!")

    if not local_hook.exists():
        return 0
    return sp.run([local_hook, *argv[1:]]).returncode


if __name__ == "__main__":
    exit(run_local_hook())
