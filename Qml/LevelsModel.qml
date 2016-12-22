import QtQuick 2.8
import "./"

//--------------------------------------------------------------------------
// Модель на основе которой создаются уровни.
//--------------------------------------------------------------------------
QtObject {
    id: levelsModel
    
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
}
