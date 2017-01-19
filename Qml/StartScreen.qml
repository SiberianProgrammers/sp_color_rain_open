import QtQuick 2.8
import SP 1.0
import "./"
import "qrc:/SpQml"

Rectangle {
    id: _startScreen

    signal hide()

    height: Window.height
    width : Window.width

    Rectangle {
        color: Consts.gray
        height: Consts.statusBarHeight
        width: parent.width
    }

    //--------------------------------------------------------------------------
    Text {
        id: appName

        text: "<font color=\"#348BFF\">C</font>
               <font color=\"#85E881\">O</font>
               <font color=\"#E84281\">L</font>
               <font color=\"#85E881\">O</font>
               <font color=\"#FFD129\">R</font>
               <br>
               <font color=\"#E84281\">R</font>
               <font color=\"#FFD129\">A</font>
               <font color=\"#348BFF\">I</font>
               <font color=\"#85E881\">N</font>"
        anchors {
            centerIn: parent
            verticalCenterOffset: -height
        }
        lineHeight: 1.1
        z: 5
        horizontalAlignment: Text.AlignHCenter
        font {
            pixelSize: 1.5*Consts.ruh
            bold: true
            letterSpacing: 0.01*Consts.ruh
        }
    } // Text { id: appName

    Rectangle {
        width: startCaption.width + 2*radius
        height: startCaption.height + 0.2*Consts.ruh
        radius: 0.5*height
        color: "#8d5fd3"
        z: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors {
            centerIn: parent
            verticalCenterOffset: height
        }

        Text {
            id: startCaption

            text: "START"
            anchors.centerIn: parent
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            font {
                pixelSize: 1*Consts.ruh
                bold: true
            }
        }
    }

    //--------------------------------------------------------------------------
    Text {
        id: musicCaption

        text: "Music by \"Rainbows\" Kevin MacLeod<br>
        (incompetech.com)<br>
        Licensed under Creative Commons:<br>
        By Attribution 3.0<br>
        http://creativecommons.org/licenses/<br>by/3.0/"

        horizontalAlignment: Text.AlignHCenter
        z: 5
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 0.2*Consts.ruh
        }

        width: parent.width - Consts.ruw
        color: Consts.gray
        fontSizeMode: Text.Fit
        minimumPixelSize: 0.2*Consts.ruh
        font {
            pixelSize: Math.floor(0.43*Consts.ruh)
        }
    } // Text { id: musicCaption

    //--------------------------------------------------------------------------
    Item {
        id: stateItems

        state: "visible"
        states: [
            State {
                name: "visible"
                PropertyChanges {
                    target: _startScreen
                    opacity: 1.0
                }
            }
            , State {
                name: "hidden"
                PropertyChanges {
                    target: _startScreen
                    opacity: 0.0
                }
            }
        ] // states: [

        transitions: [
            Transition {
                SequentialAnimation {
                    NumberAnimation {
                        property: "opacity"
                        easing.type: Easing.InQuart
                        duration: 450
                    }
                    ScriptAction {
                        script: {
                            dropletTimer.stop()
                            _startScreen.hide()
                        }
                    }
                }
            }
        ] // transitions: [
    } // Item { id: stateItems

    MouseArea {
        anchors.fill: parent
        onClicked: {
            stateItems.state = "hidden"
            enabled = false
        }
    }

    //--------------------------------------------------------------------------
    Timer {
        interval: 5000
        //running: true
        onTriggered: {
            stateItems.state = "hidden"
        }
    }

    //--------------------------------------------------------------------------
    // Динамические создание капель на заднем фоне
    //--------------------------------------------------------------------------
    Timer {
        id: dropletTimer

        property var positionArray: ([ 0.05*Window.width
                                      , 0.2*Window.width
                                      , 0.35*Window.width
                                      , 0.5*Window.width
                                      , 0.65*Window.width
                                      , 0.82*Window.width
                                     ])
        property int previuosColumn: -1

        interval: 400
        repeat: true
        running: true
        onTriggered: {
            do {
                var column = random(positionArray.length - 1);
            } while(column === previuosColumn)
            previuosColumn = column

            _dropletComponent.createObject(_startScreen, {
                                              x: positionArray[previuosColumn]
                                          });
        }
    } // id: dropletTimer

    //--------------------------------------------------------------------------
    Component {
        id: _dropletComponent

        Rectangle {
            id: _dropletStartScreen

            property int colorIndex: random(3)
            property int fallingDuration: 3000 + random(1000)

            width: 0.1*Window.width
            height: width
            radius: 0.5*width
            color: colors[colorIndex]
            opacity: 0.15
            z: 0

            //--------------------------------------------------------------------------
            NumberAnimation {
                id: fallingAnimation

                running: true
                target: _dropletStartScreen
                property: "y"
                from: -Consts.statusBarHeight
                to: Window.height
                duration: _dropletStartScreen.fallingDuration

                onStopped: {
                    _dropletStartScreen.destroy();
                }
            } // NumberAnimation {
        }// Rectangle { id: _dropletStartScreen
    } // Component { id: _dropletComponent

    function random (max) {
        max = Math.floor(max);
        return Math.floor(Math.random() * (max + 1));
    }
} // Rectangle { id: _startScreen
