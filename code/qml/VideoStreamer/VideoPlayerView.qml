import QtQuick 1.0
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1

Item {
    id: videoPlayerContainer

    property alias source: videoPlayerImpl.source
    property alias duration: videoPlayerImpl.duration
    property alias timePlayed: videoPlayerImpl.position
    property int timeRemaining: videoPlayerImpl.duration - timePlayed
    property bool isPlaying: false

    signal toggled

    function play() {
        videoPlayerImpl.play()
    }

    function stop() {
        videoPlayerImpl.stop()
    }

    function pause() {
        videoPlayerImpl.pause()
    }

    function __volumeUp() {
        var maxVol = 1.0
        var volThreshold = 0.1
        if (videoPlayerImpl.volume < maxVol - volThreshold) {
            videoPlayerImpl.volume += volThreshold
        } else {
            videoPlayerImpl.volume = maxVol
        }
    }

    function __volumeDown() {
        var minVol = 0.0
        var volThreshold = 0.1
        if (videoPlayerImpl.volume > minVol + volThreshold) {
            videoPlayerImpl.volume -= volThreshold
        } else {
            videoPlayerImpl.volume = minVol
        }
    }

    anchors.fill: parent

    Rectangle {
        id: videoBackground

        color: "black"
        z: videoPlayerImpl.z - 1
        anchors.fill: parent
    }

    Video {
        id: videoPlayerImpl

        volume: 0.1
        autoLoad: true
        anchors.fill: parent
        fillMode: Video.PreserveAspectFit
        focus: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                videoPlayerContainer.toggled()
            }
        }

        onPlayingChanged: videoPlayerContainer.isPlaying = playing
        onPausedChanged: videoPlayerContainer.isPlaying = !paused
    }

    Rectangle {
        id: bufferingIndicator

        anchors.fill: parent
        color: "black"
        z: videoPlayerImpl.z + 1
        opacity: 1

        BusyIndicator {
            anchors.centerIn: parent
            height: visual.busyIndicatorHeight
            width: visual.busyIndicatorWidth
            running: true
        }
    }

    Connections {
        target: volumeKeys
        onVolumeKeyUp: __volumeUp()
        onVolumeKeyDown: __volumeDown()
    }

    states: State {
        name: "BufferingDone"
        when: (videoPlayerImpl.status === Video.Buffered ||
               videoPlayerImpl.status === Video.EndOfMedia)

        PropertyChanges {
            target: bufferingIndicator
            opacity: 0
        }
    }
}