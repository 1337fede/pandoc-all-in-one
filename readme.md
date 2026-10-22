### added
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
docker run --rm \
  -v "$HOME/Desktop/Appunti Corso Saldatura:/data" \
  -v "/media/fede-ubuntu/STORAGE1/CW/_assets:/_assets:ro" \
  -v "/media/fede-ubuntu/STORAGE1/CW/_assets/fonts:/fonts:ro" \
  -w /data \
  --entrypoint /bin/sh \
  jakobkmar/pandoc-all-in-one \
  -c '
    cp /_assets/frontmatter.yaml .
    cp /_assets/latex-header.tex .

    pandoc "Appunti Corso Saldatura.md" \
      --from=markdown+lists_without_preceding_blankline+implicit_figures \
      --metadata-file=/_assets/frontmatter.yaml \
      --include-in-header=/_assets/latex-header.tex \
      --pdf-engine=lualatex \
      -o "Appunti Corso Saldatura.pdf"
  '
```
and link your `metadata.yaml`, `header.tex`, `bibliography.bib` to the correct location. In this way, the YAML frontmatter should control document-level settings, while the LaTeX header should handle custom typography and formatting that Pandoc's metadata cannot express directly.





# pandoc-all-in-one

All-in-one Docker image for [`pandoc`](https://pandoc.org/) (see [goals](#goals)) including:
  - custom bundled filters:
    - [**Mermaid Filter**](https://mermaid.js.org/)
    - a filter for including external files in your document
    - all official [lua-filters](https://github.com/pandoc/lua-filters) are bundled
      - `diagram-generator` is already enabled by default, which includes
        - plantuml, graphviz, tikz
        - python runner (python3, matplotlib and numpy are bundled with the image)
  - pre-installed dependencies:
    - **TeXLive**
    - wkhtmltopdf
    - librsvg, ghostscript, inkscape
  - utilities for your working environment:
    - **`--watch`** flag for the pandoc command, keeping the process alive and recompiling on changes

*This image is work in progress.*

## Installation

### Linux

To use this image simply create an [`alias`](https://man7.org/linux/man-pages/man1/alias.1p.html) (`alias pandoc='...'`).

with [**Podman**](https://podman.io/)
```bash
alias pandoc='podman run --rm -it -v "$(pwd):/data:z" jakobkmar/pandoc-all-in-one'
```

with [**Docker**](https://www.docker.com/)
```bash
alias pandoc='docker run --rm -it -v "$(pwd):/data" jakobkmar/pandoc-all-in-one'
```

(Add the alias to your `.bashrc` or `.zshrc`)

### Windows

To set an alias on Windows, create a file called `$HOME/Document/profile.ps1` and insert the following content

```powershell
function RunPandoc {
    docker run --rm -it -v "$(pwd):/data" jakobkmar/pandoc-all-in-one
}

Set-Alias pandoc RunPandoc
```

## Filters

### Mermaid Diagrams

To use the mermaid filter, create a code block like this

```pandoc
~~~mermaid {width=350}
flowchart LR
  A["Create a chart"] --> B["Never look at it again"]
~~~
```
All parameters after `.mermaid` are optional.

Result:
```mermaid
flowchart LR
  A["Create a chart"] --> B["Never look at it again"]
```

### Include files

To include external files, you can also use a code block
```pandoc
~~~c {include="my_file.c"}
This is the placeholder for an external file.
~~~
```
Optionally, you can specify the language explicitly using `.lang` before the include parameter.

## Flags

The following flags are available:
- `--watch` - the process will keep running, if you write a new change to document pandoc will be rerun

## Goals

This project aims to provide an extremely effortless distribution of pandoc, which has:
- all necessary dependencies pre-installed
- commonly used filters pre-applied
- utilities for the development environment of your document included
- use LaTeX math whenever you need it

You should be able to create a markdown file, just run one command and have an editor, live preview and the actual output all available in seconds.
This allows you to take notes quickly, create presentations using the `-t beamer` flag and visualize your thoughts on the fly in graphs, and more!
And all of this using the editor of your choice - no more random online editors.

## Planned

More features are planned, for example:
- bundle more filters
- add more command line utilities like opening a full environment for working with your input file and viewing the rendered output in real time
- make the mermaid filter more reliable
- convert SVGs with Inkscape when the target document is a PDF, since it has better conversion in certain scenarios
