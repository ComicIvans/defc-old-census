import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal

ApplicationWindow {
    id:mainWindow

    property var fontSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )

    visible: true
    Universal.theme: Universal.Dark
    width: 1000
    height: 580
    minimumHeight: 450
    minimumWidth: 800

    Rectangle {
        id: content
        anchors.fill: parent
        color: "#00000000"

        Text {
            id: textBienvenida
            width: 0.15*parent.width
            height: 0.12*parent.height
            color: "#3eb1c8"
            text: qsTr("Secretaría de la DEFC")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0.5*parent.width - width/2
            anchors.topMargin: 0.07*parent.height
            font.pixelSize: 1.5*fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: false
            font.family: "Roboto Slab"
        }

        Column {
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
                width: 0.7*parent.width
                height: 0.7*parent.height
                source: "../resources/img/defc.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Column {
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
                anchors.leftMargin: 0.5*parent.width - width/2
                font.pixelSize: fontSize
            }

            Button {
                id: btnAsistencia
                text: qsTr("Asistencia")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: 0.5*parent.width - width/2
                font.pixelSize: fontSize
            }

            Button {
                id: btnRegistro
                text: qsTr("Registro")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: 0.5*parent.width - width/2
                font.pixelSize: fontSize
            }

            Button {
                id: btnOtros
                text: qsTr(" · · · ")
                width: 0.6*parent.width
                height: 0.12*parent.height
                anchors.left: parent.left
                anchors.leftMargin: 0.5*parent.width - width/2
                font.pixelSize: fontSize
            }
        }
    }
}
