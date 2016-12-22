import QtQuick 2.8
import QtMultimedia 5.8

import "./"

//--------------------------------------------------------------------------
// Основной файл. Начало игры происходит после скрытия StartScreen
//--------------------------------------------------------------------------
Item {
    id: root

    readonly property var colors: ["#85E881", "#FFD129", "#E84281", "#348BFF"]
    readonly property real columnWidth: 0.25*root.width
    readonly property bool active: Qt.application.state !== Qt.ApplicationSuspended
    property bool isGameOver: false
    property bool isStartScreen: true

    signal pauseGame()
    signal resumeGame()

    width : Window.width
    height: Window.height

    //--------------------------------------------------------------------------
    // Игровое поле, добавляющие капли
    //--------------------------------------------------------------------------
    Field {
        id: field
    }

    //--------------------------------------------------------------------------
    // Платформа с цветами
    //--------------------------------------------------------------------------
    ColorPlatform {
        id: colorPlatform
    }

    //--------------------------------------------------------------------------
    // Разделитель между кнопками и панелью с цветом
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
    //  Панель цвета
    //--------------------------------------------------------------------------
    ControlPanel {
        id: controlPanel
    }

    //--------------------------------------------------------------------------
    // Попап GameOver
    //--------------------------------------------------------------------------
    GameOverPopup {
        id: gameOverPopup
    }

    //--------------------------------------------------------------------------
    // Стартовый экран
    //--------------------------------------------------------------------------
    StartScreen {
        id: startScreen

        onHide: {
            root.isStartScreen = false;
            field.newGame();
        }
    }

    //--------------------------------------------------------------------------
    // Кнопка паузы
    //--------------------------------------------------------------------------
    PauseButton {
        id: pauseButton
    }

    //--------------------------------------------------------------------------
    // Фоновая музыка
    //--------------------------------------------------------------------------
    Audio {
        id: music

        loops: Audio.Infinite
        source: "qrc:/audio/rainbows.ogg"
        volume: 0.15

        Component.onCompleted: {
            play();
        }
    } // Audio { id: music

    //--------------------------------------------------------------------------
    // Обработка изменения состояния приложения. (Свёрнуто-Развёрнуто)
    //--------------------------------------------------------------------------
    onActiveChanged: {
        if (active) {
            music.play()
        } else {
            music.pause()
            if (!root.isGameOver && !root.isStartScreen) {
                pauseGame()
                pauseButton.visible = true
            }
        }
    } // onActiveChanged: {
}
