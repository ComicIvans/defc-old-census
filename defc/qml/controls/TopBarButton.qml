import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button   {
    // Propiedades del botón.
    id: btnToggle
    implicitWidth: 35
    implicitHeight: 35

    // Propiedades personalizadas.
    property url iconSource: "icon.svg"
    property color colorDefault: "#1c1d20"
    property color colorMouseOver: "#23272e"
    property color colorPressed: "#3eb1c8"

    QtObject {
        id: internal

        property var dynamicColor: if(btnToggle.down){ // JavaScrip para cambiar el color dependiendo de si el botón está pulsado o el ratón está encima.
                                       btnToggle.down ? colorPressed : colorDefault
                                   } else {
                                       btnToggle.hovered ? colorMouseOver : colorDefault
                                   }
    }

    // Color del fondo.
    background: Rectangle {
        id: bg_BtnToggle
        color: internal.dynamicColor
        radius: 10

        Image {
            id: icon_BtnToggle
            source: iconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 32
            width: 32
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay {
            anchors.fill: icon_BtnToggle
            source: icon_BtnToggle
            color: "#ffffff"
            antialiasing: false
        }
    }
}

// Code from https://github.com/Wanderson-Magalhaes/QtQuick_Application_With_Python
