# -*- coding: utf-8 -*-
# defc/__main__.py

import os
import sys

from PySide6.QtGui import QFont, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication

if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon("./defc/resources/img/defc_icon.svg"))
    app.setOrganizationName("Delegación de Estudiantes de la Facultad de Ciencias de la Universidad de Granada")
    app.setOrganizationDomain("Sociocultural")
    app.setApplicationName("Delegación de Estudiantes de la Facultad de Ciencias")
    font = QFont
    font.__dir__
    engine = QQmlApplicationEngine()
    engine.load(os.path.join(os.path.dirname(__file__), "qml/startup.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
