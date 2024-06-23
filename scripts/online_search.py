#!/usr/bin/env python

import os
import sys

from openai import OpenAI

API_KEY = os.getenv("PPLX_API_KEY")
MODEL = "llama-3-sonar-large-32k-online"
BASE_URL = "https://api.perplexity.ai"

CLIENT = OpenAI(api_key=API_KEY, base_url=BASE_URL)

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
        stream=True,
    )
    for chunk in response_stream:
        print(chunk.choices[0].delta.content or "", end="")


if __name__ == "__main__":
    question = sys.argv[1]
    answer_question(question)
