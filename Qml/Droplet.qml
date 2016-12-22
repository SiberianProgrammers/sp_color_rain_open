import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Элемент-капля. При создании запускается анимация падения
//--------------------------------------------------------------------------
Rectangle {
    id: _droplet
    
    property int columnIndex: 2
    property int colorIndex: columnIndex
    property int fallingDuration: 2000
    
    x: 0.5*(columnWidth - width) + columnIndex*_field.width/4
    width: 0.1*_field.width
    height: width
    radius: 0.5*width
    color: colors[colorIndex]
    
    //--------------------------------------------------------------------------
    // Анимация падения
    //--------------------------------------------------------------------------
    NumberAnimation {
        id: fallingAnimation
        
        running: true
        target: _droplet
        property: "y"
        from: levelCaption.height - _droplet.height
        to: _field.height - _droplet.height
        duration: fallingDuration

        onStarted: {
            if (!root.active || pauseButton.visible) {
                fallingAnimation.pause()
            }
        }
        
        onStopped: {
            if (colorPlatform.colorIndex(_droplet.columnIndex) === _droplet.colorIndex) {
                lastDropletColorIndex = colorIndex;
                ++score;
                if (score > maxScore) {
                    maxScore = score;
                    Settings.set("maxScore", maxScore);
                }

                kill();
            } else {
                gameOver();
            }
        } // onStopped: {
    } // NumberAnimation { id: fallingAnimation

    //--------------------------------------------------------------------------
    // Анимация "смерти" капли.
    //--------------------------------------------------------------------------
    ParallelAnimation {
        id: deathAnimation

        NumberAnimation {
            target: _droplet
            property: "scale"
            easing.type: Easing.InQuad
            from: 1.0
            to: 1.5
            duration: 150
        }
        NumberAnimation {
            target: _droplet
            property: "opacity"
            easing.type: Easing.InQuad
            from: 1.0
            to: 0.0
            duration: 150
        }

        onStopped: {
            _droplet.destroy();
        }
    } // ParallelAnimation { id: deathAnimation

    //--------------------------------------------------------------------------
    function kill() {
        deathAnimation.start();
    }

    //--------------------------------------------------------------------------
    Connections {
        target: _field
        onKillAllDroplets: {
            kill();
        }
    }

    //--------------------------------------------------------------------------
    Connections {
        target: root
        onPauseGame: {
            if (deathAnimation.running) {
                deathAnimation.pause()
            }

            if (fallingAnimation.running) {
                fallingAnimation.pause()
            }
        }

        onResumeGame: {
            deathAnimation.resume()
            fallingAnimation.resume()
        }
    }

    //--------------------------------------------------------------------------
    Component.onCompleted: {
        ++dropletsInFly;
    }

    //--------------------------------------------------------------------------
    Component.onDestruction: {
        --dropletsInFly;
    }
}
