import QtQuick 2.8
import SP 1.0
import QtMultimedia 5.8

import "./"
import "qrc:/SpQml"

Item {
    id: root

    readonly property var colors: ["#85E881", "#FFD129", "#E84281", "#348BFF"]
    readonly property real columnWidth: 0.25*root.width
    readonly property bool active: Qt.application.state !== Qt.ApplicationSuspended
    property bool isGameOver: false
    property bool isStartScreen: true

    signal pauseGame()
    signal resumeGame()

    width: Window.width
    height: Window.height

    //--------------------------------------------------------------------------
    Field {
        id: field
    }

    //--------------------------------------------------------------------------
    ColorPlatform {
        id: colorPlatform
    }

    //--------------------------------------------------------------------------
    Rectangle {
        height: 0.2*Consts.ruh
        color: "black"
        anchors {
            left: parent.left
            right: parent.right
            bottom: controlPanel.top
        }
    }

    //--------------------------------------------------------------------------
    ControlPanel {
        id: controlPanel
    }

    //--------------------------------------------------------------------------
    GameOverPopup {
        id: gameOverPopup
    }

    //--------------------------------------------------------------------------
    StartScreen {
        id: startScreen

        onHide: {
            field.startGame();
            root.isStartScreen = false;
        }
    }

    //--------------------------------------------------------------------------
    PauseButton {
        id: pauseButton
    }

    //--------------------------------------------------------------------------
    Audio {
        id: music

        loops: Audio.Infinite
        source: "qrc:/audio/rainbows.ogg"
        volume: 0.15

        Component.onCompleted: {
            play();
        }
    }

    //--------------------------------------------------------------------------
    onActiveChanged: {
        if (active) {
            music.play()
            //if (!root.isGameOver) {
            //    resumeGame()
            //}
        } else {
            music.pause()
            if (!root.isGameOver && !root.isStartScreen) {
                pauseGame()
                pauseButton.visible = true
            }
        }
    }
}
