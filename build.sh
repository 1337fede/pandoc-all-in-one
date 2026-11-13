#!/bin/bash

CONFIG="$HOME/.pandoc-paths"

NOTES=""
ASSETS=""
INPUT=""

[ -f "$CONFIG" ] && source "$CONFIG"

read -r -p "Please specify notes folder, saved one is: [$NOTES]: " N
read -r -p "Please specify assets folder, saved one is: [$ASSETS]: " A
read -r -p "Please specify input file, saved one is: [$INPUT]: " I

NOTES="${N:-$NOTES}"
ASSETS="${A:-$ASSETS}"
INPUT="${I:-$INPUT}"
OUTPUT="${INPUT%.*}.pdf"

printf 'NOTES=%q\nASSETS=%q\nINPUT=%q\n' \
  "$NOTES" "$ASSETS" "$INPUT" > "$CONFIG"

docker run --rm \
  -v "$NOTES:/data" \
  -v "$ASSETS:/_assets:ro" \
  -v "$ASSETS/fonts:/fonts:ro" \
  -w /data \
  --entrypoint /bin/sh \
  jakobkmar/pandoc-all-in-one \
  -c '
    cp /_assets/frontmatter.yaml .
    cp /_assets/latex-header.tex .
    cp /_assets/mermaid.lua .

    pandoc "$1" \
      --from=markdown+lists_without_preceding_blankline+implicit_figures \
      -L mermaid.lua \
      -L include-code-files/include-code-files.lua \
      -L diagram-generator/diagram-generator.lua \
      --metadata-file=/_assets/frontmatter.yaml \
      --include-in-header=/_assets/latex-header.tex \
      --bibliography="bibliography.bib" \
      --citeproc \
      --verbose \
      --pdf-engine=lualatex \
      -o "$2"
  ' sh "$INPUT" "$OUTPUT"

echo "Generated: $NOTES/$OUTPUT"
