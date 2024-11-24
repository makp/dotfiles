#!/usr/bin/env python

import json
import os
import sys

import requests

API_KEY = os.getenv("PPLX_API_KEY")
MODEL = os.getenv("PPLX_MODEL")
URL = "https://api.perplexity.ai/chat/completions"


PROSE_STYLE = """
You are an artificial intelligence assistant and you need to engage in a helpful and detailed conversation with a user.
"""


def get_response(question):
    """Get response from perplexity API."""
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
        "stream": True,
    }

    headers = {
        "Authorization": "Bearer " + str(API_KEY),
        "Content-Type": "application/json",
    }

    response = requests.request("POST", URL, json=payload, headers=headers, stream=True)

    return response


"""
The response from the API is a `requests.models.Response` object. It contains the following attributes:
    ['__attrs__', '__bool__', '__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__enter__', '__eq__', '__exit__', '__format__', '__ge__', '__getattribute__', '__getstate__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__iter__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__nonzero__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setstate__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_content', '_content_consumed', '_next', 'apparent_encoding', 'close', 'connection', 'content', 'cookies', 'elapsed', 'encoding', 'headers', 'history', 'is_permanent_redirect', 'is_redirect', 'iter_content', 'iter_lines', 'json', 'links', 'next', 'ok', 'raise_for_status', 'raw', 'reason', 'request', 'status_code', 'text', 'url']
"""


def format_citations(citations):
    """Format citations."""
    formatted_citations = ""
    for idx, citation in enumerate(citations):
        formatted_citations += f"[{idx + 1}] {citation}\n"
    return formatted_citations


def process_response(response):
    """Process response from perplexity API."""
    citations = []

    try:
        response.raise_for_status()  # Check if request was successful

        for line in response.iter_lines():
            if line:
                line_content = line.decode("utf-8").strip()
                if line_content.startswith("data: "):
                    line_content = line_content[6:]
                try:
                    data = json.loads(line_content)
                    for choice in data.get("choices", []):
                        message_content = choice.get("delta", {}).get("content")
                        if message_content:
                            # Ensure the output is written to the terminal immediately without waiting for a newline character
                            # print(message_content, end="", flush=True)
                            sys.stdout.write(message_content)
                            sys.stdout.flush()

                    if not citations and "citations" in data:
                        citations = data.get("citations", [])

                except json.JSONDecodeError:
                    continue  # Ignore malformed JSON

        if citations:
            print("\n\nCitations:\n" + format_citations(citations))

    except requests.exceptions.RequestException as e:
        print(f"Deu bode: {e}")


if __name__ == "__main__":
    question = sys.argv[1]
    process_response(get_response(question))
