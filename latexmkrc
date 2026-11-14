# Configuración de latexmk para el libro de tesis EpilexIA.
# Uso: `latexmk` (o `make`) desde la raíz del repo. El PDF queda en build/Thesis.pdf.
@default_files = ('Thesis.tex');
$pdf_mode = 1;            # pdflatex
$bibtex_use = 2;          # ejecuta bibtex (apacite) y limpia el .bbl con -c
$out_dir = 'build';
$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -synctex=1 %O %S';
