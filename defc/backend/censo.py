# -*- coding: utf-8 -*-
# defc/backend/censo.py

import os
import pathlib
from PySide6.QtGui import Qt

from PySide6.QtWidgets import QHBoxLayout, QMainWindow, QMessageBox, QTableView, QAbstractItemView, QVBoxLayout, QWidget
import defc.main as main

from PySide6.QtCore import Property, QObject, Slot, Signal
from PySide6.QtSql import QSqlDatabase, QSqlQuery, QSqlRelationalTableModel

# Ventanda del censo y sus componentes.

class Window(QMainWindow):
    
    def __init__(self, parent=None):
        super().__init__(parent)

        # Configuración de la ventana.
        self.setWindowTitle("Censo - Delegación de Estudiantes de la Facultad de Ciencias")
        
        # Configuración de la tablita.
        self.table = QTableView()
        self.table.setModel(main.censoBackend.model)
        self.table.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.table.resizeColumnsToContents()

        # Configuración del estilo.
        self.layout = QHBoxLayout()
        self.centralWidget = QWidget()
        self.setCentralWidget(self.centralWidget)
        self.centralWidget.setLayout(self.layout)
        self.layout.addWidget(self.table)

# Aquí se gestionan todas las interacciones del usuario con la pantalla del censo.

class CensoBackend(QObject):

    def __init__(self):
        QObject.__init__(self)

    def openDatabase(self):
        self.connection = QSqlDatabase.addDatabase("QSQLITE", connectionName="qt_sql_censo") # Creamos la conexión y le damos un nombre.
        self.connection.setDatabaseName("defc" + os.path.sep + "data" + os.path.sep + "censo.sqlite") # Cargamos la base de datos.
        if not self.connection.open(): # Si no se puede abrir, da error.
            QMessageBox.warning(
                None,
                "Censo - Delegación de Estudiantes de la Facultad de Ciencias"
                f"Database Error: {self.connection.lastError().text()}",
            )

    def createPlenoTable(self):
        createTableQuery = QSqlQuery(self.connection)
        return createTableQuery.exec( # Creamos la tabla del Pleno ni no existe. Esto es provisional.
            """
            CREATE TABLE IF NOT EXISTS Pleno (
                ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
                DNI VARCHAR(9),
                Nombre VARCHAR(40) NOT NULL,
                Apellidos VARCHAR(80) NOT NULL,
                Correo_UGR VARCHAR(50) NOT NULL
            )
            """
        )

    def loadModel(self):
        self.model = QSqlRelationalTableModel(db = self.connection) # Creamos el modelo indicando la base de datos.
        self.model.setTable("Pleno") # Cargamos la tabla del Pleno.
        self.model.setEditStrategy(QSqlRelationalTableModel.OnManualSubmit) # Los cambios hechos no se guardan en la base de datos a no ser que lo indiquemos manualmente.
        self.model.select() # El modelo carga la tabla.

        headers = []

        headersQuery = QSqlQuery( # Obtenemos las cabeceras de la tabla.
            """
            PRAGMA TABLE_INFO(Pleno)
            """,
            self.connection
            )
        while headersQuery.next():
            headers.append(headersQuery.value(1).replace("_", " ")) # Reemplazamos _ por espacios.

        for columnIndex, header in enumerate(headers): # Aplicamos las cabeceras al modelo.
            self.model.setHeaderData(columnIndex, Qt.Horizontal, header)

    def loadUI(self):
        self.openDatabase()
        self.createPlenoTable()
        self.loadModel()
        main.censoMainWindow = Window()
        main.censoMainWindow.showMaximized()