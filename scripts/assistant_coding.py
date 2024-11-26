#!/usr/bin/env python

"""Helper functions for dealing with code."""

import os
import sys

from openai import OpenAI

CLIENT = OpenAI()
MODEL_ADVANCED = os.environ.get("OPENAI_REASON")
MODEL_BASIC = os.environ.get("OPENAI_REASON_MINI")

if not MODEL_ADVANCED or not MODEL_BASIC:
    raise ValueError("Please set the environment variables with GPT model names.")


CODE_EXPLAIN = """
*Task*: Provide an explanation of the provided code snippet for {programming_lang}.

*Requirements*:
- Describe the purpose of the code.
- Describe the functionality of each major section.
- Detail how the the components work together.
- If applicable, include an overview of any algorithm or data structures used.

*Output*: Use Markdown to format the output for better readability. The
explanation must be clear and concise.
"""

CODE_EXPLAIN_LIGHT = """
*Task*: Briefly explain the provided {programming_lang} code snippet.

*Output*: Use Markdown to format the output for better readability.
"""


CODE_OPTIMIZE = """
*Task*: Optimize the provided code snippet for performance in {programming_lang}.

*Requirements*:
- Boost efficiency by considering reductions in time complexity and memory usage.
- Incorporate best practices for clean and maintainable code.
- Use the most efficient algorithms and data structures where applicable.
- Keep code as simple as possible while maintaining readability.
- Annotate any significant changes made to the code with comments.

*Output*: Present the optimized code along with brief explanations of the
improvements using Markdown for improved readability.
"""


def create_completion(content, lang, temperature, model, msg_template):
    """Create a completion."""
    response = CLIENT.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {"role": "user", "content": msg_template.format(programming_lang=lang)},
            {"role": "user", "content": content},
        ],
    )
    return response.choices[0].message.content


def explain_code(content, lang, temperature, model=MODEL_BASIC):
    """Explain code."""
    msg_template = CODE_EXPLAIN
    explanation = create_completion(content, lang, temperature, model, msg_template)
    return print(explanation)


def explain_code_light(content, lang, temperature, model=MODEL_BASIC):
    """Explain code."""
    msg_template = CODE_EXPLAIN_LIGHT
    explanation = create_completion(content, lang, temperature, model, msg_template)
    return print(explanation)


def optimize_code(content, lang, temperature, model=MODEL_ADVANCED):
    """Optimize code."""
    msg_template = CODE_OPTIMIZE
    optimization = create_completion(content, lang, temperature, model, msg_template)
    return print(optimization)


def optimize_code_light(content, lang, temperature, model=MODEL_BASIC):
    """Optimize code."""
    msg_template = CODE_OPTIMIZE
    optimization = create_completion(content, lang, temperature, model, msg_template)
    return print(optimization)


def process_code(content, lang, mode, temperature):
    """Process code based on the specified mode."""
    mode_functions = {
        "explain": explain_code,
        "explain_light": explain_code_light,
        "optimize": optimize_code,
        "optimize_light": optimize_code_light,
    }
    try:
        mode_functions[mode](content, lang, temperature)
    except KeyError:
        raise ValueError("Invalid mode.")


if __name__ == "__main__":
    content = sys.argv[1]
    lang = sys.argv[2]
    mode = sys.argv[3]
    temperature = float(sys.argv[4]) if len(sys.argv) > 4 else 1
    process_code(content, lang, mode, temperature)
