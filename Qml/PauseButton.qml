import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Кнопка паузы
//--------------------------------------------------------------------------
Rectangle {
    id: _pauseButton

    visible: false
    anchors.centerIn: parent
    width: 1.8*Consts.ruh
    height: width
    radius: 0.2*height
    color: "#8d5fd3"

    //--------------------------------------------------------------------------
    Row {
        anchors.centerIn: parent
        spacing: 0.2*_pauseButton.width

        Rectangle {
            height: Consts.ruh
            width: 0.15*_pauseButton.width
        }

        Rectangle {
            height: Consts.ruh
            width: 0.15*_pauseButton.width
        }
    } // Row {

    //--------------------------------------------------------------------------
    MouseArea {
        anchors.fill: parent
        enabled: _pauseButton.visible
        onClicked: {
            _pauseButton.visible = false;
            resumeGame();
        }
    }// MouseArea {
}
