# -*- coding: utf-8 -*-
# defc/views/censo.py

from PySide6.QtCore import SIGNAL, Qt
from PySide6.QtWidgets import QGridLayout, QHBoxLayout, QListView, QListWidget, QMainWindow, QMenu, QMenuBar, QMessageBox, QStyledItemDelegate, QTableView, QAbstractItemView, QTreeView, QVBoxLayout, QWidget
import defc.main as main

# Ventanda del censo y sus componentes.

class Window(QMainWindow):
    
    def __init__(self, parent=None):
        super().__init__(parent)

        # Configuración de la ventana.
        self.setWindowTitle("Censo - Delegación de Estudiantes de la Facultad de Ciencias")
        self.setMinimumHeight(450)
        self.setMinimumWidth(800)
        
        # Configuración de la tablita.
        self.table = QTableView()
        self.table.setModel(main.censoBackend.model)
        self.table.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.table.resizeColumnsToContents()
        self.table.setItemDelegateForColumn(5, main.censoBackend.delegate)

        # Configuración del listado de tablas.
        self.drawer = QTreeView()
        self.drawer.setSortingEnabled(True)
        self.drawer.setModel(main.censoBackend.drawerModel)
        self.drawer.expandAll()
        self.drawer.doubleClicked.connect(main.censoBackend.changeDB)

        # Configuración de la barra de menu.
        self.menu = QMenuBar()
        self.setMenuBar(self.menu)
        self.menu.setNativeMenuBar(False)
        menuArchivo = QMenu("Archivo")
        menuArchivo.addAction("Importar")
        menuArchivo.addAction("Exportar")
        self.menu.addMenu(menuArchivo)

        # Configuración del estilo.
        self.layout = QGridLayout()
        self.centralWidget = QWidget()
        self.setCentralWidget(self.centralWidget)
        self.centralWidget.setLayout(self.layout)
        self.layout.addWidget(self.drawer,0,0)
        self.layout.addWidget(self.table,0,1)
        self.layout.setColumnStretch(1, 2)