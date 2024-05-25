#!/usr/bin/env python

"""Helper functions for proofreading emails and other text."""

import os
import sys

from openai import OpenAI

CLIENT = OpenAI()

MODEL = os.environ.get("OPENAI_ADVANCED")
if not MODEL:
    raise ValueError("Please set the OPENAI_ADVANCED environment variable.")


EMAIL_MAIN = """Compose a concise email using the provided content."""
EMAIL_SYLE = """Opt for shorter sentences when possible, eliminate repetition,
and use active verbs. Provide your answer in markdown format."""


ACADEMIC_MAIN = """Revise the given content to enhance its flow, grammar,
and clarity."""
ACADEMIC_STYLE = """
Further instructions:
- Start paragraphs with concise and impactful opening sentences.
- Use active verbs.
- Write in a concise, clear, and professional style.
- Avoid jargon and superfluous words.
- Improve sentence structure and links between sentences for better flow.
- Provide your answer in LaTeX format without preamble.
"""


def write_short_msg(content, temperature, model=MODEL, max_tokens=500):
    """Write a concise email with the provided content."""
    response = CLIENT.chat.completions.create(
        model=model,
        max_tokens=max_tokens,
        temperature=temperature,
        messages=[
            {"role": "system", "content": f"{EMAIL_MAIN}\n{EMAIL_SYLE}"},
            {"role": "user", "content": content},
        ],
    )
    return print(response.choices[0].message.content)


def refine_academic_prose(content, temperature, model=MODEL):
    """Revise academic prose."""
    response = CLIENT.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {"role": "system", "content": f"{ACADEMIC_MAIN}\n{ACADEMIC_STYLE}"},
            {"role": "user", "content": content},
        ],
    )
    return print(response.choices[0].message.content)


def process_prose(content, mode, temperature):
    """Process text."""
    if mode == "email":
        write_short_msg(content, temperature)
    elif mode == "academic":
        refine_academic_prose(content, temperature)
    else:
        raise ValueError("Invalid mode. Choose 'email' or 'academic'.")


if __name__ == "__main__":
    content = sys.argv[1]
    mode = sys.argv[2]
    temperature = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
    process_prose(content, mode, temperature)
