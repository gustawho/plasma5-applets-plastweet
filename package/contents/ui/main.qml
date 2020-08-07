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

import "../code/twitter.js" as Twitter;

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
						text: i18n("Drop an image or video")
					}
				}
				DropArea {
					id: dropArea;
					anchors.fill: topRowLayout;
					
					function inputToString(object) {
						var string = object.toString();
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
				cache: true
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
			*				id: browseGifs
			*				iconSource: "image-gif"
			*				tooltip: i18n("Add a GIF")
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
			// FIXME: Adjust to new backend
			PlasmaComponents.Button {
				id: selectImageButton
				iconSource: "viewimage"
				tooltip: i18n("Add an image or video")
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
				
				function sendTweet(t) {
					const client = new Twitter.Twitter({
						consumer_key: consumerKey,
						consumer_secret: consumerSecret,
						access_token_key: accessToken,
						access_token_secret: accessTokenSec
					});
					
					const tweet = client.post("statuses/update", {
						status: t
					});
				}
				
				function sendMediaTweet(t, m) { // FIXME
					const client = new Twitter.Twitter({
						consumer_key: consumerKey,
						consumer_secret: consumerSecret,
						access_token_key: accessToken,
						access_token_secret: accessTokenSec
					});
					var xhr = new XMLHttpRequest();
					xhr.open('GET', m);
					xhr.responseType = 'arraybuffer';
					xhr.onreadystatechange = function() {
						if (xhr.readyState === XMLHttpRequest.DONE) {
							var response = new Uint8Array(xhr.response);
							var raw = "";
							for (var i = 0; i < response.byteLength; i++) {
								raw += String.fromCharCode(response[i]);
							}
							//FROM https://cdnjs.cloudflare.com/ajax/libs/Base64/1.0.1/base64.js
							function base64Encode (input) {
								var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
								var str = String(input);
								for (var block, charCode, idx = 0, map = chars, output = '';
									str.charAt(idx | 0) || (map = '=', idx % 1);
									output += map.charAt(63 & block >> 8 - idx % 1 * 8)
									) {
									charCode = str.charCodeAt(idx += 3/4);
									if (charCode > 0xFF) {
										throw new Error("Base64 encoding failed: The string to be encoded contains characters outside of the Latin1 range.");
									}
									block = block << 8 | charCode;
								}
								return output;
							}
							var base64Image = base64Encode(raw);
							
							// Upload picture
							const mediaUploadResponse = client.post('media/upload', {
								media_data: base64Image,
							});
							
							// FIXME: after successfully making the post request,
							//        needs to wait for the response and read it,
							//        get the media_id_string value and save it
							//        async doesn't exist in QML, use WorkerScript

							// Set alt text
							client.post('media/metadata/create', {
								media_id: mediaUploadResponse.media_id_string,
								alt_text: { text: t },
							});
						}
					}
					xhr.send();
				}
				
				onClicked: {
					function checkTweet() {
						if(filepath === "") {
							sendTweet(inputQuery.text);
						} else {
							if(inputQuery === "") {
								var tweetMsg = " ";
								sendMediaTweet(tweetMsg, filepath.toString());
							} else {
								sendMediaTweet(inputQuery.text, filepath.toString());
							}
						}
					}
					// sendTweet(inputQuery.text);
					checkTweet();
					inputQuery.text = "";
					inputQuery.focus = false;
					previewFadeOut.running = true;
					imgPreview.source = "";
					filepath = "";
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
