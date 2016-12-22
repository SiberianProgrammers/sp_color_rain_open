import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Панель с 4 кнопками для добавления различных цветов.
//--------------------------------------------------------------------------
Row {
    id: _controlPanel
    
    anchors.bottom: parent.bottom
    height: 2*Consts.ruh

    //--------------------------------------------------------------------------
    // Модель кнопок
    //--------------------------------------------------------------------------
    ListModel {
        id: colorModel

        ListElement { colorIndex: 0 }
        ListElement { colorIndex: 1 }
        ListElement { colorIndex: 2 }
        ListElement { colorIndex: 3 }
    }

    //--------------------------------------------------------------------------
    Repeater {
        model: colorModel

        Rectangle {
            color: colors[model.colorIndex]
            width: columnWidth
            height: _controlPanel.height

            //--------------------------------------------------------------------------
            // Тень на кнопке при нажатии
            //--------------------------------------------------------------------------
            Rectangle {
                id: shadow

                color: "black"
                anchors.fill: parent
                opacity: 0.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }
            } // Rectangle { id: shadow

            //--------------------------------------------------------------------------
            MultiPointTouchArea {
                anchors {
                    fill: parent
                    topMargin: -colorPlatform.height
                }

                onPressed: {
                    shadow.opacity = 0.2
                    colorPlatform.push(model.colorIndex);
                }

                onReleased: {
                    shadow.opacity = 0.0
                }
            } // MultiPointTouchArea {
        } // Rectangle {
    } // Repeater {
}
