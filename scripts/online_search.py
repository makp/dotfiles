#!/usr/bin/env python

import os
import sys

import requests

API_KEY = os.getenv("PPLX_API_KEY")
MODEL = os.getenv("PPLX_MODEL")
URL = "https://api.perplexity.ai/chat/completions"


PROSE_STYLE = """
You are an artificial intelligence assistant and you need to engage in a helpful and detailed conversation with a user.
"""


def format_citations(citations):
    formatted_citations = ""
    for idx, citation in enumerate(citations):
        formatted_citations += f"{idx + 1}. {citation}\n"
    return formatted_citations


def answer_question(question):
    payload = {
        "model": MODEL,
        "messages": [
            {
                "role": "system",
                "content": PROSE_STYLE,
            },
            {
                "role": "user",
                "content": question,
            },
        ],
        "stream": False,
        "return_related_questions": False,
    }

    headers = {
        "Authorization": "Bearer " + str(API_KEY),
        "Content-Type": "application/json",
    }

    response = requests.request("POST", URL, json=payload, headers=headers)
    content = response.json()["choices"][0]["message"]["content"]
    citations = response.json()["citations"]
    print(content + "\nCitations:\n" + format_citations(citations))


if __name__ == "__main__":
    question = sys.argv[1]
    answer_question(question)
