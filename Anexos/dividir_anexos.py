#!/usr/bin/env python3
"""Divide build/Anexos.pdf en un PDF por anexo (A, B y C), dentro de Anexos/.

Uso (desde la raíz del repositorio, después de compilar Anexos.tex):
    python3 Anexos/dividir_anexos.py
Requiere: pip install pypdf
A cada PDF se le agregan la portada, la presentación y las referencias.
"""
import re, sys
from pypdf import PdfReader, PdfWriter

SRC = "build/Anexos.pdf"
NOMBRES = {"A": "Anexo_A_Analisis_y_diseno.pdf",
           "B": "Anexo_B_Implementacion.pdf",
           "C": "Anexo_C_Pruebas.pdf"}

toc = open("build/Anexos.toc", encoding="latin-1").read()
inicio = {m.group(1): int(m.group(2)) for m in
          re.finditer(r"contentsline \{chapter\}\{\\numberline \{([ABC])\}.*?\}\{(\d+)\}", toc)}
ref = int(re.search(r"contentsline \{chapter\}\{Referencias\}\{(\d+)\}", toc).group(1))
r = PdfReader(SRC)
etiquetas = r.page_labels
def indice(n):                      # índice de la página con numeración arábiga n
    return max(i for i, e in enumerate(etiquetas) if e == str(n))
primera = indice(1)                 # páginas previas: portada, presentación e índice
portada = list(range(0, 2))
lim = {"A": (indice(inicio["A"]), indice(inicio["B"])),
       "B": (indice(inicio["B"]), indice(inicio["C"])),
       "C": (indice(inicio["C"]), indice(ref))}
refs = list(range(indice(ref), len(r.pages)))
for k, (a, b) in lim.items():
    w = PdfWriter()
    for i in portada + list(range(a, b)) + refs:
        w.add_page(r.pages[i])
    w.write("Anexos/" + NOMBRES[k])
    print(NOMBRES[k], len(portada) + (b - a) + len(refs), "páginas")
