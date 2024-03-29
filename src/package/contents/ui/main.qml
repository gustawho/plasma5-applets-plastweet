/*
 * 
 * Copyright 2020 Gustavo Castro <gustawho@gmail.com>
 *
 * This file is part of Plastweet.
 *
 * Plastweet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Plastweet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Plastweet.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// TODO:
// * Add a progress bar for media upload
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.12

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.draganddrop 2.0 as DragDrop

// C++ Backend
import org.kde.plastweet 1.0

Item {
	id: main
	
	Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground
	
	readonly property string consumer_key: plasmoid.configuration.consKey
	readonly property string consumer_secret: plasmoid.configuration.consSec
	readonly property string user_secret: plasmoid.configuration.accToken
	readonly property string token_secret: plasmoid.configuration.accTokenSec
	
	Plasmoid.compactRepresentation: DragDrop.DropArea {
		id: compactDropArea
		onDragEnter: activationTimer.restart()
		onDragLeave: activationTimer.stop()
		
		Timer {
			id: activationTimer
			interval: 250
			onTriggered: plasmoid.expanded = true
		}
		
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: plasmoid.expanded = !plasmoid.expanded
			
			PlasmaCore.IconItem {
				id: trayIcon
				anchors.fill: parent
				source: "plastweet"
				colorGroup: PlasmaCore.ColorScope.colorGroup
				active: parent.containsMouse
			}
			
			ColorOverlay {
				anchors.fill: trayIcon
				source: trayIcon
				color: theme.viewTextColor
			}
		}
	}
	
	Plasmoid.fullRepresentation: ColumnLayout {
		id: fullRepresentation
		
		Layout.margins: PlasmaCore.Units.smallSpacing
		
		Layout.minimumHeight: units.gridUnit * 10
		Layout.minimumWidth: units.gridUnit * 15
		
		property string filepath: ""
		
		BackEnd {
			id: backend
		}
		
		Connections {
			target: plasmoid
			onExpandedChanged: {
				if (plasmoid.expanded) {
					sessionsModel.reload()
				}
			}
		}
		
		RowLayout {
			id: topRowLayout
			Layout.alignment: Qt.AlignHCenter
			Layout.fillWidth: true
			
			PlasmaComponents.TextArea {
				id: inputQuery
				implicitHeight: parent.minimumHeight
				implicitWidth: parent.width
				wrapMode: TextEdit.Wrap
				Layout.fillWidth: true
				Layout.fillHeight: true
				placeholderText: i18nc("@info", "What's happening?")
				textColor: text.length >= 280 ? theme.negativeTextColor : theme.viewTextColor
				
				PlasmaComponents.Label {
					id: charCounter
					anchors.bottom: inputQuery.bottom
					anchors.right: inputQuery.right
					anchors.rightMargin: 6
					text: inputQuery.text.length
					font.italic: true
					visible: inputQuery.text.length <= 0 ? false : true
					color: inputQuery.text.length >= 280 ? theme.negativeTextColor : theme.viewTextColor
					font.bold: inputQuery.text.length >= 280 ? true : false
				}
				
				Rectangle {
					id: dragIcon
					Layout.fillWidth: true
					Layout.fillHeight: true
					color: "transparent"
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					radius: 3
					visible: false
					PlasmaComponents.Label {
						anchors.verticalCenter: parent.verticalCenter
						anchors.horizontalCenter: parent.horizontalCenter
						color: theme.viewTextColor
						text: i18nc("@info", "Drop your image or video")
					}
				}
				
				DropArea {
					id: dropArea;
					anchors.fill: parent;
					
					function inputToString(object) {
						var string = "";
						string = object.toString();
						return string;
					}
					
					onEntered: {
						inputQuery.placeholderText = "";
						dragIcon.visible = true;
					}
					
					onDropped: {
						inputQuery.placeholderText = i18nc("@info", "What's happening?");
						dragIcon.visible = false;
						
						if (drop.hasUrls) {
							var urls = inputToString(drop.urls);
							previewFadeIn.running = true;
							imgPreview.source = urls;
							filepath = urls;
						}
						drop.accepted = true;
					}
					
					onExited: {
						dragIcon.visible = false;
						inputQuery.placeholderText = i18nc("@info", "What's happening?");
					}
				}
			}
			
			Keys.onPressed: {
				if(event.key == Qt.Key_Escape) {
					plasmoid.expanded = false;
					inputQuery.text = "";
					event.accepted = true;
				} else if((event.modifiers & Qt.ControlModifier) && (event.key == Qt.Key_Return)) {
					sendTweetButton.clicked();
					event.accepted = true;
				}
			}
		}
		
		Rectangle {
			id: imgCanvas
			Layout.fillWidth: true
			height: (parent.height)/2
			visible: false
			color: theme.backgroundColor
			border.color: theme.disabledTextColor
			radius: 3
			
			Rectangle {
				id: mask
				width: parent.width
				height: parent.height
				radius: 3
				visible: false
			}
			
			AnimatedImage {
				id: imgPreview
				anchors.fill: parent
				fillMode: Image.PreserveAspectCrop
				smooth: true
				layer.enabled: true
				asynchronous: true
				playing: true
				layer.effect: OpacityMask {
					maskSource: mask
				}
				opacity: 0.75
				
				PlasmaComponents.Button {
					id: removeImg
					iconSource: "edit-delete-remove"
					tooltip: i18nc("@info", "Remove media")
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter
					onClicked: {
						fileDialog.close();
						filepath = "";
						previewFadeIn.running = false;
						previewFadeOut.running = true;
					}
				}
			}
			
			PropertyAnimation {
				id: previewFadeIn;
				target: imgCanvas;
				property: "visible";
				to: true;
				easing.type: Easing.InOutQuad;
				duration: 150;
				running: false
			}
			
			PropertyAnimation {
				id: previewFadeOut;
				target: imgCanvas;
				property: "visible";
				to: false;
				easing.type: Easing.InOutQuad;
				duration: 150;
				running: false
			}
		}
		
		RowLayout {
			id: bottomRowLayout
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignRight
			
			// TODO: Implement GIF browse/upload
			/*PlasmaComponents.Button {
				id: browseGifs
				iconSource: "image-gif"
				tooltip: i18nc("@info", "Add a GIF")
			}*/
			
			FileDialog {
				id: fileDialog
				title: i18nc("@title", "Select an image or video to upload")
				folder: shortcuts.home
				// selectMultiple: true
				nameFilters: [ i18nc("@info", "Media files (*.jpg *.png *.gif *.bmp *.mp4)"), "All files (*)" ]
				
				onAccepted: {
					previewFadeIn.running = true;
					imgPreview.source = fileDialog.fileUrl;
					filepath = fileDialog.fileUrl;
				}
				
				// TODO: Replace with a plasma dialog
				onRejected: {
					console.log("Cannot open selected file, try again.")
				}
			}
			
			// FIXME: Allow to upload multiple files or video
			PlasmaComponents.Button {
				id: selectImageButton
				iconSource: "viewimage"
				tooltip: i18nc("@info", "Add a picture or video")
				onClicked: fileDialog.open()
			}
			
			PlasmaComponents.Button {
				id: sendTweetButton
				text: i18nc("@info", "Tweet")
				tooltip: i18nc("@info", "Send Tweet")
				
				function validateContent() {
					var enableButton = false
					if(inputQuery.text.length <= 0 || inputQuery.text.length >= 280) {
						if(filepath == "") {
							enableButton = false
						} else {
							enableButton = true
						}
					} else {
						enableButton = true
					}
					return enableButton
				}
				enabled: validateContent()
				
				onClicked: {
					function tweet() {
						if(inputQuery.text == "") {
							var dummyMsg = " ";
							backend.send_tweet(
								dummyMsg,
								filepath,
								consumer_key,
								consumer_secret,
								user_secret,
								token_secret
							);
						} else {
							backend.send_tweet(
								inputQuery.text,
								filepath,
								consumer_key,
								consumer_secret,
								user_secret,
								token_secret
							);
						}
					}
					tweet();
					inputQuery.text = "";
					inputQuery.focus = false;
					filepath = "";
					previewFadeOut.running = true;
					imgPreview.source = "";
				}
			}
		}
	}
}
