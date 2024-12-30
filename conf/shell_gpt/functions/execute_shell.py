import subprocess

import json
import os
from instructor import OpenAISchema
from pydantic import Field

failed_commands_file = os.path.join(
        os.path.expanduser("~"), ".config", "shell_gpt", "failed_commands.json"
        )

def load_failed_commands():
    failed_commands = []
    if os.path.exists(failed_commands_file):
        with open(failed_commands_file, "r") as file:
            failed_commands = json.load(file)
    return failed_commands

def save_failed_commands(failed_commands):
    with open(failed_commands_file, "w") as file:
        json.dump(failed_commands, file)

class Function(OpenAISchema):
    """
    Executes a shell command and returns its output along with the exit code.
    If the command fails, it logs the command and error message for future reference.
    """
    shell_command: str = Field(
        ...,
        example="ls -la",
        description="Shell command to execute in a tmux environment. Analyze the following commands that have previously failed in this environment to avoid reproducing the issue: "
        + ", ".join([f"{cmd} (Error: {err})" for cmd, err in load_failed_commands()]),
    )

    class Config:
        title = "execute_shell_command"

    @classmethod
    def execute(cls, shell_command: str) -> str:
        failed_commands = load_failed_commands()
        process = subprocess.Popen(
            shell_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
        )
        output, _ = process.communicate()
        exit_code = process.returncode
        if exit_code != 0:
            error_message = output.decode()
            failed_commands.append((shell_command, error_message))
            save_failed_commands(failed_commands)
        return f"Exit code: {exit_code}, Output:\n{output.decode()}"
