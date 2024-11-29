#!/usr/bin/env python

"""Assistant for reasoning tasks."""

import argparse
import os
import subprocess

from openai import OpenAI

CLIENT = OpenAI()

MODEL_ADVANCED = os.getenv("OPENAI_REASON")
MODEL_BASIC = os.getenv("OPENAI_REASON_MINI")

if not MODEL_ADVANCED or not MODEL_BASIC:
    raise ValueError("Please set the environment variables with GPT model names.")


def process_task(query, model):
    """Complete task described query."""
    try:
        response = CLIENT.chat.completions.create(
            model=model,
            messages=[
                {"role": "user", "content": query},
            ],
        )
        return response.choices[0].message.content
    except Exception as e:
        raise RuntimeError(f"OpenAI API request failed: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Assistant for reasoning tasks.")

    parser.add_argument(
        "-m",
        "--mini",
        action="store_true",  # Sets the value to True if the flag is present
        help="Use mini reasoning model",
    )

    parser.add_argument(
        "query",
        type=str,
        help="Query for the assistant.",
    )

    args = parser.parse_args()

    model_to_use = MODEL_BASIC if args.mini else MODEL_ADVANCED
    if not model_to_use:
        raise ValueError("Please set the environment variables with GPT model names.")

    question = args.query
    if os.path.isfile(args.query):
        print(f"Reading the query from the file '{args.query}'")
        try:
            with open(args.query, "r") as file:
                question = file.read()
        except IOError as e:
            raise IOError(f"Error reading the file '{args.query}': {e}")

    output = process_task(question, model_to_use)

    with open("/tmp/assistant-reasoning_output.md", "w") as file:
        file.write(str(output))

    subprocess.run(["xdg-open", "/tmp/assistant-reasoning_output.md"])
