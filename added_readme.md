# Overview of Knowledge Management System
```mermaid

%%{
init: {
    'theme': 'base',
    'themeVariables': {
    'lineColor': '#000000'
    }
}
}%%

%%{ 
init: { 
    'flowchart': { 
    'curve': 'rounded',
    'htmlLabels': 'true'
    } 
} 
}%%

flowchart LR
classDef yellow fill:#fff700, color:#000000, stroke:#fff700;
classDef specs fill:#ffffff, color:#000000, stroke:#000000;
classDef hw fill:#d1d1d1, stroke:#d1d1d1, text-align:center, font-weight: bold;
classDef cable fill:#ff7300, color:#ffffff, stroke:#f7570c, text-align:center;
classDef sensor fill:#ff009d, color:#ffffff, stroke:#ff009d, text-align:center, text-transform: uppercase, font-weight: bold;

%% Archive

A0("
Text 
(.MD)
")

A1("
Portable Documents 
(.PDF)
")

A2("
Images 
(.JPEG, .PNG, ...)
")

A3("
Videos 
(.MP4, ...)
")

A4("
Database 
(.JSON)
")


%% Middlemen

D0("
Bibliography 
(.BIB)
")

D1("
Descriptions 
(.TEX)
")

D2("
YAML 
Frontmatter 
(.MD)
")

D3("
<b>pandoc cli</b>
+ dependencies
")

D6("
<b>npx serve</b>
+ Reveal.js and D3.js Dependencies
")

D7("
<b>Joplin</b>
")

D8("
<b>Fonts</b>
")


%% Formats

F0("
.PDF
")

F1("
Webpage 
Structure
(.HTML)
")

F2("
Styling 
Template
(.CSS)
")

F3("
.PPT
")

%% Outputs

Z0("
Peer-reviewed
Article
")

Z1("
Video 
Presentation
")

Z2("
Static 
Portfolio
")

Z3("
Static 
CV
")

Z4("
Webpage
")

Z5("
Structured 
Notes with
citations
(.MD)
")

Z6("
Mermaid 
Diagrams 
(.MD)
")

%% Translators

B0("
<b>LaTeX cli</b>
+ dependencies
")

B1("
<b>IDE</b>
+ markdownPreview Enhanced
")

B2("
<b>Reference Manager</b>
")

B3("
<b>python converter</b>
JSON-to-TeX
")

%% Visualisers

S1{{"
<b>Cross-platform GUI</b>: Zotero
"}}

S2{{"
<b>Cross-platform GUI</b>: TeXstudio
"}}

S3{{"
<b>Cross-platform GUI</b>: VSCode
"}}

subgraph _assets
            A0
            A1
            A2
            A3
            Z5
            Z6
        end

subgraph AAAAMMYY_snapshots
            F1
            F2
            D1
            D2
            D0
            B3
            A4
        end

subgraph system-wide installs
    D6
    D3
    S2 x--x B0
    S3 x--x B1
    S1 x--x B2
end

A0 --> D3 --> D1
A0 --> B1

A2 --> B0
A2 --> B1
A3 --> D3
D2 --> B1
D6 --> Z4
F1 --> D6
F2 --> D6
A2 --> D6
A3 --> D6
D1 --> D6
Z5 --> D3
Z6 --> Z5
Z4 --> F3--> Z1

A0 --> B0 
D3 --> F0 --> Z0
F0 --> Z2
F0 --> Z3
A1 --> B2
A1 --> A0
B2 --> A4
B2 --> D0 --> B0
D0 --> B1
D1 --> B0
B0 --> F0

B1 --> Z5
B1 --> Z6
A4 --> B3 --> D1


%% Styling
class A0,A1,A2,A3,A4,D0,Z5,Z6,F1,F2,D1,D2 hw
class F0,F3 cable
class Z0,Z1,Z2,Z3,Z4,Z7 sensor
class S1,S2,S3,B0,B1,B2,B3,D3,D6 specs


linkStyle default stroke:#f7570c, stroke-width:2px
```
# How to Use
- Your markdown file and its additional resources should be located in a folder structure such as this: 
```
notes-folder/
├── _resources/
│   ├── IMG_6436.png
│   ├── IMG_6438.png
│   └── ...
├── input.md
```
- For example, let's take this as starting folder:
```
Appunti Corso Saldatura/
├── _resources/
│   ├── IMG_6436.png
│   ├── IMG_6438.png
│   └── ...
├── Appunti Corso Saldatura.md
```
- Run, from locally cloned repo:
```
NOTES="$HOME/Desktop/archival future"
ASSETS="/media/fede-ubuntu/STORAGE1/CW/_assets"
INPUT="archival future.md"
OUTPUT="archival future.pdf"

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

    pandoc "$1" \
      --from=markdown+lists_without_preceding_blankline+implicit_figures \
      --metadata-file=/_assets/frontmatter.yaml \
      --include-in-header=/_assets/latex-header.tex \
      --bibliography="bibliography.bib" \
      --citeproc \
      --pdf-engine=lualatex \
      -o "$2"
  ' sh "$INPUT" "$OUTPUT"
```
and link your `metadata.yaml`, `header.tex`, `bibliography.bib` to the correct location. In this way, the YAML frontmatter should control document-level settings, while the LaTeX header should handle custom typography and formatting that Pandoc's metadata cannot express directly.
- Keep updated with:
```
git add .
#stage your changes.
git commit -m "feat: ..."
#create a commit.
git push -u
```


