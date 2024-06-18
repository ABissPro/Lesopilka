import QtQuick 2.0
import Sailfish.Silica 1.0

//import "src\dbmanager.cpp"

Rectangle {
    id: field
    width: flickable.contentWidth
    height: flickable.contentHeight
    color: "grey"
    anchors.fill: parent
    dbmanager: dbmanager
    visible: dbInitialized

    // Область для перемещения поля и создания кругов
    MouseArea {
        id: dragArea
        anchors.fill: parent
        onClicked: {
            createCircle(mouse.x, mouse.y);
        }
    }


Flickable {
    id: flickable
    width: parent.width
    height: parent.height
    contentWidth: 10000
    contentHeight: 10000
    clip: true

    property var circles: []
    property alias dbManager: dbManager



    // Функция для создания круга на заданных координатах
    function createCircle(x, y) {
        var component = Qt.createComponent("Menu.qml");
        if (component.status === Component.Ready) {
            var circle = component.createObject(map, {"x": x - 25, "y": y - 25, "dbManager": dbManager});
            circles.push(circle);
        } else {
            console.log("Ошибка загрузки компонента Menu.qml");
        }
    }

    // Функция для создания круга на текущей позиции
    function createCircleAtLocation() {
        var x = myMarker.x + myMarker.width / 2;
        var y = myMarker.y + myMarker.height / 2;
        createCircle(x, y);
    }
}
}
