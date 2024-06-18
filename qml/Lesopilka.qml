import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages/Field.qml" as Field
import "pages/Menu.qml"
import "pages/Location.qml"

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    visible: true

    property bool dbInitialized: false
    property int actionIndex: 0

    // Менеджер базы данных
    QtObject {
        id: dbManager
        function initializeDatabase(dbName) {
            dbManagerCpp.initializeDatabase(dbName);
        }

        function createNewDatabase(dbName) {
            dbManagerCpp.createNewDatabase(dbName);
        }

        function loadExistingDatabase(dbName) {
            dbManagerCpp.loadExistingDatabase(dbName);
        }

        function saveDiameterAndHeight(diameter, height) {
            dbManagerCpp.saveDiameterAndHeight(diameter, height);
        }

        function saveBreed(breed) {
            dbManagerCpp.saveBreed(breed);
        }
    }

    // Диалог для выбора действия с базой данных
    Rectangle {
        id: dbDialog
        width: parent.width * 0.8
        height: parent.height * 0.6
        color: "white"
        border.color: "black"
        border.width: 2
        radius: 10
        anchors.centerIn: parent
        visible: !dbInitialized

        Column {
            spacing: 10
            anchors.centerIn: parent

            Text {
                text: "Выберите действие"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            ListView {
                width: parent.width
                height: 100
                model: ["Создать новую базу данных", "Использовать существующую базу данных"]
                delegate: Item {
                    width: parent.width
                    height: 50

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: ListView.isCurrentItem ? "lightgrey" : "white"
                        border.color: "black"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                actionIndex = index;
                                console.log("Selected action:", modelData);
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: 16
                            }
                        }
                    }
                }
            }

            TextField {
                id: newDatabaseName
                visible: actionIndex === 0
                placeholderText: "Введите имя новой базы данных"
            }

            TextField {
                id: existingDatabaseName
                visible: actionIndex === 1
                placeholderText: "Введите имя существующей базы данных"
            }

            Row {
                spacing: 10
                Button {
                    text: "ОК"
                    onClicked: {
                        if (actionIndex === 0) {
                            var newDbName = newDatabaseName.text;
                            dbManager.createNewDatabase(newDbName);
                            dbInitialized = true;
                            dbDialog.visible = false;
                        } else if (actionIndex === 1) {
                            var existingDbName = existingDatabaseName.text;
                            dbManager.loadExistingDatabase(existingDbName);
                            dbInitialized = true;
                            dbDialog.visible = false;
                        }
                    }
                }

                Button {
                    text: "Отмена"
                    onClicked: {
                        Qt.quit();
                    }
                }
            }
        }
    }

    // Подключаем компонент поля
    Rectangle {
        id: field
        anchors.fill: parent
        dbManager: dbManager
        visible: dbInitialized
    }

    // Кнопка для добавления круга
    Button {
        text: "Добавить дерево на текущей позиции"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            field.createCircleAtLocation();
        }
        visible: dbInitialized
    }

    // Кнопка для выбора базы данных
    Button {
        text: "Выбрать базу данных"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: {
            dbDialog.visible = true;
        }
        visible: dbInitialized
    }
}
