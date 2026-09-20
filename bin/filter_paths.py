#!/usr/bin/env python3

import re
import sys

SUCCESS = True

if len(sys.argv) < 2:
    print("Usage: filter_paths.py <SLUG> [changed_files...]")
    sys.exit(1)

SLUG = sys.argv[1]
OUTPUT_MSG = ""

SLUG_TEMPLATE = r"^2026-\d\d-\d\d-.+"
if re.match(SLUG_TEMPLATE, SLUG) is None:
    print("Your slug does not match the template! Please change it.")
    print(f"Your slug: {SLUG}")
    print(f"The template: 2026-MM-DD-[topic-name]")
    print("PATHFILTERFAILED")
    SUCCESS = False
    OUTPUT_MSG = f"Your PR title does not match the slug template, which is <2026-MM-DD-[topic-name]>."

CHANGED_FILES = sys.argv[2:]
ACCEPTABLE_PATTERNS = [
    rf"^_posts/{re.escape(SLUG)}\.md$",
    rf"^assets/img/{re.escape(SLUG)}/.*$",
    rf"^assets/html/{re.escape(SLUG)}/.*$",
    rf"^assets/bibliography/{re.escape(SLUG)}\.bib$"
]

failed_paths = []

for changed_file in CHANGED_FILES:
    if not any(re.match(pattern, changed_file) for pattern in ACCEPTABLE_PATTERNS):
        failed_paths.append(changed_file)

if len(failed_paths) > 0:
    print(f"These files were changed, but they shouldn't have been:")
    for failed in failed_paths:
        print(f"\t{failed}")

    print("PATHFILTERFAILED")
    SUCCESS = False

    if OUTPUT_MSG != "":
        OUTPUT_MSG += " Also, y"
    else:
        OUTPUT_MSG = "Y"
    
    OUTPUT_MSG += f"ou can only add/change/remove files related to your post, i.e. files that match: <_posts/{SLUG}.md, assets/img/{SLUG}/..., assets/html/{SLUG}/..., assets/bibliography/{SLUG}.bib>. But we found that you changed the following: <{' & '.join(failed_paths)}>."

if not SUCCESS:
    OUTPUT_MSG += f" Also, make sure your PR's title ({SLUG}) matches your post's slug!"
    print(OUTPUT_MSG)

if SUCCESS:
    sys.exit(0)
else:
    sys.exit(1)