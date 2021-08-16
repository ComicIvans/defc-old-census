# -*- coding: utf-8 -*-
# defc/__main__.py

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication
from defc.backend.startup import StartupBackend
from defc.backend.censo import CensoBackend
import os
import sys

from PySide6.QtGui import QColor, QIcon, QPalette
from PySide6.QtQml import QQmlApplicationEngine

# Creamos las variables que contendran las funciones que conectan la interfaz con el código.
startupBackend = StartupBackend()
censoBackend = CensoBackend()

# Creamos la aplicación y le damos un poquito de configuración.
app = QApplication(sys.argv)
app.setWindowIcon(QIcon("./defc/resources/img/defc_icon.svg"))
app.setOrganizationName("Delegación de Estudiantes de la Facultad de Ciencias de la Universidad de Granada")
app.setOrganizationDomain("Sociocultural")
app.setApplicationName("Delegación de Estudiantes de la Facultad de Ciencias")
app.setStyle("Fusion")

# Colorcillos para la ventanta (tema oscuro).
palette = QPalette()
palette.setColor(QPalette.Window, QColor(53, 53, 53))
palette.setColor(QPalette.WindowText, Qt.white)
palette.setColor(QPalette.Base, QColor(25, 25, 25))
palette.setColor(QPalette.AlternateBase, QColor(53, 53, 53))
palette.setColor(QPalette.ToolTipBase, Qt.black)
palette.setColor(QPalette.ToolTipText, Qt.white)
palette.setColor(QPalette.Text, Qt.white)
palette.setColor(QPalette.Button, QColor(53, 53, 53))
palette.setColor(QPalette.ButtonText, Qt.white)
palette.setColor(QPalette.BrightText, Qt.red)
palette.setColor(QPalette.Link, QColor(42, 130, 218))
palette.setColor(QPalette.Highlight, QColor(42, 130, 218))
palette.setColor(QPalette.HighlightedText, Qt.black)
app.setPalette(palette)

# Creamos el motor gráfico.
engine = QQmlApplicationEngine()
# Para que desde los archivos QML se pueda llamar a las variables, necesitamos añadirlas como propiedad.
engine.rootContext().setContextProperty("startupBackend", startupBackend)
engine.rootContext().setContextProperty("censoBackend", censoBackend)

# Cargamos la pantalla de inicio.
engine.load(os.path.join(os.path.dirname(__file__), "qml" + os.path.sep + "startup.qml"))

# Para poder acceder facilmente a las ventanas principales, se crean unas variables que las "señalarán" cuando se creen.
startupMainWindow = engine.rootObjects()[0]
censoMainWindow = None

def main():
    if not engine.rootObjects(): # Si no hay nada que cargar, el programa falla.
        sys.exit(-1)
    sys.exit(app.exec()) # En otro caso, se ejecuta.
