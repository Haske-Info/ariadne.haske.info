#!/bin/bash
set -e
cd "$(dirname "$0")/.."

if [ -n "$CI" ]; then
    PYTHON=python3
else
    PYTHON=~/.venv/ahaske-resume/bin/python3
fi

echo "Building book..."
mdbook build

echo "Printing to PDF..."
$PYTHON - <<'PYEOF'
from playwright.sync_api import sync_playwright
import os
with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto(f"file://{os.getcwd()}/book/print.html")
    page.wait_for_load_state("networkidle")
    page.pdf(
        path="resume.pdf",
        format="A4",
        print_background=True,
        margin={"top": "1cm", "bottom": "1cm", "left": "1cm", "right": "1cm"}
    )
    browser.close()
PYEOF

echo "Merging PDFs..."
mkdir -p releases
$PYTHON - <<'PYEOF'
from pypdf import PdfWriter, PdfReader
import glob
writer = PdfWriter()
for page in PdfReader("resume.pdf").pages:
    writer.add_page(page)
for pdf in sorted(glob.glob("src/recommendations/*.pdf")):
    print(f"Adding {pdf}")
    for page in PdfReader(pdf).pages:
        writer.add_page(page)
with open("releases/ahaske-resume-and-references.pdf", "wb") as f:
    writer.write(f)
PYEOF

rm -f resume.pdf
echo "Done: releases/ahaske-resume-and-references.pdf"
