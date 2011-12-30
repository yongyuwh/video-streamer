import QtQuick 1.1
import com.nokia.symbian 1.1
import "util.js" as Util

Item {
    id: videoPlayerControls

    property bool isPlaying: true
    property int timePlayed: 0
    property int timeDuration: 0
    property bool showBackground: true
    property bool showBackButton: true

    signal backButtonPressed
    signal playPressed
    signal pausePressed

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: videoPlayerControls.showBackground ? Qt.rgba(0.75, 0.75, 0.75, 0.75) : Qt.rgba(0,0,0,0)

        Loader {
            id: backButtonLoader

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: videoPlayerControls.showBackButton ? visual.controlMargins : 0
            sourceComponent: videoPlayerControls.showBackButton ? backButtonComponent : emptyPlaceholder
        }

        Component {
            id: backButtonComponent

            Button {
                iconSource: visual.images.vpcBack
                width: visual.controlWidth
                height: visual.controlHeight
                onClicked: videoPlayerControls.backButtonPressed()
            }
        }

        Component {
            id: emptyPlaceholder

            Rectangle {
                width: 0
                height: 0
            }
        }

        Button {
            id: playButton

            iconSource: videoPlayerControls.isPlaying ? visual.images.vpcPause
                                                      : visual.images.vpcPlay
            width: visual.controlWidth
            height: visual.controlHeight
            anchors.verticalCenter: backButtonLoader.verticalCenter
            anchors.left: backButtonLoader.right
            anchors.leftMargin: visual.controlMargins
            onClicked: {
                if (videoPlayerControls.isPlaying) {
                    videoPlayerControls.pausePressed()
                } else {
                    videoPlayerControls.playPressed()
                }
            }
        }

        InfoTextLabel {
            id: timeElapsedLabel

            text: Util.milliSecondsToString(timePlayed)
            anchors.bottom: playButton.verticalCenter
            anchors.left: playButton.right
            anchors.right: parent.right
            anchors.leftMargin: visual.controlMargins
            anchors.rightMargin: visual.controlMargins
        }

        InfoTextLabel {
            id: timeDurationLabel

            text: Util.milliSecondsToString(timeDuration)
            anchors.bottom: playButton.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: visual.controlMargins
        }

        ProgressBar {
            id: progressBar

            anchors.top: playButton.verticalCenter
            anchors.left: playButton.right
            anchors.right: timeDurationLabel.right
            anchors.leftMargin: visual.controlMargins

            value: videoPlayerControls.timePlayed / videoPlayerControls.timeDuration
        }
    }
}
