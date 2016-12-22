import QtQuick 2.8
import "./"

Item {
    id: dropletGenerator
    
    readonly property alias stopwatch: stopwatch
    readonly property alias generateTimer: generateTimer
    readonly property alias levels: levelsModel.levels
    
    property int dropletsCapacity: 20
    property int fallingDuration
    property real doublePropability
    property bool sameDoubleDroplet
    property int doublePass: 0
    property var colorsIndexes: ([])

    //--------------------------------------------------------------------------
    LevelsModel { id: levelsModel }

    //--------------------------------------------------------------------------
    // Действия на паузу
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
    } // Connections {
    
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
    } // Timer { id: stopwatch
    
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
    } // Timer { id: generateTimer
    
    //--------------------------------------------------------------------------
    function random (max) {
        max = Math.floor(max);
        return Math.floor(Math.random() * (max + 1));
    } // function random (
    
    //--------------------------------------------------------------------------
    // 2а. Очистка параметров всей игры
    //--------------------------------------------------------------------------
    function clearGame() {
        score = 0;
        currentLevel = -1;
        root.isGameOver = false;
        clearLevel();
    }

    //--------------------------------------------------------------------------
    // 2b. Очищает переменные и параметры уровня. Останавливает таймеры.
    //--------------------------------------------------------------------------
    function clearLevel() {
        doublePass = 0;
        generateTimer.stop();
        stopwatch.stop()
        killAllDroplets();
    }
    
    //--------------------------------------------------------------------------
    // 3. Переходит на новый уровень с показом заставки
    //--------------------------------------------------------------------------
    function nextLevel() {
        clearLevel();
        ++currentLevel;
        
        if (levelCaption) {
            levelCaption.hide();
        }
        
        // Внутри levelCaption вызывается фунция startLevel()
        levelCaption = levelCaptionComponent.createObject(_field, {
                                                              currentLevel: currentLevel
                                                              ,description: levels[currentLevel].description
                                                          });
    } // function nextLevel(
    
    //--------------------------------------------------------------------------
    // 4. Начинает новый уровень
    //--------------------------------------------------------------------------
    function startLevel(levelIndex) {
        print("------- Start level " + levelIndex + " ------- ");

        var level = levels[levelIndex];
        dropletGenerator.generateTimer.interval = level.dropInterval;
        dropletGenerator.generateTimer.intervalBeforePause = level.dropInterval;

        dropletGenerator.dropletsCapacity = level.dropletsCapacity;
        dropletGenerator.fallingDuration = level.fallingDuration;
        dropletGenerator.colorsIndexes = level.colorsIndexes;
        dropletGenerator.doublePropability = level.doublePropability;
        dropletGenerator.sameDoubleDroplet = level.sameDoubleDroplet;

        dropletGenerator.generateTimer.start();
        dropletGenerator.stopwatch.start()
        dropletGenerator.generate()
    } // function startLevel(

    //--------------------------------------------------------------------------
    // 5. Генерирует капли согласно параметрам уровня
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
            } else if (doublePropability > 0){
                ++doublePass;
            }
        } else {
            generateTimer.stop();
        }
    } // function generate() {

    //--------------------------------------------------------------------------
    // Создание капли с анимацией падения
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
    } // function drop(
}
