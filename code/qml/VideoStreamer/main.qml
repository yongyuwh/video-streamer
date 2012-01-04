import QtQuick 1.1
import com.nokia.meego 1.0

Window {
    id: root

    // Declared properties
    property bool isShowingSplashScreen: true
    property bool showStatusBar: !isShowingSplashScreen
    property bool showToolBar: !isShowingSplashScreen
    property variant initialPage
    property variant busySplash
    property alias pageStack: stack
    property bool platformSoftwareInputPanelEnabled: false

    // Attribute definitions
    initialPage: VideoListView {
        tools: toolBarLayout
        // Set the height for the VideoListView's list, as hiding / showing
        // the ToolBar prevents the pagestack from being anchored to it.
        listHeight: parent.height-tbar.height
    }

    Component.onCompleted: {
        // Use the black theme on MeeGo.
        theme.inverted = true;
        // Instantiate the Fake Splash Component. Shows a busy indicator for
        // as long as the xml data model keeps loading.
        var comp = busySplashComp;
        if (comp.status === Component.Ready) {
            busySplash = comp.createObject(root);
        }
    }

    Component {
        id: busySplashComp

        BusySplash {
            id: busy
            width: root.width
            height: root.height

            // Get rid of the fake splash for good, when loading is done!
            onDismissed: busySplash.destroy();

            Connections {
                target: xmlDataModel
                onLoadingChanged: {
                    busy.opacity = 0;
                    root.isShowingSplashScreen = false;
                    stack.push(initialPage);
                }
            }
        }
    }

    // VisualStyle has platform differentiation attribute definitions.
    VisualStyle {
        id: visual

        // Bind the layout orientation attribute.
        inPortrait: root.inPortrait
        // Check, whether or not the device is E6
        isE6: root.height == 480
    }

    // Background, shown behind the lists. Will fade to black when hiding it.
    Image {
        id: backgroundImg
        anchors.fill: parent
        source: visual.inPortrait ? visual.images.portraitBackground
                                  : visual.images.landscapeBackground

        states: [
            State {
                name: "invisible"
                when: !visual.showBackground
                PropertyChanges { target: backgroundImg; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                to: "invisible"
                NumberAnimation {
                    properties: "opacity"
                    duration: visual.animationDurationPrettyLong
                }
            }
        ]
    }

    // Default ToolBarLayout
    ToolBarLayout {
        id: toolBarLayout

        ToolIcon {
            iconId: "toolbar-search"
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"), {pageStack: stack})
        }
        ToolIcon {
            iconSource: visual.images.infoIcon
            onClicked: pageStack.push(Qt.resolvedUrl("AboutView.qml"), {tools: aboutTools})
        }
    }

    // ToolBarLayout for AboutView
    ToolBarLayout {
        id: aboutTools

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
    }

    PageStack {
        id: stack
        anchors {
            top: sbar.bottom; bottom: parent.bottom
            left: parent.left; right: parent.right
        }

        clip: true
        toolBar: tbar
    }

    ToolBar {
        id: tbar

        width: parent.width
        visible: root.showToolBar
        anchors.bottom: parent.bottom
    }

    StatusBar {
        id: sbar

        width: parent.width
        visible: root.showStatusBar
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
