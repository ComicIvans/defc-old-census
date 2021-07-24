import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    // Propiedades del botón.
    id: customBtn
    text: qsTr("text")
    implicitWidth: 200
    implicitHeight: 40
    font.bold: true
    font.family: "Roboto Slab"

    // Propiedades personalizadas.
    property color colorDefault: "#1c1d20"
    property color colorMouseOver: "#23272e"
    property color colorPressed: "#3eb1c8"

    QtObject {
        id: internal

        property var dynamicColor: if(customBtn.down){ // JavaScrip para cambiar el color dependiendo de si el botón está pulsado o el ratón está encima.
                                       customBtn.down ? colorPressed : colorDefault
                                   } else {
                                       customBtn.hovered ? colorMouseOver : colorDefault
                                   }
    }

    // Color de fondo y borde redondeado.
    background: Rectangle {
        color: internal.dynamicColor
        radius: 20
    }

    // Formato del texto del botón.
    contentItem: Item {
        Text {
            id: text_customBtn
            text: customBtn.text
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: customBtn.font.family
            font.bold: customBtn.font.bold
            font.pixelSize: customBtn.font.pixelSize
            color: "#ffffff"
        }
    }
}

// Code from https://github.com/Wanderson-Magalhaes/QtQuick_Application_With_Python
