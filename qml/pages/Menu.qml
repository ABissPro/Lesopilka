import QtQuick 2.2
import Sailfish.Silica 1.0

ApplicationWindow {
    id: appWindow

    initialPage: Component {
        Page {
            id: mainPage
            allowedOrientations: Orientation.All
            anchors.fill: parent

            PageHeader {
                id: header
                title: "Порода и размеры дерева"
            }

            Button {
                text: "Открыть меню"
                anchors {
                    top: header.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                onClicked: {
                    contextMenu.open()
                }
            }

            Rectangle {
                id: circle
                width: 50
                height: 50
                radius: 25
                color: "white"

                property real originalDiameter: 50
                property real originalHeight: 50
                property string breed: "Осина"
                property alias dbManager: dbManager

                function resize(diameterPercentage) {
                    var newDiameter = originalDiameter + (originalDiameter * diameterPercentage / 100);
                    width = newDiameter;
                    height = newDiameter;
                    radius = newDiameter / 2;
                    dbManager.saveDiameterAndHeight(width, height);
                }

                function setBreed(newBreed) {
                    breed = newBreed;
                    switch (newBreed) {
                        case "Осина":
                            color = "lightgreen";
                            break;
                        case "Береза":
                            color = "blue";
                            break;
                        case "Дуб":
                            color = "grey";
                            break;
                        case "Сосна":
                            color = "orange";
                            break;
                        case "Ель":
                            color = "purple";
                            break;
                        case "Лиственница":
                            color = "green";
                            break;
                    }
                    dbManager.saveBreed(newBreed);
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                }
            }

            ContextMenu {
                id: contextMenu
                MenuItem {
                    text: "Порода"
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("BreedInputDialog.qml"),
                                                    {"breed": circle.breed})
                        dialog.accepted.connect(function() {
                            circle.setBreed(dialog.breed)
                        })
                    }
                }
                MenuItem {
                    text: "Диаметр"
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("DiameterInputDialog.qml"),
                                                    {"diameter": circle.width})
                        dialog.accepted.connect(function() {
                            circle.resize(dialog.diameter)
                            dbManager.saveDiameterAndHeight(dialog.diameter, circle.height)
                        })
                    }
                }
                MenuItem {
                    text: "Высота"
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("HeightInputDialog.qml"),
                                                    {"height": circle.height})
                        dialog.accepted.connect(function() {
                            dbManager.saveDiameterAndHeight(circle.width, dialog.height)
                        })
                    }
                }
            }
        }
    }
}
