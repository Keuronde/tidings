import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.implicitHeight

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: qsTr("Settings")
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            TextSwitch {
                width: parent.width
                text: qsTr("Show preview images")
                description: qsTr("Hiding the preview images saves network traffic. This switch does not affect embedded images in the item view.")
                automaticCheck: false
                checked: configShowPreviewImages.booleanValue

                onClicked: {
                    configShowPreviewImages.value =
                            configShowPreviewImages.booleanValue ? "0" : "1";
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            TextSwitch {
                width: parent.width
                text: qsTr("Tinted items")
                description: qsTr("If enabled, items have their background tinted in their tag color.")
                automaticCheck: false
                checked: configTintedItems.booleanValue

                onClicked: {
                    configTintedItems.value =
                            configTintedItems.booleanValue ? "0" : "1";
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            ComboBox {
                id: fontCombo
                property variant _scales: [50, 75, 100, 125, 150, 200, 250, 300]

                Component.onCompleted: {
                    var idx = _scales.indexOf(Math.floor(configFontScale.value));
                    currentIndex = idx >= 0 ? idx : 0;

                    // description is a new property of Silica ComboBox;
                    // only use it if available
                    try
                    {
                        description = qsTr("This setting changes the scale of the fonts in the feed view.");
                    }
                    catch (err)
                    {

                    }
                }

                width: parent.width
                label: qsTr("Font scale:")

                menu: ContextMenu {
                    MenuItem { text: fontCombo._scales[0] + " %" }
                    MenuItem { text: fontCombo._scales[1] + " %" }
                    MenuItem { text: fontCombo._scales[2] + " %" }
                    MenuItem { text: fontCombo._scales[3] + " %" }
                    MenuItem { text: fontCombo._scales[4] + " %" }
                    MenuItem { text: fontCombo._scales[5] + " %" }
                    MenuItem { text: fontCombo._scales[6] + " %" }
                    MenuItem { text: fontCombo._scales[7] + " %" }
                }

                onCurrentIndexChanged: {
                    configFontScale.value = _scales[currentIndex];
                    console.log("config " + configFontScale.value);
                }
            }

        }//Column

    }

}

