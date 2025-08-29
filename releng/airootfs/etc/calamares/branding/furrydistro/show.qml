import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

/*
  show.qml
  FrazerOS — "Furry" themed Calamares show page

  Notes:
  - Place this file where your Calamares theme's `show` layout expects it (e.g. layouts/frazeros/)
  - Required image assets (place in the same folder or adjust paths):
      - assets/mascot.png        (recommended 512x512, transparent PNG)
      - assets/background.png    (1920x1080 or larger, subtle pattern)
      - assets/paw.png           (64x64 paw-print, used for floating paw animation)
  - Tweak colors and spacing in the top `theme` object.
  - This QML is intentionally self-contained and lightweight — it focuses on look/animation.
*/

ApplicationWindow {
    id: root
    width: 1280
    height: 720
    visible: true
    color: theme.background
    flags: Qt.FramelessWindowHint

    property var theme: ({
        primary: "#7C4FBD",           // purple base
        accent: "#FFB86B",            // warm accent (fur accents)
        background: "#0f1020",        // deep night background
        panel: "#121226AA",           // semi-transparent panel
        text: "#E6E6F0",
        pawTint: "#FFD6E0"
    })

    // Background pattern + dim overlay
    Item {
        anchors.fill: parent

        Image {
            id: bg
            anchors.fill: parent
            source: Qt.resolvedUrl("assets/background.png")
            fillMode: Image.PreserveAspectCrop
            opacity: 0.28
            smooth: true
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.22
        }
    }

    // Main content card
    Rectangle {
        id: card
        width: Math.min(root.width * 0.86, 1100)
        height: Math.min(root.height * 0.78, 700)
        anchors.centerIn: parent
        radius: 18
        color: theme.panel
        border.color: Qt.darker(theme.primary, 1.6)
        border.width: 1
        elevation: 8

        RowLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 16

            // LEFT: Title & text
            ColumnLayout {
                Layout.preferredWidth: card.width * 0.62
                Layout.fillHeight: true
                spacing: 12

                Label {
                    id: title
                    text: "Welcome to FrazerOS"
                    font.pixelSize: 36
                    font.bold: true
                    color: theme.primary
                    horizontalAlignment: Text.AlignLeft
                }

                Label {
                    id: subtitle
                    text: "A cozy, playful Linux experience — made for furry friends and humans alike."
                    font.pixelSize: 16
                    color: theme.text
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                }

                Rectangle {
                    id: infoBox
                    width: parent.width
                    height: 1
                    color: "transparent"
                }

                // Feature list
                ColumnLayout {
                    spacing: 8
                    Repeater {
                        model: [
                            "Soft, themeable desktop with playful icons",
                            "Privacy-minded defaults & simple installer",
                            "Custom mascot & sticker collection"
                        ]
                        delegate: RowLayout {
                            spacing: 10
                            Label {
                                text: "•"
                                font.pixelSize: 18
                                color: theme.accent
                            }
                            Label {
                                text: modelData
                                font.pixelSize: 14
                                color: theme.text
                                wrapMode: Text.WordWrap
                                Layout.preferredWidth: parent.width - 28
                            }
                        }
                    }
                }

                // small spacer to push buttons down
                Item { Layout.fillHeight: true }

                // Next/Back placeholders (Calamares will provide real navigation below) — these are decorative only
                RowLayout {
                    spacing: 12
                    anchors.right: parent.right

                    Button {
                        id: backBtn
                        text: "Back"
                        enabled: false
                        visible: false
                    }
                    Button {
                        id: continueBtn
                        text: "Start Installer"
                        onClicked: {
                            // Emit a custom signal that Calamares could listen for if integrated.
                            // If you integrate with the Calamares page API, replace with calamares.callNext() or similar.
                            console.log("Start Installer pressed — wire this into Calamares page navigation.")
                        }
                    }
                }
            }

            // RIGHT: Mascot + floating paws
            Item {
                Layout.preferredWidth: card.width * 0.36
                Layout.fillHeight: true

                // Soft rounded panel behind the mascot
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    radius: 14
                    color: "transparent"
                }

                // Mascot artwork
                Image {
                    id: mascot
                    source: Qt.resolvedUrl("assets/mascot.png")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 12
                    width: Math.min(parent.width * 0.86, 320)
                    height: width
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    scale: 1.0
                    SequentialAnimation on scale {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation { to: 1.035; duration: 2000; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutQuad }
                    }
                }

                // Floating paw particle animation (three pawprints drifting)
                Repeater {
                    id: paws
                    model: 3
                    Image {
                        source: Qt.resolvedUrl("assets/paw.png")
                        width: 48
                        height: 48
                        opacity: 0.95
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: parent.height * (0.52 + Math.random() * 0.34)
                        x: (index % 2 === 0) ? parent.width * 0.08 : parent.width * 0.6
                        transform: Rotation { angle: (index * 30) % 360 }

                        Behavior on x { NumberAnimation { duration: 4000 + index * 600; easing.type: Easing.InOutQuad } }
                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            PauseAnimation { duration: index * 300 }
                            NumberAnimation { property: "x"; to: (x < parent.width/2 ? parent.width * 0.72 : parent.width * 0.06); duration: 4500 + index*600; easing.type: Easing.InOutQuad }
                            NumberAnimation { property: "y"; to: parent.height * (0.15 + Math.random() * 0.5); duration: 3500 + index*300; easing.type: Easing.InOutQuad }
                            NumberAnimation { property: "opacity"; to: 0.25; duration: 1400 }
                            ScriptAction { script: { x = (index % 2 === 0) ? parent.width * 0.08 : parent.width * 0.6; opacity = 0.95; } }
                        }
                    }
                }

                // Subtle badge beneath mascot
                Rectangle {
                    anchors.horizontalCenter: mascot.horizontalCenter
                    anchors.top: mascot.bottom
                    anchors.topMargin: -8
                    width: mascot.width * 0.68
                    height: 36
                    radius: 10
                    color: Qt.rgba(0,0,0,0.18)
                    border.color: Qt.rgba(1,1,1,0.06)
                    RowLayout { anchors.fill: parent; anchors.margins: 6; spacing: 8; horizontalAlignment: Qt.AlignHCenter; verticalAlignment: Qt.AlignVCenter
                        Label { text: "FrazerOS Mascot"; color: theme.text; font.pixelSize: 13 }
                        Rectangle { width: 1; height: parent.height * 0.6; color: Qt.rgba(1,1,1,0.04) }
                        Label { text: "v1.0"; color: theme.accent; font.pixelSize: 12 }
                    }
                }
            }
        }

        // Decorative rounded corner overlays
        Canvas {
            anchors.fill: parent
            opacity: 0.12
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0,0,width,height);
                ctx.fillStyle = "rgba(255, 200, 230, 0.06)"; // soft highlight
                ctx.beginPath();
                ctx.moveTo(0, height*0.25);
                ctx.quadraticCurveTo(width*0.20, height*0.12, width*0.5, height*0.02);
                ctx.lineTo(width, 0);
                ctx.lineTo(width, height*0.2);
                ctx.quadraticCurveTo(width*0.75, height*0.4, width*0.60, height*0.6);
                ctx.fill();
            }
        }
    }

    // Tiny footer with legal / credits
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: root.width
        height: 28
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: "FrazerOS — made with ❤️ for the community · Installer theme: Furry"
            font.pixelSize: 11
            color: theme.text
            opacity: 0.65
        }
    }

    // Accessibility: keyboard shortcut to start
    Keys.onPressed: {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            continueBtn.clicked()
        }
    }
}

