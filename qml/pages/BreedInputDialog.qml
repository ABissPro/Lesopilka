import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: breedInputPage

    signal accepted(string breed)

    property string breed: ""

    PageHeader {
        title: qsTr("Выберите породу")
    }

    SilicaFlickable {
        anchors.fill: parent
        Column {
            spacing: 10
            ListView {
                id: comboBreed
                model: ListModel {
                    ListElement { text: "Осина" }
                    ListElement { text: "Береза" }
                    ListElement { text: "Дуб" }
                }
                onCurrentIndexChanged: breed = comboBreed.currentText
            }
            Button {
                text: qsTr("Сохранить")
                onClicked: {
                    accepted(breed)
                    pageStack.pop()
                }
            }
        }
    }
}
