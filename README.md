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

### 4. Overleaf (revisión del tutor)

Usamos **un único proyecto de Overleaf** (plan gratuito) solo para que el tutor lea y comente. **No se edita en Overleaf**: la fuente es Git.

- `main` = última versión aprobada por el tutor (es también el respaldo).
- Overleaf = lo que el tutor está revisando ahora, normalmente la rama del Pull Request abierto.

**Subir una versión a Overleaf**

1. Commitear todo en la rama a revisar (`make overleaf` exporta el **último commit**, no los cambios sin commitear) y verificar que compila (`make` o `make docker`).
2. Generar el proyecto completo:

   ```bash
   make overleaf              # desde la rama actual
   make overleaf REF=main     # o desde otra rama / commit / tag
   ```

   Crea `dist/overleaf-completo/` (y `dist/tesis_epilexia_overleaf.zip`), con **todas** las carpetas e imágenes.
3. En Overleaf, seleccionar `Thesis.tex` en el árbol de archivos (así el destino es la raíz) → ícono **Upload** → arrastrar **todo el contenido** de `dist/overleaf-completo/` (Cmd+A).
4. Overleaf avisa que las carpetas ya existen → **Overwrite**. Si muestra *"Sorry, something went wrong"*, repetir la subida: la segunda vez completa la carga.
5. Flecha junto a **Recompile** → **Recompile from scratch**. Revisar que no haya errores `not found` y que el número de páginas sea el esperado.

> ⚠️ **Overwrite reemplaza carpetas enteras**, no archivo por archivo: todo lo que no esté en la carpeta subida se borra de Overleaf. Por eso **nunca se suben carpetas parciales** (solo lo que cambió), y por eso cualquier cosa editada dentro de Overleaf se pierde en la siguiente subida.
>
> Archivos borrados o renombrados en el repo que estén en la **raíz** quedan en Overleaf como copia vieja; borrarlos a mano.

**Volver atrás** (p. ej. el tutor no aprueba y hay que mostrar la versión anterior): `make overleaf REF=main` y repetir los pasos 3–5.

**Proyecto nuevo** (solo si hiciera falta empezar de cero): *New Project → Upload Project* con `dist/tesis_epilexia_overleaf.zip`; en *Menu* elegir compilador **pdfLaTeX**, documento principal **Thesis.tex** y TeX Live **2026**.

**Límites del plan gratuito:** la compilación completa tarda ~40 s. Si Overleaf corta por tiempo: *Recompile → Compile mode → Fast [draft]* (imágenes como recuadros) o compartir `build/Thesis.pdf`.

### Requisitos de la cadena de compilación

- Motor: **pdfLaTeX** (`latexmk`; opciones locales en el [Makefile](Makefile), configuración común en [latexmkrc](latexmkrc)).
- Bibliografía: **BibTeX** con **apacite** (`\citep`, `\citet`, estilo APA).
- Codificación: **UTF-8**.

## Trabajo en equipo

Resumen rápido (detalle en [CONTRIBUTING.md](CONTRIBUTING.md)):

1. `git pull` en `main` antes de empezar.
2. Crear una rama por tarea: `git switch -c cap4/diagrama-er`.
3. Escribir, **compilar sin errores**, commitear.
4. `git push -u origin <rama>` y abrir un Pull Request; el compañero revisa.
5. Si el cambio necesita revisión del tutor: subir la rama a Overleaf (sección Overleaf) y **mergear a `main` recién cuando el tutor aprueba**.

## Repositorio

<https://github.com/nandofer126/libro-tesis-epilexia>

Repos relacionados del sistema EpilexIA (código fuente): `epilexIa-back-end`, `epilexIa-web-front-end`, `epilexIa-database`, `epilex-ia-api`, `epilex-ia-motor`.
