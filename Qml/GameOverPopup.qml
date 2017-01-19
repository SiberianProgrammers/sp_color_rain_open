import QtQuick 2.8
import SP 1.0
import "./"
import "qrc:/SpQml"

Item {
    id: _gameOverPopup

    width: Math.max(textItem.width, scoreItem.width) + 2*Consts.marginBig
    height: column.height + 2*Consts.marginBig
    anchors.centerIn: parent

    //--------------------------------------------------------------------------
    Rectangle {
        id: fade

        anchors.centerIn: parent
        width: root.width
        height: root.height
        color: "#444444"
        opacity: 0.8
    }

    //--------------------------------------------------------------------------
    Rectangle {
        id: background

        anchors.fill: parent
        radius: Consts.marginBig
    }

    //--------------------------------------------------------------------------
    MouseArea {
        id: dummyMouseArea

        anchors.centerIn: parent
        width: root.width
        height:  root.height
        onClicked: { }
    }

    //--------------------------------------------------------------------------
    Column {
        id: column

        spacing: 2*Consts.margin
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Text {
            id: textItem

            text: "Game Over!"
            anchors.horizontalCenter: parent.horizontalCenter
            color: Consts.darkGray
            font {
                pixelSize: 1*Consts.ruh
                bold: true
            }
        }

        Text {
            id: scoreItem

            text: qsTr("Score: %1\nMax Score: %2").arg(field.score).arg(field.maxScore)
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            color: Consts.gray
            font {
                pixelSize: 1*Consts.ruh
                bold: true
            }
        }

        Rectangle {
            id: button

            width: buttonText.width + 2*radius
            height: buttonText.height + 0.2*Consts.ruh
            radius: 0.5*height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "orange"

            Text {
                id: buttonText
                text: "RESTART"
                anchors.centerIn: parent
                color: "white"
                font {
                    pixelSize: 1*Consts.ruh
                    bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    hide();
                    field.startGame();
                }
            }
        } // Rectangle { id: button
    } // Column {

    //--------------------------------------------------------------------------
    Item {
        id: statesItem

        state: "hidden"
        states: [
            State {
                name: "hidden"
                PropertyChanges {
                    target: _gameOverPopup
                    visible: false
                }
            }
            ,State {
                name: "visible"
                PropertyChanges {
                    target: _gameOverPopup
                    visible: true
                }
            }
        ]
    }

    //--------------------------------------------------------------------------
    function hide() {
        statesItem.state = "hidden";
    }

    //--------------------------------------------------------------------------
    function show() {
        statesItem.state = "visible";
    }
}
