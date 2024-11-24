#!/usr/bin/env python

"""Assistant for reasoning tasks."""

import argparse
import os

from openai import OpenAI

CLIENT = OpenAI()
MODEL_ADVANCED = os.environ.get("OPENAI_REASON")
MODEL_BASIC = os.environ.get("OPENAI_REASON_MINI")

if not MODEL_ADVANCED or not MODEL_BASIC:
    raise ValueError("Please set the environment variables with GPT model names.")


def process_task(filepath, model):
    """Complete task described in the file at the given path."""
    with open(filepath, "r") as file:
        content = file.read()

    response = CLIENT.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": content},
        ],
    )
    return response.choices[0].message.content


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Assistant for reasoning tasks.")

    parser.add_argument(
        "filepath", type=str, help="Path to the file with the task description."
    )

    parser.add_argument(
        "-m", "--model", type=str, default=MODEL_ADVANCED, help="Model name to use."
    )

    args = parser.parse_args()

    print(process_task(args.filepath, args.model))
