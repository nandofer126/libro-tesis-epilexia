# Atajos de compilación del libro de tesis.
#   make           -> compila con la TeX Live local (build/Thesis.pdf)
#   make docker    -> compila dentro de un contenedor TeX Live (no requiere LaTeX instalado)
#   make watch     -> recompila automáticamente al guardar
#   make clean     -> borra build/
#   make open      -> abre el PDF (macOS)
#   make overleaf  -> genera dist/tesis_epilexia_overleaf.zip para subir a Overleaf

TEXLIVE_IMAGE ?= texlive/texlive:latest
OUT := build
PDF := $(OUT)/Thesis.pdf
ZIP := dist/tesis_epilexia_overleaf.zip
LATEXMK := latexmk -outdir=$(OUT) -interaction=nonstopmode -file-line-error -synctex=1

# \include escribe un .aux por archivo dentro de su carpeta: con -outdir esas
# carpetas deben existir en build/ antes de compilar.
INCLUDE_DIRS := $(shell sed -n 's/^[[:space:]]*\\include{\([^}/]*\)\/.*/\1/p' Thesis.tex | sort -u)
MKDIRS := mkdir -p $(addprefix $(OUT)/,$(INCLUDE_DIRS))

.PHONY: pdf docker watch clean open overleaf

pdf:
	$(MKDIRS)
	$(LATEXMK)

docker:
	docker run --rm -v "$(CURDIR)":/work -w /work $(TEXLIVE_IMAGE) sh -c '$(MKDIRS) && $(LATEXMK)'

watch:
	$(MKDIRS)
	$(LATEXMK) -pvc -view=none

clean:
	rm -rf $(OUT)

open:
	open $(PDF)

overleaf:
	mkdir -p dist
	rm -f $(ZIP)
	zip -r -q $(ZIP) . -x '.git/*' '$(OUT)/*' 'dist/*' '.claude/*' '*.zip' '*.DS_Store'
	@echo "Listo: $(ZIP) (Overleaf: New Project > Upload Project)"
