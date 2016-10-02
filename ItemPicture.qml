import QtQuick 2.7

Item {
    anchors.fill: parent
    state: "hidden"

    Image {
        id: pic
        source: "file:" + filePath
        anchors.centerIn: parent
        smooth: true
        cache: true
        autoTransform: true
        asynchronous: true

        sourceSize.width: parent.width * 0.85
        sourceSize.height: parent.height * 0.85

        Image {
            id: shadow_image
            source: "images/shadow.png"
            anchors.top:  parent.bottom
            anchors.topMargin: 10
            width: parent.width
            asynchronous: true
            smooth: false
        }
    }

    states:  State {
        name: "hidden"
        when: !isCurrentItem
        PropertyChanges {target: pic; opacity: 0}
    }

    transitions: Transition {
        NumberAnimation {
            duration: 800
            properties: "opacity"
            easing.type: Easing.InOutQuart
        }
    }
}
