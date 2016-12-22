import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Табличка с текущим уровнем
//--------------------------------------------------------------------------
Rectangle {
    id: _levelCaption
    
    property int currentLevel
    property real extHeight: 0
    property real originalHeight: textItem.height + 0.2*Consts.ruh
    property alias description: descriptionItem.text
    property bool  needRunLevel: true
    property bool  mayRunLevel: false

    width: textItem.width + 2*radius
    height: originalHeight + extHeight
    radius: 0.5*height
    color: "#8d5fd3"
    anchors.horizontalCenter: parent.horizontalCenter
    z: 10

    //--------------------------------------------------------------------------
    Text {
        id: textItem

        text: qsTr("Level %1").arg(currentLevel + 1)
        color: "white"
        font {
            pixelSize: 1*Consts.ruh
            bold: true
        }
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 0.5*originalHeight
            bottomMargin: 0.5*(originalHeight - height)
        }
    }

    //--------------------------------------------------------------------------
    Rectangle {
        anchors {
            right: scoreItem.left
            rightMargin: 0.8*Consts.margin
            verticalCenter: scoreItem.verticalCenter
        }
        color: colors[lastDropletColorIndex]
        height: 0.80*scoreItem.font.pixelSize
        width: height
        radius: 0.5*height
        visible: scoreItem.visible
    }

    //--------------------------------------------------------------------------
    Text {
        id: scoreItem

        text: ("%1 / %2").arg(score).arg(maxScore)
        color: "white"
        font {
            pixelSize: 1*Consts.ruh
            bold: true
        }
        visible: false
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: -_field.width + _levelCaption.width + textItem.anchors.leftMargin
            bottomMargin: 0.5*(originalHeight - height)
        }
    } // Text { id: scoreItem

    //--------------------------------------------------------------------------
    Text {
        id: descriptionItem

        //color: Consts.darkGray
        color: Consts.gray
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        visible: false
        opacity: 0.0
        font {
            pixelSize: 1*Consts.ruh
            bold: true
        }
        anchors {
            top: parent.bottom
            topMargin: 1.5*Consts.margin
            horizontalCenter: parent.horizontalCenter
        }
        width: _field.width - 2*Consts.margin
    } // Text { id: descriptionItem

    //--------------------------------------------------------------------------
    Item {
        id: statesItem

        state: "start"
        states: [
            State {
                name: "start"

                PropertyChanges {
                    target: _levelCaption
                    y: _field.height
                }
            } // State { name: "start"
            ,State {
                name: "center"

                PropertyChanges {
                    target: _levelCaption
                    y: (_field.height-textItem.height-descriptionItem.height-Consts.margin)/2
                }
                PropertyChanges {
                    target: descriptionItem
                    visible: true
                    opacity: 1.0
                }
            } // ,State { name: "center"
            ,State {
                name: "top"

                PropertyChanges {
                    target: _levelCaption
                    y: Consts.statusBarHeight
                }
            } // ,State { name: "top"
            ,State {
                name: "topExpanded"

                PropertyChanges {
                    target: _levelCaption
                    y: 0
                    extHeight: Consts.statusBarHeight
                    radius: 0
                    width: _field.width
                    clip: true
                }
                PropertyChanges {
                    target: textItem
                    anchors.leftMargin: Consts.margin
                }
                PropertyChanges {
                    target: scoreItem
                    visible: true
                }
            } // ,State { name: "topExpanded"
            ,State {
                name: "hidden"

                PropertyChanges {
                    target: _levelCaption
                    y: -_levelCaption.height
                    extHeight: Consts.statusBarHeight
                    radius: 0
                    width: _field.width
                    clip: true
                }
                PropertyChanges {
                    target: textItem
                    anchors.leftMargin: Consts.margin
                }
                PropertyChanges {
                    target: scoreItem
                    visible: true
                }
            } // ,State { name: "hidden"
        ] // states: [

        //----------------------------------------------------------------------
        transitions: [
            Transition {
                to: "center"

                SequentialAnimation {
                    PropertyAction {
                        property: "visible"
                    }
                    NumberAnimation {
                        properties: "y,opacity"
                        duration: 700
                    }
                    PauseAnimation {
                        duration: 1500
                    }
                }

                onRunningChanged: {
                    if (!running) {
                        statesItem.state = "top";
                    }
                }
            } // Transition { to: "center"
            ,Transition {
                to: "top"

                SequentialAnimation {
                    NumberAnimation {
                        properties: "y,opacity"
                        duration: 500
                    }
                    PropertyAction {
                        property: "visible"
                    }
                }

                onRunningChanged: {
                    if (!running) {
                        statesItem.state = "topExpanded";
                    }
                }
            } // Transition { to: "top"
            ,Transition {
                to: "topExpanded"

                NumberAnimation {
                    properties: "y,extHeight,radius,anchors.leftMargin,width"
                    easing.type: Easing.OutQuad
                    duration: 400
                }

                onRunningChanged: {
                    mayRunLevel = true
                    if (!running && root.active && !pauseButton.visible) {
                        startLevel(currentLevel);
                        needRunLevel = false;
                        mayRunLevel = false;
                    }
                }
            } // ,Transition { to: "topExpanded"
            , Transition {
                to: "hidden"

                NumberAnimation {
                    property: "y"
                    duration: 300

                    onStopped: {
                        _levelCaption.destroy();
                    }
                }

                onRunningChanged: {
                    if (!running) {
                        _levelCaption.destroy();
                    }
                }
            } // , Transition { to: "hidden"
        ] // transitions: [
    } // Item { id: statesItem

    //--------------------------------------------------------------------------
    function hide() {
        statesItem.state = "hidden";
    }

    function show() {
        statesItem.state = "center";
        //statesItem.state = "top";
    }

    Connections {
        target: root
        onResumeGame: {
            if (needRunLevel && mayRunLevel) {
                startLevel(currentLevel);
                mayRunLevel = false;
            }
        }
    }

    //--------------------------------------------------------------------------
    Component.onCompleted: {
        show();
    }
}
