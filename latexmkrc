# Configuración de latexmk para el libro de tesis EpilexIA.
# Se mantiene mínima a propósito: Overleaf también lee este archivo, y las
# opciones locales (carpeta build/, synctex, etc.) se pasan desde el Makefile.
@default_files = ('Thesis.tex');
$pdf_mode = 1;            # pdfLaTeX
$bibtex_use = 2;          # ejecuta BibTeX (apacite)
