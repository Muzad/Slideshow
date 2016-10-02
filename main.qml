import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2
import QtQuick.Particles 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: root
    visible: true
    visibility: "FullScreen"

    property real commentFontSize: width * 0.017
    property real photosInterval: 7000

    FontLoader { id: sansFont; source: "fonts/IRANSansMobile.ttf" }

    Image {
        id: background
        anchors.fill: parent
        fillMode: Image.Stretch
        source: "images/background.png"
    }

    Rectangle{
        id: closeBtn
        anchors.right: parent.right
        anchors.top: parent.top
        width: Math.min(parent.width, parent.height) * 0.1
        height: width
        color: closeArea.pressed? "#20000000" :"transparent"

        Image {
            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: parent.width * 0.43
            source: "images/close.png"
            scale: closeArea.pressed? 0.9 :1
        }
        MouseArea{
            id: closeArea
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }

    Rectangle{
        id: browseBtn
        visible: !fileBrowser.isActive
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: Math.min(parent.width, parent.height) * 0.1
        height: width
        color: browseArea.pressed? "#20000000" :"transparent"

        Image {
            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: parent.width * 0.42
            source: "images/folder.png"
            scale: browseArea.pressed? 0.9 :1
        }
        MouseArea{
            id: browseArea
            anchors.fill: parent
            onClicked: fileBrowser.show()
        }
    }

    Timer {
        id: changeImgsTimer
        interval: photosInterval
        running: true
        repeat: true
        onTriggered: {
            comment.opacity = 0
            showCommentTimer.start()
            listView.currentIndex ++
            if(listView.currentIndex > listView.count-1) {
                hideList.start();
            }
        }
    }

    Timer {
        id: showCommentTimer
        interval: 1000
        onTriggered: comment.opacity = 1
    }

    FileBrowser {
        id: fileBrowser
        anchors.fill: parent
        folder: "file:" + PicDir
        onFileSelected: folderModel.folder = file
        z:20
    }

    FolderListModel {
        id: folderModel
        folder: "file:" + PicDir
        showDirs: false
        caseSensitive: false
        nameFilters: ["*.jpg", "*.png", "*.jpeg", "*.gif"]
    }

    Settings{
        property alias fileBrowserPath: folderModel.folder
    }

    Component {
        id: imagesDelegate
        Item {
            id: element
            width: root.width
            height: root.height

            property int locationTracker: x - listView.contentX
            property string photoName: filePath

            ItemPicture{
                property bool isCurrentItem: parent.ListView.isCurrentItem
            }

            transform: Rotation {
                id: itemRotation
                origin.x: element.width/2
                origin.y: element.height/2
                axis { x: 1; y: 1; z: 0 }
                angle: scaleProportion(root.width, -root.width, -100, 100, locationTracker)
            }
        }
    }

    ListView {
        id: listView
        spacing:  -root.width/3
        anchors.fill:  parent
        orientation: ListView.Horizontal
        interactive: false
//            highlightFollowsCurrentItem: true
        highlightMoveDuration: 900      //1500
        highlightRangeMode: ListView.StrictlyEnforceRange
        model: folderModel
        delegate: imagesDelegate

        transform: Rotation {
            id: listRotation
            origin.x: listView.width/2
            origin.y: listView.height/2
            axis { x: 1; y: 0; z: 0 }
            angle: 0    //10
        }
    }

    Rectangle{
        id: comment
        visible: listView.count > 0
        width: parent.width * 0.2
        height: parent.height * 0.45
        color: "#60000000"
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.03
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0
        Behavior on opacity{
            NumberAnimation {duration: 500}
        }

        Text{
            anchors.fill: parent
            font.pixelSize: commentFontSize
            font.family: sansFont.name
            wrapMode: Text.Wrap
            padding: parent.anchors.rightMargin

            color: "white"
            text: "A short comment about every picture."
        }
    }

    SequentialAnimation {
        id: hideList
        ParallelAnimation {
            NumberAnimation { target: listRotation; property: "angle"; to: -25; duration: 400; easing.type: Easing.InOutQuart }
            NumberAnimation { target: listView; property: "opacity"; to: 0; duration: 400; easing.type: Easing.InOutQuart }
        }
        ScriptAction {
            script: listView.currentIndex = 0
        }
        ParallelAnimation {
            NumberAnimation { target: listRotation; property: "angle"; from: 25; to: 0; duration: 400; easing.type: Easing.InOutQuart }
            NumberAnimation { target: listView; property: "opacity"; to: 1; duration: 400; easing.type: Easing.InOutQuart }
        }
    }

    function scaleProportion(big1, small1, big2, small2, value)
    {
        return ((big2 - small2) / (big1 - small1)) * (value - small1) + small2
    }
}
