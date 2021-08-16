# -*- coding: utf-8 -*-
# defc/backend/startup.py

from defc.backend.censo import CensoBackend
import os
import pathlib
import defc.main as main

from PySide6.QtCore import QObject, Slot, Signal
from PySide6.QtQml import QQmlApplicationEngine

# Aquí se gestionan todas las interacciones del usuario con la pantalla de inicio.

class StartupBackend(QObject):

    def __init__(self):
        QObject.__init__(self)

    @Slot(str) # Necesario para que la función se pueda llamar desde el archivo QML.
    def btnPushed(self, text):
        main.startupMainWindow.close() # Cerramos la ventana de inicio.
        if text == "censo":
            main.censoBackend.loadUI()