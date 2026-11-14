# Libro de Tesis — EpilexIA

Libro de tesis de grado de **Ingeniería en Informática** (Facultad Politécnica, Universidad Nacional de Asunción) sobre **EpilexIA**, sistema de seguimiento de pacientes con epilepsia con visualización de EEG y análisis asistido por inteligencia artificial.

- **Autores:** Luis Fernando Delvalle · Rodrigo Amarilla Sanabria
- **Tutor:** D. Sc. Ing. Diego P. Pinto-Roa

El libro está escrito en LaTeX y se versiona en Git para trabajar en paralelo sin pisarse y sin depender de Overleaf. Cada uno compila localmente (o con Docker / Claude Code) y los cambios se integran con *Pull Requests*.

## Estructura

```
Thesis.tex              Documento principal: preámbulo, paquetes y orden de inclusión de capítulos
Thesis.cls              Clase del documento (portada, autores, tutor, universidad)
*.sty                   Paquetes locales (slashbox, vector, lstpatch)
Chapter1/ … Chapter7/   Un directorio por capítulo: chapterN.tex + ChapterNFigs/ (figuras propias)
Abstract/ Resumen/      Resumen en inglés y en castellano
Dedication/ Acknowledgement/ Abbreviations/ Symbols/   Páginas preliminares
Conclusion/ Annex/ AppendixA/ AppendixB/               Conclusiones, anexo y apéndices
References/references.bib   Bibliografía (BibTeX, estilo apacite / APA)
ThesisFigs/             Figuras compartidas entre capítulos (diagramas, capturas generales)
latexmkrc · Makefile    Configuración de compilación
```

| Capítulo | Contenido |
|---|---|
| 1 | Introducción |
| 2 | Marco teórico y estado del arte |
| 3 | Metodología de desarrollo |
| 4 | Análisis de requerimientos y diseño |
| 5 | Implementación del sistema |
| 6 | Pruebas y evaluación |
| 7 | *(vacío por ahora)* |

> **Nota:** en `Thesis.tex` hay contenido **después** de `\end{document}` (Conclusiones, Anexo, segunda bibliografía). LaTeX lo ignora; está ahí como borrador. Para incluir las Conclusiones hay que moverlas antes de `\bibliographystyle`.

## Compilar

El PDF se genera en `build/Thesis.pdf` (la carpeta `build/` no se versiona). Hay tres formas, elegí la que tengas disponible:

### 1. TeX Live local (recomendado para uso diario)

```bash
# macOS — distribución completa (~5 GB):
brew install --cask mactex-no-gui
# o la versión mínima + paquetes que usa el libro:
brew install --cask basictex
sudo tlmgr update --self
sudo tlmgr install latexmk apacite collection-langspanish collection-latexextra collection-pictures collection-pstricks svg xurl

make          # compila
make watch    # recompila al guardar
make open     # abre el PDF (macOS)
make clean    # borra auxiliares
```

En Linux: `sudo apt install texlive-full latexmk` (o el subconjunto equivalente).

### 2. Docker (sin instalar LaTeX)

```bash
make docker   # usa la imagen texlive/texlive:latest (~4 GB la primera vez)
```

### 3. Con Claude Code

Abrí el repo con Claude Code y pedile "compilá la tesis y mostrame los errores". El archivo [CLAUDE.md](CLAUDE.md) le explica cómo compilar, revisar el log y respetar las convenciones del repo.

### Requisitos de la cadena de compilación

- Motor: **pdfLaTeX** (`latexmk`, configurado en [latexmkrc](latexmkrc)).
- Bibliografía: **BibTeX** con **apacite** (`\citep`, `\citet`, estilo APA).
- Codificación: **UTF-8**.

## Trabajo en equipo

Resumen rápido (detalle en [CONTRIBUTING.md](CONTRIBUTING.md)):

1. `git pull` en `main` antes de empezar.
2. Crear una rama por tarea: `git switch -c cap4/diagrama-er`.
3. Escribir, **compilar sin errores**, commitear.
4. `git push -u origin <rama>` y abrir un Pull Request; el compañero revisa y se mergea.

## Repositorio

<https://github.com/nandofer126/libro-tesis-epilexia>

Repos relacionados del sistema EpilexIA (código fuente): `epilexIa-back-end`, `epilexIa-web-front-end`, `epilexIa-database`, `epilex-ia-api`, `epilex-ia-motor`.
