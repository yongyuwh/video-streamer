import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

Page {
    id: searchView

    // Declared properties
    property variant pageStack

    // If the user moves up/down, focus on the list instead of the search box.
    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Up:
            case Qt.Key_Down:
                // Don't accept the event, just set the focus to the list.
                // The ListItems themselves will accept the kb events.
                listView.forceActiveFocus();
                break;
            }
        }
    }

    SearchBox {
        id: searchbox

        placeHolderText: qsTr("Search Text")
        backButton: true
        onBackClicked: searchView.pageStack.depth <= 1 ? Qt.quit()
                                                       : searchView.pageStack.pop()
    }

    VideoListModel {
        id: videoListModel
        searchTerm: searchbox.searchText
    }

    ListView {
        id: listView

        anchors {
            top: searchbox.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        model: xmlDataModel.status === XmlListModel.Error ? 1 : (searchbox.searchText ? videoListModel : null)
        snapMode: ListView.SnapToItem
        cacheBuffer: visual.videoListItemHeight*10
        clip: true

        // List item delegate Component.
        Component {
            id: videoListItem
            VideoListItem {
                width: listView.width
            }
        }

        Component {
            id: networkErrorItem
            NetworkErrorItem {
                width: listView.width
            }
        }

        delegate: xmlDataModel.status === XmlListModel.Error ? networkErrorItem : videoListItem
    }

    ScrollDecorator {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        // flickableItem binds the scroll decorator to the ListView.
        flickableItem: listView
    }

    Text {
        id: noResultsText

        font {
            family: visual.defaultFontFamily
            pixelSize: visual.largeFontSize
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: searchbox.bottom
        opacity: 0
        color: visual.defaultFontColor
        text: qsTr("No videos found")
    }

    states: State {
        name: "NoResults"
        when: (videoListModel.searchTerm &&
               videoListModel.count <= 0 &&
               videoListModel.status === XmlListModel.Ready)

        PropertyChanges {
            target: noResultsText
            opacity: 1
        }
    }
}
