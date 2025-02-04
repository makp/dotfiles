#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <filename>"
	exit 1
fi

file="$1"

if [ -f "$file" ]; then
	if [[ $file == *.tex ]]; then
		echo "Converting $file to PDF..."
		pdflatex "$file"
	elif [[ $file == *.odt || $file == *.doc || $file == *.docx ]]; then
		echo "Converting $file to PDF..."
		libreoffice --headless --convert-to pdf "$file"
	else
		echo "Unsupported file format. Please provide an ODT, DOC, DOCX, or TEX file."
	fi
else
	echo "File not found."
fi
