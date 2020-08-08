/*
 * 
 *	Copyright 2020 Gustavo Castro <gustawho@gmail.com>
 *	
 *	This file is part of Plastweet.
 * 
 *	Plastweet is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 * 
 *	Plastweet is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 * 
 *	You should have received a copy of the GNU General Public License
 *	along with Plastweet.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */

// TODO:
// * Add a progress bar for media upload
import QtQuick 2.11
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.12

import org.kde.draganddrop 2.0 as DragDrop

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

// C++ Backend
import org.kde.plastweet 1.0

Item {
	id: main
	readonly property string consumerKey: plasmoid.configuration.consKey
	readonly property string consumerSecret: plasmoid.configuration.consSec
	readonly property string accessToken: plasmoid.configuration.accToken
	readonly property string accessTokenSec: plasmoid.configuration.accTokenSec
	
	Plasmoid.compactRepresentation: DragDrop.DropArea {
		id: compactDropArea
		onDragEnter: activationTimer.restart()
		onDragLeave: activationTimer.stop()

		Timer {
			id: activationTimer
			interval: 250 // matches taskmanager delay
			onTriggered: plasmoid.expanded = true
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: plasmoid.expanded = !plasmoid.expanded

			PlasmaCore.IconItem {
				anchors.fill: parent
				source: "im-twitter"
				colorGroup: PlasmaCore.ColorScope.colorGroup
				active: parent.containsMouse
			}
		}
	}
	
	Plasmoid.fullRepresentation: ColumnLayout {
		id: fullRepresentation
		anchors.fill: parent
		
		Layout.minimumHeight: units.gridUnit * 10
		Layout.minimumWidth: units.gridUnit * 15
		
		property string filepath: ""
		property string tweetMsg: ""
		
		BackEnd {
			id: backend
		}
		
		PlasmaComponents.Highlight {
			id: delegateHighlight
			visible: false
			z: -1
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
				placeholderText: i18n("What's happening?")
				textColor: text.length >= 280 ? "red" : theme.viewTextColor
				Rectangle {
					id: dragIcon
					Layout.fillWidth: true
					Layout.fillHeight: true
					color: "transparent"
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					radius: 2
					visible: false
					PlasmaComponents.Label {
						anchors.verticalCenter: parent.verticalCenter
						anchors.horizontalCenter: parent.horizontalCenter
						color: theme.viewTextColor
						text: i18n("Drop your image or video")
					}
				}
				DropArea {
					id: dropArea;
					anchors.fill: topRowLayout;
					
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
						inputQuery.placeholderText = i18n("What's happening?");
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
						inputQuery.placeholderText = i18n("What's happening?");
					}
				}
				
				PlasmaComponents.Label {
					id: charCounter
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					anchors.rightMargin: 6
					text: inputQuery.text.length
					font.italic: true
					visible: inputQuery.text.length <= 0 ? false : true
					color: inputQuery.text.length >= 280 ? "red" : theme.viewTextColor
					font.bold: inputQuery.text.length >= 280 ? true : false
				}
			}
		}
		
		Rectangle {
			Layout.fillWidth: true
			height: (parent.height)/2
			id: imgCanvas
			visible: false
			color: theme.backgroundColor
			border.color: theme.viewBackgroundColor
			radius: 2
			
			Rectangle {
				id: mask
				width: parent.width
				height: width
				radius: 2
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
			}
			
			PlasmaComponents.Button {
					id: removeImg
					iconSource: "edit-delete-remove"
					tooltip: i18n("Remove media")
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
		
		RowLayout {
			id: bottomRowLayout
			Layout.alignment: Qt.AlignRight
			Layout.fillWidth: true
			
			// TODO: Implement GIF browse/upload
			/*PlasmaComponents.Button {
				id: browseGifs
				iconSource: "image-gif"
				tooltip: i18n("Add a GIF")
			}*/
			
			FileDialog {
				id: fileDialog
				title: "Select an image or video to upload"
				folder: shortcuts.home
				nameFilters: [ i18n("Media files(*.jpg *.png *.gif *.bmp *.mp4)"), "All files(*)" ]
				onAccepted: {
					previewFadeIn.running = true;
					imgPreview.source = fileDialog.fileUrl;
					filepath = fileDialog.fileUrl;
				}
				onRejected: {
					console.log("Cannot open selected file, try again.")
				}
			}
			
			// FIXME: Allow to upload multiple files or video
			PlasmaComponents.Button {
				id: selectImageButton
				iconSource: "viewimage"
				tooltip: i18n("Add a picture or video")
				onClicked: fileDialog.open()
			}
			
			PlasmaComponents.Button {
				id: sendTweetButton
				text: i18n("Tweet")
				tooltip: i18n("Send Tweet")
				
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
					function checkText() {
						var tweetMsg = ""
						if(inputQuery.text == "") {
							tweetMsg = " "
							backend.sendTweet(tweetMsg, filepath.toString(), consumerKey, consumerSecret, accessToken, accessTokenSec);
						} else {
							backend.sendTweet(inputQuery.text, filepath.toString(), consumerKey, consumerSecret, accessToken, accessTokenSec);
						}
					}
					checkText();
					filepath = "";
					inputQuery.text = "";
					inputQuery.focus = false;
					previewFadeOut.running = true;
					imgPreview.source = "";
				}
			}
		}
		
		PropertyAnimation {
			id: previewFadeIn;
			target: imgCanvas;
			property: "visible";
			to: true;
			easing.type: Easing.InOutQuad
			duration: 150;
			running: false;
		}
		
		PropertyAnimation {
			id: previewFadeOut;
			target: imgCanvas;
			property: "visible";
			to: false;
			easing.type: Easing.InOutQuad
			duration: 150;
			running: false;
		}
		
	}
}
