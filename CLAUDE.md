# EpilexIA — Libro de tesis (LaTeX)

Libro de tesis de grado (Ingeniería en Informática, FP-UNA) sobre **EpilexIA**, sistema de seguimiento de pacientes con epilepsia: visualización de EEG, registro de anomalías, análisis con IA e informes médicos. Escrito en **castellano**, en LaTeX. Dos autores trabajan en paralelo con ramas y Pull Requests; leer [CONTRIBUTING.md](CONTRIBUTING.md) antes de editar.

## Compilación

- Entrada: `Thesis.tex` · Clase: `Thesis.cls` (book, a4paper, 12pt, oneside, babel spanish).
- Cadena: **pdfLaTeX + BibTeX (apacite)** vía `latexmk`. Compilar siempre con `make` (crea las subcarpetas de `build/` que necesita `\include` y pasa `-outdir=build`). Salida: `build/Thesis.pdf`. El `latexmkrc` es mínimo para que también funcione en Overleaf; `make overleaf` genera el zip para subir.
- Comandos: `make` (TeX Live local) · `make docker` (sin LaTeX instalado; requiere Docker corriendo) · `make clean`.
- Si no hay `latexmk` ni Docker disponibles, avisar al usuario y sugerir las opciones del README; **no** instalar MacTeX/TeX Live sin preguntar (son varios GB).
- Tras compilar, revisar `build/Thesis.log` y reportar: errores (`! ...` / `file:line: error`), `Citation ... undefined`, `Reference ... undefined`, `There were multiply-defined labels`, y `Overfull \hbox` significativos (> 10pt). No dar por buena una compilación sin mirar el log.
- Para mostrar el resultado, se pueden leer páginas concretas del PDF con la herramienta Read (`pages`).

## Mapa del documento

| Archivo | Contenido |
|---|---|
| `Chapter1/chapter1.tex` | Introducción |
| `Chapter2/chapter2.tex` | Marco teórico y estado del arte |
| `Chapter3/chapter3.tex` | Metodología de desarrollo |
| `Chapter4/chapter4.tex` | Análisis de requerimientos y diseño |
| `Chapter5/chapter5.tex` | Implementación del sistema |
| `Chapter6/chapter6.tex` | Pruebas y evaluación |
| `Chapter7/chapter7.tex` | Conclusiones y trabajos futuros |
| `Abstract/`, `Resumen/`, `Dedication/`, `Acknowledgement/`, `Abbreviations/`, `Symbols/` | Preliminares |
| `Conclusion/`, `Annex/`, `AppendixA/`, `AppendixB/` | Finales (Conclusión y Anexo están **después** de `\end{document}`, hoy no se compilan) |
| `References/references.bib` | Bibliografía |
| `ThesisFigs/` | Figuras compartidas · `ChapterN/ChapterNFigs/` figuras por capítulo |

Los capítulos se incluyen con `\input{ChapterN/chapterN}`; cada uno define su `\graphicspath` y su `\markboth`. El encabezado de página se fija con `\lhead{\emph{...}}` en `Thesis.tex`.

## Reglas al editar

1. **Minimizar diffs.** Cambiar solo lo pedido. No re-envolver, reindentar ni "limpiar" párrafos que no se tocan: rompe los merges del compañero.
2. **Una oración por línea** en el texto nuevo o en párrafos que se reescriben (LaTeX ignora el salto simple; el PDF no cambia).
3. Preámbulo (`Thesis.tex`, `Thesis.cls`) es zona compartida: no agregar paquetes sin que el usuario lo pida o lo apruebe; si hace falta uno, decirlo.
4. Labels con prefijo (`fig:`, `tab:`, `sec:`, `eq:`, `alg:`, `lst:`) y referencias con `\ref`/`\vref`. Antes de crear un label, verificar que no exista (`grep -rn '\\label{fig:...}'`).
5. Citas: `\citep{}` / `\citet{}` (apacite). Nunca inventar referencias bibliográficas: si falta una fuente, dejar `% TODO: cita` y avisar. Entradas nuevas en `references.bib` al final del archivo, verificando que la clave no exista.
6. Estilo académico formal en castellano, impersonal ("se implementa", "se observa"), tiempo presente. Términos técnicos en inglés en cursiva (`\textit{backend}`). Tildes y ñ en UTF-8 directo.
7. Figuras con `[H]`, `\centering`, `\caption` y `\label`; archivos en minúsculas sin espacios ni tildes.
8. No escribir nada nuevo después de `\end{document}`.
9. Datos de pacientes: las capturas y ejemplos no deben mostrar datos personales reales (nombres, CI, fechas de nacimiento). Si aparece alguno en una figura o texto, advertirlo.

## Git

- Repo: `git@github.com:nandofer126/libro-tesis-epilexia.git`, rama principal `main`.
- Nunca commitear directo en `main`; crear rama `<área>/<descripción>` (`cap4/...`, `bib/...`, `fmt/...`, `fix/...`, `rev/...`).
- Commits en castellano con prefijo del área: `cap5: describe el procesamiento asíncrono del EEG`.
- Antes de commitear o abrir un PR: compilar y confirmar que no hay errores ni citas/referencias indefinidas nuevas.
- No versionar `build/`, PDFs generados ni auxiliares (ya en `.gitignore`).
- En conflictos de merge/rebase: combinar ambos cambios cuando sean compatibles, preguntar cuando se contradigan, y recompilar antes de continuar.
- `main` = última versión aprobada por el tutor (respaldo). No mergear PRs a `main` salvo pedido explícito del usuario.

## Overleaf

- Un solo proyecto (plan gratuito), solo lectura/comentarios del tutor; nunca se edita ahí.
- Para subir: `make overleaf [REF=<rama|commit>]` → `dist/overleaf-completo/` con el **proyecto completo** del último commit (avisar si hay cambios sin commitear). El usuario lo sube con *Upload* + **Overwrite** y luego *Recompile from scratch*.
- **Nunca** preparar carpetas parciales (solo lo cambiado): Overleaf reemplaza carpetas enteras y borra lo que falte. Pasos detallados en el README, sección Overleaf.

## Fuente de verdad técnica

El contenido técnico (endpoints, modelo de datos, arquitectura, flujos) debe coincidir con el código de los repos del sistema, que suelen estar abiertos en el mismo workspace: `epilexIa-back-end`, `epilexIa-web-front-end`, `epilexIa-database`, `epilex-ia-api`, `epilex-ia-motor`. Ante dudas sobre cómo funciona algo, verificar en el código antes de escribirlo en el libro.
