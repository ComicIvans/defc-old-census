import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button   {
    // Propiedades del botón.
    id: btnToggle
    implicitWidth: 70
    implicitHeight: 60

    // Propiedades personalizadas.
    property url iconSource: "../../resources/img/menu_icon.svg"
    property color colorDefault: "#1c1d20"
    property color colorMouseOver: "#23272e"
    property color colorPressed: "#00a1f1"

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

        Image {
            id: icon_BtnToggle
            source: iconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 25
            width: 25
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

// Menu Icon by Google Inc.
// Code from https://github.com/Wanderson-Magalhaes/QtQuick_Application_With_Python
