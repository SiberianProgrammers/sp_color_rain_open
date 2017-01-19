import QtQuick 2.8
import SP 1.0
import "./"
import "qrc:/SpQml"

Item {
    id: _field

    property var levels: [
        {
            dropInterval: 1350
            ,dropletsCapacity: 5
            ,fallingDuration: 3250
            ,doublePropability: 0
            ,sameDoubleDroplet: false
            ,colorsIndexes: [0,1]
            ,description: qsTr("Нажимайте на цвета снизу")
        }
        ,{
            dropInterval: 1500
            ,dropletsCapacity: 15
            ,fallingDuration: 3250
            ,doublePropability: 0
            ,sameDoubleDroplet: false
            ,colorsIndexes: [0,1,2,3]
            ,description: qsTr("Четыре цвета")
        }
        ,{
            dropInterval: 1750
            ,dropletsCapacity: 15
            ,fallingDuration: 3500
            ,doublePropability: 0.3
            ,sameDoubleDroplet: true
            ,colorsIndexes: [0,1,2,3]
            ,description: qsTr("Капли двойняшки")
        }
        ,{
            dropInterval: 1500
            ,dropletsCapacity: 15
            ,fallingDuration: 3750
            ,doublePropability: 0.15
            ,sameDoubleDroplet: false
            ,colorsIndexes: [0,1,2,3]
            ,description: qsTr("Разноцветные пары")
        }
        ,{
            dropInterval: 1200
            ,dropletsCapacity: 20
            ,fallingDuration: 3000
            ,doublePropability: 0.05
            ,sameDoubleDroplet: false
            ,colorsIndexes: [0,1,2,3]
            ,description: qsTr("Дождь ускоряется")
        }
        ,{
            dropInterval: 1000
            ,dropletsCapacity: 20
            ,fallingDuration: 2400
            ,doublePropability: 0.10
            ,sameDoubleDroplet: false
            ,colorsIndexes: [0,1,2,3]
            ,description: qsTr("И ещё быстрее")
        }
        ,{
            dropInterval: 800
            ,dropletsCapacity: 20
            ,fallingDuration: 2000
            ,doublePropability: 0.2
            ,sameDoubleDroplet: false
            ,colorsIndexes: [0,1,2,3]
            ,description: qsTr("Быстрый и сильный")
        }
    ]

    property bool debug: false
    property int currentLevel: -1
    property int dropletsCapacity: 20
    property int dropletsInFly
    property int fallingDuration
    property real doublePropability
    property bool sameDoubleDroplet
    property var colorsIndexes: ([])

    property int lastDropletColorIndex: 1
    property int score: 0
    property int maxScore: Settings.get("maxScore", 0)
    property var levelCaption
    property int doublePass: 0

    readonly property bool levelCompleted: dropletsInFly === 0 && dropletsCapacity === 0

    signal killAllDroplets

//    Rectangle {
//        width: Consts.borderWidth
//        height: parent.height
//        color: Consts.gray
//        opacity: 0.15
//        x: 0.25*parent.width - 0.5*width
//    }

//    Rectangle {
//        width: Consts.borderWidth
//        height: parent.height
//        color: Consts.gray
//        opacity: 0.15
//        x: 0.5*parent.width - 0.5*width
//    }

//    Rectangle {
//        width: Consts.borderWidth
//        height: parent.height
//        color: Consts.gray
//        opacity: 0.15
//        x: 0.75*parent.width - 0.5*width
//    }
    
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: colorPlatform.top
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
    // Таймер для падения одной капли
    //--------------------------------------------------------------------------
    Timer {
        id: generateTimer

        property int intervalBeforePause: 0

        // Не repeat, так как interval может поменяться
        //repeat: true
        //triggeredOnStart: true

        onTriggered: {
            if (interval != intervalBeforePause) {
                interval = intervalBeforePause
            }

            stopwatch.clear()
            start();
            generate();
        }
    }

    //--------------------------------------------------------------------------
    Connections {
        target: root

        onPauseGame: {
            stopwatch.stop();
            generateTimer.stop()
            generateTimer.interval = Math.max(generateTimer.interval - stopwatch.currentMs, 0);
            stopwatch.currentMs = 0;
            stopwatch.clear()
        }

        onResumeGame: {
            generateTimer.start()
            stopwatch.start()
        }
    }

    //--------------------------------------------------------------------------
    // Секундумер
    //--------------------------------------------------------------------------
    Timer {
        id: stopwatch

        property int currentMs: 0

        function clear() {
            stopwatch.currentMs = 0;
        }

        interval: 50
        repeat: true
        running: false

        onTriggered: {
            currentMs += 50;
        }
    }

    //--------------------------------------------------------------------------
    // Если уровень завершён, то переключаемся на новый
    //--------------------------------------------------------------------------
    onLevelCompletedChanged: {
        if (levelCompleted && currentLevel !== levels.length-1 && !root.isGameOver) {
            nextLevel();
        }
    }

    //--------------------------------------------------------------------------
    function random (max) {
      max = Math.floor(max);
      return Math.floor(Math.random() * (max + 1));
    }

    //--------------------------------------------------------------------------
    // Бросает одну каплю
    //--------------------------------------------------------------------------
    function drop(columnIndex, colorIndex, fallingDuration) {
        dropletComponent.createObject(_field, {
              columnIndex: columnIndex
              ,colorIndex: colorIndex
              ,fallingDuration: fallingDuration
          });

        if (dropletsCapacity > 0) {
            --dropletsCapacity;
        }
    }

    //--------------------------------------------------------------------------
    // Отложеннное создание капли. Пока убрал.
    //--------------------------------------------------------------------------
    Timer {
        id: delayDropSecond

        property int columnIndex: 0
        property int colorIndex: 0
        property int fallingDuration: 0

        interval: 90
        onTriggered: {
            delayDropSecond.interval = 75 + 100*Math.random()
            drop(delayDropSecond.columnIndex
                 , delayDropSecond.colorIndex
                 , delayDropSecond.fallingDuration);
        }
    }

    //--------------------------------------------------------------------------
    // Генерирует капли согласно параметрам уровня
    //--------------------------------------------------------------------------
    function generate() {
        if (dropletsCapacity || currentLevel === levels.length-1) {
            var columnIndex = random(3);
            var colorIndex = colorsIndexes[random(colorsIndexes.length-1)];
            drop(columnIndex
                 ,colorIndex
                 ,fallingDuration);

            // Запускаем вторую каплю, если нужно
            var p = Math.random()
            if (dropletsCapacity > 0 && doublePropability > p || doublePropability && doublePass > 1.5*1/doublePropability) {
                doublePass = 0;
                do {
                    var columnIndex2 = random(3);
                } while(columnIndex === columnIndex2)

                if (sameDoubleDroplet) {
                    var colorIndex2 = colorIndex;
                } else {
                    colorIndex2 = colorsIndexes[random(colorsIndexes.length-1)];
                }

                drop(columnIndex2
                     ,colorIndex2
                     ,fallingDuration);

               //delayDropSecond.columnIndex = columnIndex2
               //delayDropSecond.colorIndex = colorIndex2
               //delayDropSecond.fallingDuration = fallingDuration
               //delayDropSecond.start()

            } else if (doublePropability > 0){
                ++doublePass;
            }
        } else {
            generateTimer.stop();
        }
    }

    //--------------------------------------------------------------------------
    // 1. Начинает новый уровень
    //--------------------------------------------------------------------------
    function startLevel(levelIndex) {
        Log.info("------- Start level " + levelIndex + " ------- ");

        var level = levels[levelIndex];
        generateTimer.interval = level.dropInterval;
        generateTimer.intervalBeforePause = level.dropInterval;
        dropletsCapacity = level.dropletsCapacity;
        fallingDuration = level.fallingDuration;
        colorsIndexes = level.colorsIndexes;
        doublePropability = level.doublePropability;
        sameDoubleDroplet = level.sameDoubleDroplet;

        if (debug) {
            generateTimer.interval = 1000;
            generateTimer.intervalBeforePause = 1000;
            fallingDuration = 1000;
            dropletsCapacity = 4;
            doublePropability = 0.4;
            colorsIndexes = [0,1,2,3];
        }

        generateTimer.start();
        stopwatch.start()
        generate()
    }

    //--------------------------------------------------------------------------
    // 0a. Очищает переменные и параметры уровня. Останавливает таймеры.
    //--------------------------------------------------------------------------
    function clearLevel() {
        doublePass = 0;
        generateTimer.stop();
        stopwatch.stop()
        killAllDroplets();
    }

    //--------------------------------------------------------------------------
    // 0. Переходит на новый уровень (показывает заставку)
    //--------------------------------------------------------------------------
    function nextLevel() {
        clearLevel();
        ++currentLevel;

        if (levelCaption) {
            levelCaption.hide();
        }
        levelCaption = levelCaptionComponent.createObject(_field, {
              currentLevel: currentLevel
              ,description: levels[currentLevel].description
          });
    }

    //--------------------------------------------------------------------------
    function clearGame() {
        score = 0;
        currentLevel = -1;
        root.isGameOver = false;
        clearLevel();
    }

    //--------------------------------------------------------------------------
    function startGame() {
        clearGame();

        // Выбираем 2 рандомных цвета.
        var color1 = random(colors.length-1);
        do {
            var color2 = random(colors.length-1);
        } while(color1 === color2)

        levels[0].colorsIndexes = [color1, color2]

        nextLevel();
    }

    function gameOver() {
        root.isGameOver = true
        clearLevel();
        gameOverPopup.show();
    }

    //--------------------------------------------------------------------------
    Component.onCompleted: {
        // Перенёс в скрытии startScreen
        //startGame();
    }
}
