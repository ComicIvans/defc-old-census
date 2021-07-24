# -*- coding: utf-8 -*-
# DEFC/main.py

import os
from pathlib import Path
import sys

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine


class window():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.load(os.fspath(Path(__file__).resolve().parent / "startup.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
