import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.3

Item {
    id: root
    property bool isRunning: false
    property alias field: field

    ListModel {
        id: gpsTrackModel
    }

    ListElement {
        latitude: 0.0
        longitude: 0.0
    }

    property var previous: QtPositioning.coordinate(0, 0)

    PositionSource {
        id: src
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        onPositionChanged: {
            if (position.isValid) {
                myMarker.position = position.coordinate
            }

            if (!isRunning) {
                return;
            }

            var current = src.position.coordinate;
            field.currentLocation = current;

            if (previous.isValid
                    && current.isValid
                    && current.distanceTo(previous) > 10) {
                gpsTrackModel.append({latitude: current.latitude, longitude: current.longitude});
                previous = QtPositioning.coordinate(current.latitude, current.longitude);
            } else if (!previous.isValid && current.isValid) {
                gpsTrackModel.append({latitude: current.latitude, longitude: current.longitude});
                previous = QtPositioning.coordinate(current.latitude, current.longitude);
            }
        }
    }

    Component {
        id: myMarkerComponent
        Rectangle {
            id: myMarker
            width: 10
            height: 10
            color: "red"

            property real latitude
            property real longitude

            property var position: QtPositioning.coordinate(latitude, longitude)
        }
    }

    MapItemView {
        model: gpsTrackModel
        delegate: myMarkerComponent.createObject(root, {
            latitude: model.latitude,
            longitude: model.longitude
        })
    }
}
