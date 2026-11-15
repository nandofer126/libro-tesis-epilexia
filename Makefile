# Atajos de compilación del libro de tesis.
#   make           -> compila con la TeX Live local (build/Thesis.pdf)
#   make docker    -> compila dentro de un contenedor TeX Live (no requiere LaTeX instalado)
#   make watch     -> recompila automáticamente al guardar
#   make clean     -> borra build/
#   make open      -> abre el PDF (macOS)
#   make overleaf  -> genera dist/overleaf-completo/ (y su .zip) desde el último commit
#                     de la rama actual; `make overleaf REF=main` para otra rama/commit

TEXLIVE_IMAGE ?= texlive/texlive:latest
OUT := build
PDF := $(OUT)/Thesis.pdf
REF ?= HEAD
OVERLEAF_DIR := dist/overleaf-completo
ZIP := dist/tesis_epilexia_overleaf.zip
# Archivos del repo que no hacen falta en Overleaf
REPO_ONLY := README.md CLAUDE.md CONTRIBUTING.md Makefile latexmkrc .gitignore .gitattributes
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

# Exporta el proyecto COMPLETO (todas las carpetas e imágenes) tal como está en
# el commit $(REF). Overleaf reemplaza carpetas enteras al subir: nunca subir
# carpetas parciales.
overleaf:
	rm -rf dist/overleaf-completo dist/tesis_epilexia_overleaf.zip
	mkdir -p $(OVERLEAF_DIR)
	git archive $(REF) | tar -x -C $(OVERLEAF_DIR)
	cd $(OVERLEAF_DIR) && rm -f $(REPO_ONLY)
	cd $(OVERLEAF_DIR) && zip -r -q ../$(notdir $(ZIP)) .
	@git diff --quiet HEAD -- . || echo "AVISO: hay cambios sin commitear; NO están incluidos (se exporta $(REF))."
	@echo "Listo: $(OVERLEAF_DIR)/ ($$(find $(OVERLEAF_DIR) -type f | wc -l | tr -d ' ') archivos) desde $(REF) = $$(git rev-parse --short $(REF))"
	@echo "Subir TODO su contenido a Overleaf y confirmar Overwrite (ver README, sección Overleaf)."
