# Configuration file for the Sphinx documentation builder.
# BorrerOS — Documentación completa
# Sistemas Operativos 2026 — UCU Campus Salto

import os, sys
sys.path.insert(0, os.path.abspath("."))

project   = "BorrerOS"
copyright = "2026, Equipo BorrerOS — UCU Campus Salto"
author    = "Equipo BorrerOS"
release   = "1.0"
language  = "es"

extensions = [
    "sphinx.ext.todo",
    "sphinx.ext.duration",
]

templates_path   = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]
html_title = "BorrerOS — Documentación"
html_css_files = ["custom.css"]

html_theme_options = {
    "collapse_navigation": False,
    "sticky_navigation": True,
    "navigation_depth": 4,
    "titles_only": False,
}

todo_include_todos = True
