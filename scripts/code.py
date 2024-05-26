#!/usr/bin/env python

"""Helper functions for dealing with code."""

import os
import sys

from openai import OpenAI

CLIENT = OpenAI()
MODEL_ADVANCED = os.environ.get("OPENAI_ADVANCED")
MODEL_BASIC = os.environ.get("OPENAI_BASIC")

if not MODEL_ADVANCED or not MODEL_BASIC:
    raise ValueError("Please set the environment variables with GPT model names.")

CODE_EXPLAIN = """Explain the provided code snippet."""
CODE_OPTIMIZE = """Optimize the provided code snippet."""


def explain_code(content, temperature, model, max_tokens=500):
    """Explain code."""
    response = CLIENT.chat.completions.create(
        model=model,
        max_tokens=max_tokens,
        temperature=temperature,
        messages=[
            {"role": "system", "content": f"{CODE_EXPLAIN}"},
            {"role": "user", "content": content},
        ],
    )
    return print(response.choices[0].message.content)


def optimize_code(content, temperature, model):
    """Optimize code."""
    response = CLIENT.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {"role": "system", "content": f"{CODE_OPTIMIZE}"},
            {"role": "user", "content": content},
        ],
    )
    return print(response.choices[0].message.content)


def process_code(content, mode, temperature):
    """Process code."""
    if mode == "explain":
        explain_code(content, temperature, model=MODEL_BASIC)
    elif mode == "optimize":
        optimize_code(content, temperature, model=MODEL_ADVANCED)
    else:
        raise ValueError("Invalid mode.")


if __name__ == "__main__":
    content = sys.argv[1]
    mode = sys.argv[2]
    temperature = float(sys.argv[3]) if len(sys.argv) > 3 else 0
    process_code(content, mode, temperature)
