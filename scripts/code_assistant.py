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

CODE_EXPLAIN = """
*Task*: Provide an explanation of the provided code snippet.

*Requirements*:
- Describe the purpose of the code.
- Describe the functionality of each major section.
- Detail how the the components work together.
- If applicable, include an overview of any algorithm or data structures used.

*Output*: Use Markdown to format the output for better readability. The
explanation must be clear and concise.
"""


CODE_OPTIMIZE = """
*Task*: Optimize the provided code snippet for performance.

*Requirements*:
- Boost efficiency by considering reductions in time complexity and memory usage.
- Incorporate best practices for clean and maintainable code.
- Use the most efficient algorithms and data structures where applicable.
- Keep code as simple as possible while maintaining readability.
- Annotate any significant changes made to the code with comments.

*Output*: Present the optimized code along with brief explanations of the
improvements using Markdown for improved readability.
"""


def explain_code(content, temperature, model=MODEL_BASIC, max_tokens=500):
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


def optimize_code(content, temperature, model=MODEL_ADVANCED):
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
        explain_code(content, temperature)
    elif mode == "optimize":
        optimize_code(content, temperature)
    else:
        raise ValueError("Invalid mode.")


if __name__ == "__main__":
    content = sys.argv[1]
    mode = sys.argv[2]
    temperature = float(sys.argv[3]) if len(sys.argv) > 3 else 1
    process_code(content, mode, temperature)
