import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 1000
    height: 580
    visible: true
    title: qsTr("Delegación de Estudiantes de la Facultad de Ciencias")
    
    Rectangle {
        id: rectangle
        color: "#244c5a"
        anchors.fill: parent
        
        Image {
            id: image
            x: 450
            y: 240
            width: 100
            height: 100
            source: "qrc:/qtquickplugin/images/template_image.png"
            fillMode: Image.PreserveAspectFit
        }
    }
}