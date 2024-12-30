import subprocess

from instructor import OpenAISchema
from pydantic import Field


class Function(OpenAISchema):
    """
    Executes a shell command and returns the output (result).
    """

    failed_commands = []

    shell_command: str = Field(
        ...,
        example="ls -la",
        descriptions="Shell command to execute in a tmux environment. Avoid using: " + ", ".join(
            [f"{cmd} (Error: {err})" for cmd, err in failed_commands]
        ),
    )

    class Config:
        title = "execute_shell_command"

    @classmethod
    def execute(cls, shell_command: str) -> str:
        process = subprocess.Popen(
            shell_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
        )
        output, _ = process.communicate()
        exit_code = process.returncode
        if exit_code != 0:
            error_message = output.decode()
            cls.failed_commands.append((shell_command, error_message))
        return f"Exit code: {exit_code}, Output:\n{output.decode()}"
