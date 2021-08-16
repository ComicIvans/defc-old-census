import QtQuick 6
import QtQuick.Controls 6
import QtQuick.Controls.Universal 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

ApplicationWindow { // Las cosas de aquí que se repitan de la pantalla de inicio seguramente no las comente.
    id: mainWindow
    objectName: "censoMainWindow"
    
    property var fontSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
    property string accentColor: "#3E65FF"
    property string backgroundColor: "#000000"
    property string foregroundColor: "#ffffff"

    visible: true
    Universal.theme: Universal.Dark
    Universal.accent: accentColor
    Universal.background: backgroundColor
    Universal.foreground: foregroundColor
    minimumHeight: 450
    minimumWidth: 800
    title: qsTr("Censo - Delegación de Estudiantes de la Facultad de Ciencias")

    menuBar: MenuBar { // Esta es la barra superior que tiene los botoncillos.
        id: menu

        Menu {
            title: "Acción"
            Action { text: qsTr("Importar") }
            MenuSeparator{}
            Action { text: qsTr("Exportar") }
        }

        Menu {
            title: "Opciones"
        }
    }

    header: ToolBar {
        id: toolBar

        RowLayout {
            x: drawer.width
            spacing: 1
            ToolButton {
                height: toolBar.height
                font.pixelSize: height/2
                text: qsTr("‹")
            }
            Label {
                text: menu.height + "-" + toolBar.height
                height: toolBar.height
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                height: toolBar.height
                font.pixelSize: height/2
                text: qsTr("⋮")
            }
        }
    }

    Drawer { // Esta es la barra lateral que tiene las distintas tablas del censo.
        id: drawer

        visible: true
        y: menu.height // Comienza donde acaba el menu.
        height: mainWindow.height - menu.height
        width: 200 + mainWindow.width/100
        interactive: false // La barra no se puede arrastrar.
        position: 1 // Aparece totalmente abierta.
        clip: true // Cuando arrastras la cabecera no se pone por encima del menu.

        ListView {
            id: drawerList

            anchors.fill: parent
            headerPositioning: ListView.InlineHeader // El título está fijo como el primero de los elementos de la lista.
            keyNavigationEnabled: true // Se puede usar el teclado para navegar por la lista.
            header: Rectangle {
                id: drawerHeader

                width: drawer.width - 1
                height: 40 + drawer.height/100
                color: "#80000000" // Negro con 50% de transparencia.

                Row {
                    anchors.fill: parent
                    spacing: 10
                    leftPadding: 10

                    Image {
                        id: drawerLogo

                        source: "../resources/img/defc_wicon.svg"
                        mipmap: true
                        height: 0.9*parent.height
                        width: 0.9*parent.height
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: drawerTitle

                        text: qsTr("Tablas:")
                        font.pixelSize: parent.height/2
                        height: parent.height
                        width: parent.width/2
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Roboto Slab"
                    }
                }
            }

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }
        }
    }

    TableView {
        id: content

        x: drawer.width
        y: menu.height + toolBar.height
        width: mainWindow.width - drawer.width
        height: mainWindow.height - (menu.height + toolBar.height)
        columnSpacing: 1
        rowSpacing: 1
        clip: true

        model: tableModel

        Label {
            id: tableHeader

            x: parent.width/2 + this.width
            text: "A table header"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Connections {
        target: censoBackend
    }
}