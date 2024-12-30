import subprocess

import json
import os
from instructor import OpenAISchema
from pydantic import Field


class Function(OpenAISchema):
    """
    Executes a shell command and returns the output (result).
    """

    failed_commands_file = "failed_commands.json"
    failed_commands = []

    @classmethod
    def load_failed_commands(cls):
        if os.path.exists(cls.failed_commands_file):
            with open(cls.failed_commands_file, "r") as file:
                cls.failed_commands = json.load(file)

    @classmethod
    def save_failed_commands(cls):
        with open(cls.failed_commands_file, "w") as file:
            json.dump(cls.failed_commands, file)

    shell_command: str = Field(
        ...,
        example="ls -la",
        descriptions="Shell command to execute in a tmux environment. Known failing: "
        + ", ".join([f"{cmd} (Error: {err})" for cmd, err in failed_commands]),
    )

    class Config:
        title = "execute_shell_command"

    @classmethod
    def execute(cls, shell_command: str) -> str:
        cls.load_failed_commands()
        process = subprocess.Popen(
            shell_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
        )
        output, _ = process.communicate()
        exit_code = process.returncode
        if exit_code != 0:
            error_message = output.decode()
            cls.failed_commands.append((shell_command, error_message))
            cls.save_failed_commands()
        return f"Exit code: {exit_code}, Output:\n{output.decode()}"
