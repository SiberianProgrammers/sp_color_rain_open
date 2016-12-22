import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Платформа с различными цветами
//--------------------------------------------------------------------------
ListView {
    id: _colorPlatform

    model: ListModel {
        id: colorModel

        ListElement { colorIndex: 0 }
        ListElement { colorIndex: 1 }
        ListElement { colorIndex: 2 }
        ListElement { colorIndex: 3 }
    }
    
    delegate: Rectangle {
        color: colors[model.colorIndex]
        width: columnWidth
        height: _colorPlatform.height
    }

    interactive: false
    orientation: ListView.Horizontal
    height: 1*Consts.ruh
    anchors {
        left: parent.left
        right: parent.right
        bottom: controlPanel.top
    }

    //--------------------------------------------------------------------------
    // Анимированное добавление цвета
    //--------------------------------------------------------------------------
    add: Transition {
        NumberAnimation {
            property: "x"
            easing.type: Easing.OutQuad
            duration: 150
            from: -columnWidth
            to: 0
        }
    }
    displaced: Transition {
        NumberAnimation {
            property: "x"
            easing.type: Easing.OutQuad
            duration: 150
        }
    }

    //--------------------------------------------------------------------------
    // Добавляет цвет в панель и вытесняет крайний
    //--------------------------------------------------------------------------
    function push(colorIndex) {
        colorModel.insert(0, {colorIndex: colorIndex});

        if (colorModel.count>6) {
            colorModel.remove(colorModel.count-1);
        }
    }

    //--------------------------------------------------------------------------
    function colorIndex(columnIndex) {
        return colorModel.get(columnIndex).colorIndex;
    }
}
