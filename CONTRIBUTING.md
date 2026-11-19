# Cómo trabajamos en el libro

Somos dos autores editando el mismo documento LaTeX. Estas reglas existen para que Git pueda mergear solo y los conflictos sean raros y fáciles de resolver.

## 1. Flujo de ramas

- `main` siempre **compila sin errores** y es la **última versión aprobada por el tutor**: funciona como respaldo. Nadie commitea directo en `main`.
- Una rama por tarea, corta y enfocada. Nombre: `<área>/<descripción-corta>`.

  | Ejemplo | Para |
  |---|---|
  | `cap2/estado-del-arte-eeg` | contenido de un capítulo |
  | `cap6/pruebas-usabilidad` | idem |
  | `bib/referencias-ia` | solo bibliografía |
  | `fmt/tablas-cap4` | formato / maquetación |
  | `fix/typos-cap1` | correcciones menores |
  | `rev/observaciones-tutor` | cambios pedidos por el tutor |
  | `version/mejoras-luis-cap-7` | entrega de un conjunto de cambios para revisión del tutor |

- Ciclo de trabajo:

  ```bash
  git switch main && git pull
  git switch -c cap4/diagrama-er
  # ... editar, compilar (make), revisar el PDF ...
  git add -A && git commit -m "cap4: agrega diagrama ER del subsistema IA"
  git push -u origin cap4/diagrama-er
  # abrir Pull Request en GitHub → el otro revisa → "Squash and merge" o "Merge"
  ```

- Si la rama dura más de un día, traé los cambios de `main` seguido para no acumular conflictos:

  ```bash
  git fetch origin && git rebase origin/main   # o: git merge origin/main
  ```

## 1.1 Revisión del tutor en Overleaf

Tenemos **un solo proyecto de Overleaf** (plan gratuito) y lo usamos solo para que el tutor lea y comente; el texto se edita **siempre en Git**.

1. Se abre el Pull Request de la rama (ej. `version/mejoras-luis-cap-7`) y **no se mergea todavía**.
2. Se sube esa rama a Overleaf con `make overleaf` siguiendo los pasos del [README](README.md#4-overleaf-revisión-del-tutor). Siempre el **proyecto completo** + **Overwrite**: Overleaf reemplaza carpetas enteras, así que subir solo lo que cambió borra el resto (imágenes incluidas).
3. El tutor revisa y comenta en Overleaf. Sus observaciones se pasan a mano a la rama (commits nuevos en el mismo PR, o una rama `rev/...`) y se vuelve a subir.
4. Cuando el tutor aprueba → se mergea el PR a `main`.
5. Si hay que volver a la versión aprobada anterior: `make overleaf REF=main` y subir de nuevo.

Reglas:

- **Nadie edita en Overleaf** (ni nosotros ni el tutor): lo editado ahí se pierde en la siguiente subida.
- **Un solo PR "en revisión del tutor" a la vez**, porque Overleaf muestra una sola versión. Si hay que avisar cuál está subida, dejarlo como comentario en el PR.

## 2. Reglas para minimizar conflictos

Git compara **por línea**. Hoy muchos párrafos ocupan una sola línea larguísima, así que si los dos tocamos el mismo párrafo (aunque sean palabras distintas) hay conflicto.

1. **Una oración por línea en el texto nuevo o reescrito.** LaTeX ignora un salto de línea simple, el PDF queda idéntico. Un párrafo nuevo sigue siendo una línea en blanco.

   ```latex
   La epilepsia es una enfermedad cerebral crónica no transmisible.
   Afecta a personas de todas las edades \citep{WHO2024Epilepsy}.

   Nuevo párrafo.
   ```

   No reformatear capítulos enteros de golpe "para dejarlo prolijo": ese commit choca con todo lo que el compañero tenga abierto. Se aplica al ir editando cada párrafo.

2. **Repartirse por capítulo o sección.** Antes de empezar algo grande, avisar en qué archivo/sección se va a trabajar (chat, issue o PR en borrador).
3. **`Thesis.tex` y `Thesis.cls` son zona compartida.** Agregar paquetes o cambiar el preámbulo en un PR propio, chico (`fmt/...`), y mergearlo rápido.
4. **`references.bib`:** agregar entradas nuevas **al final** del archivo, una por bloque, separadas por una línea en blanco. Antes de agregar, buscar si la clave ya existe (`grep -n "@.*{Clave" References/references.bib`).
5. **Figuras:** las de un capítulo van en `ChapterN/ChapterNFigs/`; las compartidas en `ThesisFigs/`. Nombres en minúsculas, sin espacios ni tildes, descriptivos (`secuencia_carga_video.png`). Las imágenes son binarias: si dos personas modifican la misma imagen, uno de los dos cambios se pierde — coordinar.
6. **No versionar el PDF ni los auxiliares** (ya están en `.gitignore`). Cada uno compila el suyo.

## 3. Convenciones de LaTeX

- Codificación UTF-8; tildes y ñ escritas directamente (no `\'a`).
- Toda figura, tabla, capítulo y sección lleva `\label` con prefijo:
  `fig:`, `tab:`, `sec:`, `eq:`, `alg:`, `lst:` (ej. `\label{fig:arquitectura-general}`). Referenciar con `\ref` / `\vref`, nunca con números a mano.
- Citas con apacite: `\citep{clave}` → (Autor, año), `\citet{clave}` → Autor (año).
- Términos en inglés en cursiva: `\textit{frontend}`, `\textit{backend}`.
- Figuras:

  ```latex
  \begin{figure}[H]
    \centering
    \includegraphics[width=0.9\textwidth]{nombre_archivo}
    \caption{Descripción de la figura.}
    \label{fig:nombre-archivo}
  \end{figure}
  ```

- No dejar texto ni comandos nuevos después de `\end{document}`.

## 4. Commits

- Mensaje en castellano, en presente, con prefijo del área: `cap5: describe el procesamiento asíncrono del EEG`, `bib: agrega referencias de CNN para EEG`, `fmt: ajusta ancho de tablas del cap4`.
- Un commit = un cambio coherente. No mezclar reescritura de contenido con reformateo masivo.

## 5. Pull Requests

Antes de abrir el PR:

- [ ] `make` compila sin errores (warnings de referencias indefinidas = algo falta).
- [ ] Revisé las páginas modificadas en el PDF.
- [ ] Las citas nuevas existen en `references.bib`.
- [ ] Las figuras nuevas están commiteadas y referenciadas en el texto.

El otro autor revisa el diff (y si quiere el PDF compilado) y aprueba. Las observaciones se dejan como comentarios en las líneas del PR.

## 6. Resolver un conflicto

```bash
git fetch origin && git rebase origin/main
# Git marca los archivos en conflicto:
#   <<<<<<< HEAD      (lo de main)
#   =======
#   >>>>>>> tu-commit (lo tuyo)
# Editar dejando la versión correcta (o combinando ambas), borrar los marcadores,
git add <archivo> && git rebase --continue
make   # verificar que sigue compilando
git push --force-with-lease
```

Si el conflicto es en una figura (binario), elegir una versión: `git checkout --theirs <archivo>` o `--ours`, y avisar al compañero.

También se puede pedir a Claude Code: "resolvé los conflictos del rebase respetando ambos cambios y compilá".
