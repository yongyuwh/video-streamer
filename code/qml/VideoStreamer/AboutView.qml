/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: aboutView

    property variant pageStack
    property string viewName: "aboutView"

    // Background gradient
    TitleBar {
        id: logo

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    // Label for the application.
    InfoTextLabel {
        id: titleText

        anchors {
            top: logo.bottom
            topMargin: visual.margins*3
            left: parent.left
            leftMargin: visual.margins
        }
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: visual.largeFontSize
        font.bold: true
        text: qsTr("YouTube Video Channel")
    }

    // Some about text & application information.
    InfoTextLabel {
        id: aboutText

        anchors {
            margins: visual.margins*2
            left: parent.left
            right: parent.right
            top: titleText.bottom
        }

        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: qsTr("<p>Version: " + cp_versionNumber + " (with " +
                   (cp_IAADefined ? "In-App Analytics" : "console logging stub") +
                   ")</p>" +
                   "<p>QML VideoStreamer application is a Nokia Developer example " +
                   "demonstrating the QML Video playing capabilies. " +
                   "Videos are streamed from Nokia Developer's YouTube channel " +
                   "<a href=\"http://www.youtube.com/nokiadevforum\">NokiaDevForum</a></p>" +
                   "<p>Developed and published by Nokia. All rights reserved.</p>" +
                   "<p>Learn more at " +
                   "<a href=\"http://projects.developer.nokia.com/QMLVideoStreamer\">" +
                   "developer.nokia.com</a>.</p>")

        onLinkActivated: {
            console.log("Launched url " + link);
            Qt.openUrlExternally(link);
        }
    }

    // ToolBarLayout for AboutView
    tools: ToolBarLayout {
        id: aboutTools

        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: aboutView.pageStack.pop()
        }
    }
}
