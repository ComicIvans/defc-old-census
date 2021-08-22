# -*- coding: utf-8 -*-
# defc/backend/censo.py

import os
import pathlib
import json
from datetime import date
from typing import List
from PySide6 import QtCore
from PySide6.QtGui import QAction, Qt

from PySide6.QtWidgets import QItemDelegate, QMessageBox, QStyledItemDelegate
import defc.main as main
from defc.views.censo import Window

from PySide6.QtCore import Property, QAbstractItemModel, QObject, Slot, Signal
from PySide6.QtSql import QSqlDatabase, QSqlQuery, QSqlQueryModel, QSqlRelationalTableModel



# Clase encargada de manterner los metadatos.

class Internal(object):

    def __init__(self):
        super().__init__()
        with open(os.path.dirname(main.__file__) + os.path.sep + "data" + os.path.sep + "censo" + os.path.sep + "censo.json", "r+") as self.file: # Abrimos y cargamos en una variable el archivo JSON.
            self.data = json.load(self.file)

        self.year = date.today().year # El año sirve para indicar la base de datos del curso actual.
        if date.today().month < 8: # Si aun no estamos en agosto, el año de las bases de datos es uno menos al actual.
            self.year = self.year - 1
        elif str(self.year) not in self.data.keys(): # Si estamos en agosto, creamos el registro del próximo curso.
            self.data[str(self.year)] = {
                "Curso": str(self.year) + "-" + str(self.year + 1),
                "Inicio": "",
                "Fin": "",
                "Tablas": {}
            }
            self.save()

    def save(self): # Cada vez que se modifique el contenido de data, habrá que llamar a esta función para evitar que se pueda perder.
        with open(os.path.dirname(main.__file__) + os.path.sep + "data" + os.path.sep + "censo" + os.path.sep + "censo.json", "w+") as self.file:
            json.dump(self.data, self.file, indent=4)



# Clase encargada de manterner la estructura de la vista jerárquica del lateral. (Donde se muestran las tablas)

class Node(object):
    
    def __init__(self, name, parent=None):
        
        self._name = name
        self._children = []
        self._parent = parent
        
        if parent is not None:
            parent.addChild(self)

    def addChild(self, child):
        self._children.append(child)

    def insertChild(self, position, child):
        
        if position < 0 or position > len(self._children):
            return False
        
        self._children.insert(position, child)
        child._parent = self
        return True

    def removeChild(self, position):
        
        if position < 0 or position > len(self._children):
            return False
        
        child = self._children.pop(position)
        child._parent = None

        return True


    def name(self):
        return self._name

    def setName(self, name):
        self._name = name

    def child(self, row):
        return self._children[row]
    
    def childCount(self):
        return len(self._children)

    def parent(self):
        return self._parent
    
    def row(self):
        if self._parent is not None:
            return self._parent._children.index(self)



# Modelo encargado de mantener los datos de la vista jerárquica de las tablas.

class DrawerModel(QAbstractItemModel):
    
    def __init__(self, root, parent=None):
        super(DrawerModel, self).__init__(parent)
        self._rootNode = root

    def rowCount(self, parent):
        if not parent.isValid():
            parentNode = self._rootNode
        else:
            parentNode = parent.internalPointer()

        return parentNode.childCount()

    def columnCount(self, parent):
        return 1
    
    def data(self, index, role):
        
        if not index.isValid():
            return None

        node = index.internalPointer()

        if role == QtCore.Qt.DisplayRole or role == QtCore.Qt.EditRole:
            if index.column() == 0:
                return node.name()

    def setData(self, index, value, role=QtCore.Qt.EditRole):

        if index.isValid():
            
            if role == QtCore.Qt.EditRole:
                
                node = index.internalPointer()
                node.setName(value)
                
                return True
        return False

    def headerData(self, section, orientation, role):
        if role == QtCore.Qt.DisplayRole:
            if section == 0:
                return "Tablas"

    def flags(self, index):
        return QtCore.Qt.ItemIsEnabled | QtCore.Qt.ItemIsSelectable

    def parent(self, index):
        
        node = self.getNode(index)
        parentNode = node.parent()
        
        if parentNode == self._rootNode:
            return QtCore.QModelIndex()
        
        return self.createIndex(parentNode.row(), 0, parentNode)
        
    def index(self, row, column, parent):
        
        parentNode = self.getNode(parent)

        childItem = parentNode.child(row)


        if childItem:
            return self.createIndex(row, column, childItem)
        else:
            return QtCore.QModelIndex()

    def getNode(self, index):
        if index.isValid():
            node = index.internalPointer()
            if node:
                return node
            
        return self._rootNode

    def insertRows(self, position, rows, parent=QtCore.QModelIndex(), name="Sin título"):
        
        parentNode = self.getNode(parent)
        
        self.beginInsertRows(parent, position, position + rows - 1)
        
        for row in range(rows):
            
            childCount = parentNode.childCount()
            childNode = Node(name)
            success = parentNode.insertChild(position, childNode)
        
        self.endInsertRows()

        return success

    def removeRows(self, position, rows, parent=QtCore.QModelIndex()):
        
        parentNode = self.getNode(parent)
        self.beginRemoveRows(parent, position, position + rows - 1)
        
        for row in range(rows):
            success = parentNode.removeChild(position)
            
        self.endRemoveRows()
        
        return success



# En vez de mostrar un 0 o un 1 en la columna Telegram, muestra una casilla desmarcada o marcada respectivamente.

class CheckboxDelegate(QItemDelegate):

    def __init__(self):

        QItemDelegate.__init__(self)

    def createEditor(self, parent, option, index):
        return None
    
    def paint(self, painter, option, index):
        self.drawCheck(painter, option, option.rect, QtCore.Qt.Unchecked if int(index.data()) == 0 else QtCore.Qt.Checked)

    def editorEvent(self, event, model, option, index):
        if not int(index.flags() & QtCore.Qt.ItemIsEditable) > 0:
            return False

        if event.type() == QtCore.QEvent.MouseButtonRelease and event.button() == QtCore.Qt.LeftButton:
            self.setModelData(None, model, index)
            return True

        return False

    def setModelData (self, editor, model, index):
        model.setData(index, 1 if int(index.data()) == 0 else 0, QtCore.Qt.EditRole)



# Aquí se gestionan todas las interacciones del usuario con la pantalla del censo.

class CensoBackend(QObject):

    def __init__(self):
        QObject.__init__(self)

    def openDatabase(self, year):
        self.connection.setDatabaseName("defc" + os.path.sep + "data" + os.path.sep + "censo" + os.path.sep + f"{year}.sqlite") # Cargamos la base de datos.
        if not self.connection.open(): # Si no se puede abrir, da error.
            QMessageBox.warning(
                None,
                "Censo - Delegación de Estudiantes de la Facultad de Ciencias",
                f"Database Error: {self.connection.lastError().text()}",
                buttons=QMessageBox.Ok
            )



    def createDefaultTables(self):
        createTableQuery = QSqlQuery(self.connection)

        dbTables = self.connection.tables()
        defaultTables = ["Pleno", "Miembros", "Delegados"]
        for table in [item for item in defaultTables if item not in dbTables]:
            if not createTableQuery.exec( # Creamos las tablas principales si no existen. Esto es provisional.
                f"""
                CREATE TABLE IF NOT EXISTS '{table}' (
                    ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
                    DNI VARCHAR(9),
                    Nombre VARCHAR(40),
                    Apellidos VARCHAR(80),
                    Correo_UGR VARCHAR(50),
                    Telegram INTEGER DEFAULT 0
                )
                """
            ):
                QMessageBox.warning(
                    None,
                    "Censo - Delegación de Estudiantes de la Facultad de Ciencias",
                    f"Database Error: {createTableQuery.lastError().text()}",
                    buttons=QMessageBox.Ok
                )
            try:
                self.internal.data[ self.connection.databaseName().split(os.path.sep)[-1].replace(".sqlite", "") ]["Tablas"][table] = []
                self.internal.save()
            except:
                QMessageBox.critical(
                    None,
                    "Censo - Delegación de Estudiantes de la Facultad de Ciencias",
                    "Objeto de año incompleto. Puede que el archivo defc/data/censo/censo.json esté dañado. Se recomienda borrar la base de datos.",
                    buttons=QMessageBox.Ok
                )
                main.app.exit(-1)



    def loadModel(self, table):
        if main.censoMainWindow: # Cuando se llame a esta función después de haber creado la ventana del censo, oculta la tabla y la muestra una vez se haya cambiado la tabla.
            main.censoMainWindow.table.hide()

        self.model.setTable(table) # Cargamos la tabla del Pleno.
        self.model.setEditStrategy(QSqlRelationalTableModel.OnManualSubmit) # Los cambios hechos no se guardan en la base de datos a no ser que lo indiquemos manualmente.
        self.model.select() # El modelo carga la tabla.

        headers = []

        headersQuery = QSqlQuery( # Obtenemos las cabeceras de la tabla.
            f"""
            PRAGMA TABLE_INFO('{table}')
            """,
            self.connection
            )
        while headersQuery.next():
            headers.append(headersQuery.value(1).replace("_", " ")) # Reemplazamos _ por espacios.
        if headersQuery.lastError().isValid():
            QMessageBox.warning(
                None,
                "Censo - Delegación de Estudiantes de la Facultad de Ciencias",
                f"Database Error: {headersQuery.lastError().text()}",
                buttons=QMessageBox.Ok
            )

        for columnIndex, header in enumerate(headers): # Aplicamos las cabeceras al modelo.
            self.model.setHeaderData(columnIndex, Qt.Horizontal, header)

        if main.censoMainWindow:
            main.censoMainWindow.table.show()



    def changeDB(self, index): # Esta función es llamada cuando hacemos doble click en el nombre de una tabla en la barra lateral.
        item = index.model().getNode(index)
        if item.parent() and item.parent().name() != "Tablas": # Si el objeto en el que hemos hecho doble click no es ni la raíz ni una cabecera de curso, continuamos.
            if self.model.isDirty():
                warn = QMessageBox.warning(
                    None, 
                    "Censo - Delegación de Estudiantes de la Facultad de Ciencias",
                    "Hay cambios sin guardar, ¿guardar la tabla?",
                    buttons=QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel
                )

                if warn == QMessageBox.Yes:
                    self.model.submitAll()
                elif warn == QMessageBox.Cancel:
                    return False
                    
            if item.parent().name().replace("Curso ", "").split("-")[0] == self.connection.databaseName().split(os.path.sep)[-1].replace(".sqlite", ""): # Si el click es en el mismo curso, solo cambiamos la tabla.
                self.loadModel(item.name())
            else: # Si el click es en otro curso, cambiamos la base de datos y la tabla.
                self.openDatabase(item.parent().name().replace("Curso ", "").split("-")[0])
                self.loadModel(item.name())
            return True



    def loadUI(self):
        self.internal = Internal()
        self.connection = QSqlDatabase.addDatabase("QSQLITE", connectionName="qt_sql_censo") # Creamos la conexión y le damos un nombre.
        self.openDatabase(self.internal.year)
        self.createDefaultTables()
        self.model = QSqlRelationalTableModel(db = self.connection) # Creamos el modelo indicando la base de datos.
        self.loadModel("Pleno")
        rootNode = Node("Tablas")

        for year in reversed(list(self.internal.data.keys())): # Aquí se le dan los cursos y las tablas a mostrar (como nodos) al modelo de la vista jerárquica.
            yearNode = Node("Curso " + self.internal.data[year]["Curso"], rootNode)
            for table in self.internal.data[year]["Tablas"].keys():
                tableNode = Node(table, yearNode)
        self.drawerModel = DrawerModel(rootNode)

        self.delegate = CheckboxDelegate()

        main.censoMainWindow = Window()
        main.censoMainWindow.showMaximized()