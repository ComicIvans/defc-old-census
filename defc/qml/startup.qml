import QtQuick 6
import QtQuick.Controls 6
import QtQuick.Controls.Universal 2.15

ApplicationWindow {
    id: mainWindow
    objectName: "startupMainWindow" // Este es el nombre para poder reconocer la ventana en el código de python.

    // El tamaño del texto calculado en función del tamaño de la ventana (sí, los números son productos son aleatorios pero funcionan).
    property var fontSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
    property string accentColor: "#3EB1C8" // Este la verdad es que todavía no lo he visto.
    property string backgroundColor: "#244C5A" // Color de fondo.
    property string foregroundColor: "#ffffff" // Color del texto y bordes.

    visible: true // Que la ventana sea visible.
    Universal.theme: Universal.Dark // Tema oscuro, por favor. Más abajo se ponen los colores declarados como propiedades antes.
    Universal.accent: accentColor
    Universal.background: backgroundColor
    Universal.foreground: foregroundColor
    width: 1000 // Anchura inicial.
    height: 580 // Altura final.
    minimumWidth: 800 // Anchura mínima.
    minimumHeight: 450 // Altura mínima.
    title: qsTr("Inicio - Delegación de Estudiantes de la Facultad de Ciencias")

    Rectangle {
        id: content
        
        anchors.fill: parent // Que ocupe toda la pantalla.
        color: "#00000000" // Transparente.

        Label { // La verad es que no se qué texto poner, pero lo dejo así por ahora.
            id: textBienvenida

            width: 0.15*parent.width
            height: 0.12*parent.height
            color: accentColor
            text: qsTr("Secretaría de la DEFC")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: parent.width/2 - this.width/2
            anchors.topMargin: 0.07*parent.height
            font.pixelSize: 1.5*fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: false
            font.family: "Roboto Slab"
        }

        Column { // La columna derecha que contendrá el logo de la DEFC.
            id: colRight

            anchors.left: parent.horizontalCenter
            anchors.right: parent.right
            anchors.top: textBienvenida.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: 0.7*textBienvenida.height
            topPadding: 0.04*parent.height
            leftPadding: 0.02*parent.width

            Image {
                id: imgDefc

                mipmap: true // Se ve mejor.
                width: 0.7*parent.width
                height: 0.7*parent.height
                source: "../resources/img/defc.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Column { // La columna izquierda que contendrá los botones.
            id: colLeft

            spacing: 0.08*mainWindow.height
            anchors.left: parent.left
            anchors.right: parent.horizontalCenter
            anchors.top: textBienvenida.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: 0.7*textBienvenida.height

            Button {
                id: btnCenso

                text: qsTr("Censo")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 - this.width/2
                font.pixelSize: fontSize

                onClicked: startupBackend.btnPushed("censo") // Cuando se pulsa, llama a la función btnPushed de startup.py para que cierre esta ventana y abra la del censo.
            }

            Button {
                id: btnAsistencia

                text: qsTr("Asistencia")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 - this.width/2
                font.pixelSize: fontSize

                onClicked: startupBackend.btnPushed("asistencia") // Cuando se pulsa, llama a la función btnPushed de startup.py para que cierre esta ventana y abra la de la asistencia.
            }

            Button {
                id: btnRegistro

                text: qsTr("Registro")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 - this.width/2
                font.pixelSize: fontSize

                onClicked: startupBackend.btnPushed("registro") // Cuando se pulsa, llama a la función btnPushed de startup.py para que cierre esta ventana y abra la del registro.
            }

            Button {
                id: btnOtros

                text: qsTr(" · · · ")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 - this.width/2
                font.pixelSize: fontSize

                onClicked: startupBackend.btnPushed("otros") // Cuando se pulsa, llama a la función btnPushed de startup.py para que cierre esta ventana y... todavía no se qué abrirá esto realmente XD.
            }
        }
    }

    Connections { // Conexión con el código de python. Para poder llamar a funciones al pulsar los botones.
        target: startupBackend
    }
}