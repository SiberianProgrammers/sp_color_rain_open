import QtQuick 2.8
import SP 1.0
import "./"
import "qrc:/SpQml"

Row {
    id: _controlPanel
    
    anchors.bottom: parent.bottom
    height: 2*Consts.ruh

    Repeater {
        model: ListModel {
            id: colorModel

            ListElement { colorIndex: 0 }
            ListElement { colorIndex: 1 }
            ListElement { colorIndex: 2 }
            ListElement { colorIndex: 3 }
        }

        Rectangle {
            color: colors[model.colorIndex]
            width: columnWidth
            height: _controlPanel.height

            Rectangle {
                id: shadow

                color: "black"
                anchors.fill: parent
                opacity: 0.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }
            }

            MultiPointTouchArea {
                anchors {
                    fill: parent
                    topMargin: -colorPlatform.height
                }
                onPressed: {
                    shadow.opacity = 0.2
                    colorPlatform.push(model.colorIndex);
                }
                onReleased: {
                    shadow.opacity = 0.0
                }
            } // MouseArea {
        } // Rectangle {
    } // Repeater {
}
