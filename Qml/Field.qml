import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Игровое поле. Генерирует капли в DropletGenerator
//--------------------------------------------------------------------------
Item {
    id: _field

    property int currentLevel: -1
    property int dropletsInFly

    property int lastDropletColorIndex: 1
    property int score: 0
    property int maxScore: Settings.get("maxScore", 0)
    property LevelCaption levelCaption

    readonly property bool levelCompleted: dropletsInFly === 0 && dropletGenerator.dropletsCapacity === 0

    signal killAllDroplets
    
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: colorPlatform.top
    }

    //--------------------------------------------------------------------------
    // Генератор капель
    //--------------------------------------------------------------------------
    DropletGenerator {
        id: dropletGenerator
    }

    //--------------------------------------------------------------------------
    Component {
        id: levelCaptionComponent

        LevelCaption { }
    }

    //--------------------------------------------------------------------------
    Component {
        id: dropletComponent

        Droplet { }
    }

    //--------------------------------------------------------------------------
    // Если уровень завершён, то переключаемся на новый
    //--------------------------------------------------------------------------
    onLevelCompletedChanged: {
        if (levelCompleted && currentLevel !== dropletGenerator.levels.length-1 && !root.isGameOver) {
            dropletGenerator.nextLevel();
        }
    }

    //--------------------------------------------------------------------------
    //0. Начало новой игры
    //--------------------------------------------------------------------------
    function newGame() {
        dropletGenerator.clearGame();

        // Выбираем 2 рандомных стартовых цвета для каждой новой игры
        var color1 = dropletGenerator.random(colors.length-1);
        do {
            var color2 = dropletGenerator.random(colors.length-1);
        } while(color1 === color2)

        dropletGenerator.levels[0].colorsIndexes = [color1, color2]

        dropletGenerator.nextLevel();
    }

    //--------------------------------------------------------------------------
    //1. Начинает новый уровень - Дальше всё происходит в dropletGenerator
    //--------------------------------------------------------------------------
    function startLevel(levelIndex) {
        dropletGenerator.startLevel(levelIndex);
    }

    //--------------------------------------------------------------------------
    // 5. Конец игры
    //--------------------------------------------------------------------------
    function gameOver() {
        root.isGameOver = true
        dropletGenerator.clearLevel();
        gameOverPopup.show();
    }
}
