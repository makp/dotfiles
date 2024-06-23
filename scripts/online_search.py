#!/usr/bin/env python

import os
import sys

from openai import OpenAI

API_KEY = os.getenv("PPLX_API_KEY")
MODEL = "llama-3-sonar-large-32k-online"


CLIENT = OpenAI(api_key=API_KEY, base_url="https://api.perplexity.ai")

PROSE_STYLE = """
You are an artificial intelligence assistant and you need to engage in a helpful and detailed conversation with a user.
"""


def answer_question(question):
    """Answer a user's question."""
    response_stream = CLIENT.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": PROSE_STYLE},
            {"role": "user", "content": question},
        ],
    )
    print(response_stream.choices[0].message.content)


if __name__ == "__main__":
    question = sys.argv[1]
    answer_question(question)
