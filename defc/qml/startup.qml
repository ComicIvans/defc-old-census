import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "controls"

Window {
    id: mainWindow
    width: 1000
    height: 580
    visible: true
    minimumHeight: 450
    minimumWidth: 800
    color: "#00000000"
    title: qsTr("Delegación de Estudiantes de la Facultad de Ciencias")
    flags: Qt.Window | Qt.FramelessWindowHint // Quitar la barra del título.constructor

    // Propiedades personalizadas.
    property int windowStatus: 0
    property int windowMargin: 10
    
    // Funciones internas.
    QtObject{
        id: internal

        function resetResizeBorders(){
            // Resize visibility
            resizeLeft.visible = true
            resizeRight.visible = true
            resizeBottom.visible = true
            resizeWindow.visible = true
        }

        function maximizeRestore(){
            if(windowStatus == 0){
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                // Resize visibility
                resizeLeft.visible = false
                resizeRight.visible = false
                resizeBottom.visible = false
                resizeWindow.visible = false
                btnFullscreen.iconSource = "../resources/img/fullscreen_exit_icon.svg"
            }
            else{
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                btnFullscreen.iconSource = "../resources/img/fullscreen_icon.svg"
            }
        }

        function ifMaximizedWindowRestore(){
            if(windowStatus == 1){
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                btnFullscreen.iconSource = "../resources/img/fullscreen_icon.svg"
            }
        }

        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            // Resize visibility
            internal.resetResizeBorders()
            btnFullscreen.iconSource = "../resources/img/fullscreen_icon.svg"
        }
    }

    Rectangle {
        id: bg
        color: "#244c5a"
        border.color: "#1c1d20"
        border.width: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin

        Rectangle {
            id: appContainer
            color: "#00000000"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            Rectangle {
                id: topBar
                height: 30+0.01*mainWindow.height
                color: "#1c1d20"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Rectangle {
                    id: titleBar
                    height: 35
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 105
                    anchors.leftMargin: 0
                    anchors.topMargin: 0.5*parent.height - height/2

                    DragHandler {
                        onActiveChanged: if(active){
                                             mainWindow.startSystemMove()
                                             internal.ifMaximizedWindowRestore()
                                         }
                    }

                    Image {
                        id: iconApp
                        width: 32
                        height: 32
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "../resources/img/defc_white_icon.svg"
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 10
                        anchors.topMargin: 0
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: textTitle
                        color: "#c3cbdd"
                        text: qsTr("Delegación de Estudiantes de la Facultad de Ciencias")
                        anchors.left: iconApp.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Roboto"
                        font.pixelSize: 12 + 5*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
                        anchors.leftMargin: 10
                    }
                }

                Row {
                    id: rowBtns
                    x: 872
                    width: 105
                    height: parent.height
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0

                    TopBarButton{
                        id: btnMinimize
                        anchors.right: btnFullscreen.left
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        height: parent.height
                        width: height
                        iconSource: "../resources/img/minimize_icon.svg" // Minimize Icon by Google Inc.
                        onClicked: {
                            mainWindow.showMinimized()
                            internal.restoreMargins()
                        }
                    }

                    TopBarButton {
                        id: btnFullscreen
                        anchors.right: btnClose.left
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        height: parent.height
                        width: height
                        iconSource: "../resources/img/fullscreen_icon.svg" // Fullscreen Icon by Google Inc.
                        onClicked: internal.maximizeRestore()
                    }

                    TopBarButton {
                        id: btnClose
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        height: parent.height
                        width: height
                        iconSource: "../resources/img/exit_icon.svg" // Close Icon by Google Inc.
                        colorPressed: "#ff007f"
                        onClicked: mainWindow.close()
                    }
                }
            }
        }

        Rectangle {
            id: content
            color: "#00000000"
            anchors.top: topBar.bottom
            anchors.fill: parent

            Text {
                id: textBienvenida
                width: 0.15*parent.width
                height: 0.12*parent.height
                color: "#3eb1c8"
                text: qsTr("Secretaría de la DEFC")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 0.5*parent.width - width/2
                anchors.topMargin: (1/6)*parent.height - height/2
                font.pixelSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
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
                anchors.leftMargin: 0

                Image {
                    id: imgDefc
                    width: 1000
                    height: 1000
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    source: "../resources/img/defc.svg"
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    scale: 0.8
                    fillMode: Image.PreserveAspectFit
                }
            }

            Column {
                id: colLeft
                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                anchors.top: textBienvenida.bottom
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0

                CustomButton {
                    id: btnCenso
                    text: qsTr("Censo")
                    width: 0.6*parent.width
                    height: 0.12*parent.height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0.5*parent.width - width/2
                    anchors.topMargin: (1/5)*parent.height - height/2
                    font.pixelSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
                }

                CustomButton {
                    id: btnAsistencia
                    text: qsTr("Asistencia")
                    width: 0.6*parent.width
                    height: 0.12*parent.height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0.5*parent.width - width/2
                    anchors.topMargin: (2/5)*parent.height - height/2
                    font.pixelSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
                }

                CustomButton {
                    id: btnRegistro
                    text: qsTr("Registro")
                    width: 0.6*parent.width
                    height: 0.12*parent.height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0.5*parent.width - width/2
                    anchors.topMargin: (3/5)*parent.height - height/2
                    font.pixelSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
                }

                CustomButton {
                    id: btnOtros
                    text: qsTr(" · · · ")
                    width: 0.6*parent.width
                    height: 0.12*parent.height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 0.5*parent.width - width/2
                    anchors.topMargin: (4/5)*parent.height - height/2
                    font.pixelSize: 25*(mainWindow.height + mainWindow.width)/(mainWindow.minimumHeight + mainWindow.minimumWidth) - 0.02*( mainWindow.width/mainWindow.height >= 16/9 ? mainWindow.width - 16/9*mainWindow.height : mainWindow.height - 9/16*mainWindow.width )
                }
            }

            MouseArea {
                id: resizeWindow
                x: 884
                y: 0
                width: 25
                height: 25
                opacity: 0.5
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                cursorShape: Qt.SizeFDiagCursor

                DragHandler{
                    target: null
                    onActiveChanged: if (active){
                                         mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                                     }
                }
                Image {
                    id: resizeImage
                    width: 16
                    height: 16
                    anchors.fill: parent
                    source: "../resources/img/resize_icon.svg"
                    anchors.leftMargin: 5
                    anchors.topMargin: 5
                    sourceSize.height: 16
                    sourceSize.width: 16
                    fillMode: Image.PreserveAspectFit
                    antialiasing: false
                }
            }
        }

       MouseArea {
           id: resizeLeft
           width: 10
           anchors.left: parent.left
           anchors.top: parent.top
           anchors.bottom: parent.bottom
           anchors.leftMargin: 0
           anchors.bottomMargin: 10
           anchors.topMargin: 10
           cursorShape: Qt.SizeHorCursor

           DragHandler{
               target: null
               onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.LeftEdge) }
           }
       }

       MouseArea {
           id: resizeRight
           width: 10
           anchors.right: parent.right
           anchors.top: parent.top
           anchors.bottom: parent.bottom
           anchors.rightMargin: 0
           anchors.bottomMargin: 10
           anchors.topMargin: 10
           cursorShape: Qt.SizeHorCursor

           DragHandler{
               target: null
               onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge) }
           }
       }

       MouseArea {
           id: resizeBottom
           height: 10
           anchors.left: parent.left
           anchors.right: parent.right
           anchors.bottom: parent.bottom
           anchors.rightMargin: 10
           anchors.leftMargin: 10
           anchors.bottomMargin: 0
           cursorShape: Qt.SizeVerCursor

           DragHandler{
               target: null
               onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.BottomEdge) }
           }
       }
    }
}

// Code from https://github.com/Wanderson-Magalhaes/QtQuick_Application_With_Python

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
