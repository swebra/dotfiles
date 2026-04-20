import subprocess as sp
from pathlib import Path
from sys import argv, exit

from run_local_hook import run_local_hook


def remove_default_prompt(message):
    message_list = message.split("\n")
    prompt_index = next(
        (i for i, line in enumerate(message_list) if line.startswith("# Please enter")),
        None,
    )
    if not prompt_index:
        return message
    del message_list[prompt_index:prompt_index + 3]
    return "\n".join(message_list)


def append_git_log(message):
    try:
        log = sp.check_output(
            # https://git-scm.com/docs/pretty-formats
            ["git", "log", "--pretty=format:#   %<(60,trunc)%s | %an, %ah", "-10"],
            stderr=sp.STDOUT,
            text=True,
        )
    except sp.CalledProcessError as e:
        log = f"#   {e.output}"
    return message + "# Previous commits:\n" + log


exit_code = run_local_hook()
if exit_code != 0:
    print("Local prepare-commit-msg hook failed.")
    exit(exit_code)

# See https://git-scm.com/docs/githooks#_prepare_commit_msg

message_path = Path(argv[1])  # Path to commit message file
message_type = None if len(argv) <= 2 else argv[2]  # Commit message type
message = message_path.read_text()

# message_type can be None (commit), "message" (commit -m), "commit" (commit --amend),
# or "merge"/"squash". See link above for more info.
if not message_type or message_type == "commit":  # commit or commit --amend
    message = remove_default_prompt(message)
    message = append_git_log(message)

message_path.write_text(message)
