import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: heightInputPage

    signal accepted(real height)

    property real height: 0

    PageHeader {
        title: qsTr("Введите высоту")
    }

    SilicaFlickable {
        anchors.fill: parent
        Column {
            spacing: 10
            TextField {
                id: inputHeight
                placeholderText: qsTr("Введите высоту")
                onTextChanged:{
                    var newHeight = parseFloat(inputHeight.text)
                    if (!isNaN(newHeight)) {
                        height = newHeight
                    }
                }
            }
            Button {
                text: qsTr("Сохранить")
                onClicked: {
                    accepted(height)
                    pageStack.pop()
                }
            }
        }
    }
}
