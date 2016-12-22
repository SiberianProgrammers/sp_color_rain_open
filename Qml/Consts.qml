pragma Singleton

import QtQuick 2.8

QtObject {
    property real ruh: Window.height/20
    property real ruw: Window.width/20
    property real margin: 0.5*ruh
    property real marginBig: 1.1*ruh
    property color gray: "#c0c0c0"
    property color darkGray: "#4a4a4a"
    property int statusBarHeight: 0
}
