#!/usr/bin/env python

"""Helper functions for proofreading emails and other types of text."""

import os
import sys

import anthropic
from openai import OpenAI

CLIENT_OPENAI = OpenAI()
CLIENT_ANTHROPIC = anthropic.Anthropic()

MODEL_ADVANCED = os.getenv("OPENAI_ADVANCED")
MODEL_BASIC = os.getenv("OPENAI_BASIC")
MODEL_ANTHROPIC = os.getenv("ANTHROPIC_MODEL")

if not MODEL_ADVANCED or not MODEL_BASIC or not MODEL_ANTHROPIC:
    raise ValueError("Please set the environment variables with assistant model names.")


EMAIL_MAIN = """
Compose a concise email using the provided content.
"""
PROSE_MAIN = """
Revise the given content to enhance its flow, grammar,
and clarity.
"""

PROSE_STYLE = """
Opt for shorter sentences when possible, eliminate repetition,
and use active verbs. Provide your answer in markdown format.
"""
ACADEMIC_STYLE = """
Further instructions:
- Start paragraphs with concise and impactful opening sentences.
- Use active verbs.
- Write in a concise, clear, and professional style.
- Avoid jargon and superfluous words.
- Improve sentence structure and links between sentences for better flow.
- Provide your answer in LaTeX format without preamble.
"""


def proofread_openai(content, temperature, model, msg_template):
    """Proofread content."""
    response = CLIENT_OPENAI.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {"role": "system", "content": msg_template},
            {"role": "user", "content": content},
        ],
    )
    return response.choices[0].message.content


def proofread_anthropic(content, temperature, model, msg_template):
    """Proofread content using one of the Anthropic models."""
    response = CLIENT_ANTHROPIC.messages.create(
        max_tokens=1024,  # mandatory par
        model=model,
        temperature=temperature,
        system=msg_template,
        messages=[
            {"role": "user", "content": [{"type": "text", "text": content}]},
        ],
    )
    return response.content[0].text  # type: ignore


def write_short_msg(content, temperature, model=MODEL_BASIC):
    """Write a concise email with the provided content."""
    msg_template = f"{EMAIL_MAIN}\n{PROSE_STYLE}"
    email = proofread_openai(content, temperature, model, msg_template)
    print(email)


def refine_prose(content, temperature, model=MODEL_BASIC):
    """Revise prose."""
    msg_template = f"{PROSE_MAIN}\n{PROSE_STYLE}"
    response = proofread_openai(content, temperature, model, msg_template)
    print(response)


def refine_academic_prose(content, temperature, model=MODEL_ADVANCED):
    """Revise academic prose."""
    msg_template = f"{PROSE_MAIN}\n{ACADEMIC_STYLE}"
    response = proofread_openai(content, temperature, model, msg_template)
    print(response)


def refine_academic_prose_anthropic(content, temperature, model=MODEL_ANTHROPIC):
    """Revise academic prose."""
    msg_template = f"{PROSE_MAIN}\n{ACADEMIC_STYLE}"
    response = proofread_anthropic(content, temperature, model, msg_template)
    print(response)


def process_prose(content, mode, temperature):
    """Process text."""
    mode_functions = {
        "email": write_short_msg,
        "academic": refine_academic_prose,
        "academic_anthropic": refine_academic_prose_anthropic,
        "prose": refine_prose,
    }
    try:
        mode_functions[mode](content, temperature)
    except KeyError:
        raise ValueError("Invalid mode.")


if __name__ == "__main__":
    content = sys.argv[1]
    mode = sys.argv[2]
    temperature = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
    process_prose(content, mode, temperature)
