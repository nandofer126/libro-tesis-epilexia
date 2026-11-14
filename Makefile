# Atajos de compilación del libro de tesis.
#   make         -> compila con la TeX Live local (build/Thesis.pdf)
#   make docker  -> compila dentro de un contenedor TeX Live (no requiere LaTeX instalado)
#   make watch   -> recompila automáticamente al guardar
#   make clean   -> borra auxiliares
#   make open    -> abre el PDF (macOS)

TEXLIVE_IMAGE ?= texlive/texlive:latest
PDF := build/Thesis.pdf

.PHONY: pdf docker watch clean open

pdf:
	latexmk

docker:
	docker run --rm -v "$(CURDIR)":/work -w /work $(TEXLIVE_IMAGE) latexmk

watch:
	latexmk -pvc -view=none

clean:
	latexmk -C
	rm -rf build

open:
	open $(PDF)
