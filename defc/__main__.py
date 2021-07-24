# -*- coding: utf-8 -*-
# defc/__main__.py

import os
from pathlib import Path
import sys

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtGui import QIcon


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("./resources/img/defc_color_icon.svg"))
    app.setOrganizationName("Delegación de Estudiantes de la Facultad de Ciencias de la Universidad de Granada")
    app.setOrganizationDomain("Sociocultural")
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml" / "startup.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
