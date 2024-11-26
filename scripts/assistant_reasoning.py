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
    try:
        with open(filepath, "r") as file:
            content = file.read()
    except IOError as e:
        raise IOError(f"Error reading the file '{filepath}': {e}")

    try:
        response = CLIENT.chat.completions.create(
            model=model,
            messages=[
                {"role": "user", "content": content},
            ],
        )
        return response.choices[0].message.content
    except Exception as e:
        raise RuntimeError(f"OpenAI API request failed: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Assistant for reasoning tasks.")

    parser.add_argument(
        "filepath", type=str, help="Path to the file with the task description."
    )

    parser.add_argument(
        "-m",
        "--mini",
        action="store_true",  # Sets the value to True if the flag is present
        help="Use mini model",
    )

    parser.add_argument(
        "-o",
        "--output",
        action="store_true",
        help="Output the result to a file named 'output.md'",
    )

    args = parser.parse_args()

    model_to_use = MODEL_BASIC if args.mini else MODEL_ADVANCED
    if not model_to_use:
        raise ValueError("Please set the environment variables with GPT model names.")

    if args.output:
        output = process_task(args.filepath, model_to_use)
        with open("output.md", "w") as file:
            file.write(str(output))
    else:
        print(process_task(args.filepath, model_to_use))
