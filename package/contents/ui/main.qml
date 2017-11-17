/***************************************************************************

	Copyright 2017 Gustavo Castro <gustawho@gmail.com>
	
	This file is part of Plastweet.

	Plastweet is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Plastweet is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Plastweet.  If not, see <http://www.gnu.org/licenses/>.

***************************************************************************/

// TODO:
// * Add a progressbar that informs about media upload

import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import com.gustawho.plastweet 1.0

Item {
	id: fullRepresentation
	anchors.fill: parent
	Layout.minimumHeight: units.gridUnit * 10
	Layout.minimumWidth: units.gridUnit * 15
	Layout.maximumHeight: units.gridUnit * 10
	Layout.preferredWidth: units.gridUnit * 15
	
	property string filepath: ""
	property string tweetMsg: ""

	BackEnd {
		id: backend
	}

	RowLayout {
		id: topRowLayout
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.left: parent.left
		Layout.fillWidth: true

		PlasmaComponents.TextArea {
			id: inputQuery
			implicitHeight: parent.minimumHeight
			implicitWidth: parent.minimumWidth
			wrapMode: TextEdit.Wrap
			anchors.top: parent.top
			anchors.left: parent.left
			Layout.fillWidth: true
			placeholderText: i18n("What's happening?")
			textColor: text.length >= 280 ? "red" : theme.viewTextColor
			Rectangle {
				id: dragIcon
				width: 110
				height: 100
				color: "transparent"
				border.color: theme.viewTextColor
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				border.width: 1
				radius: 2
				visible: false
				PlasmaComponents.Label {
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					color: theme.viewTextColor
					text: i18n("Drop your image")
				}
			}
			DropArea {
				id: dropArea;
				anchors.fill: parent;
				onEntered: {
					inputQuery.placeholderText = "";
					dragIcon.visible = true;
				}
				onDropped: {
					inputQuery.placeholderText = i18n("What's happening?");
					dragIcon.visible = false;
					imgPreview.source = drag.source; // FIXME
					filepath = drag.source;
					changeSizeAnimation.running = true;
					previewFadeIn.running = true;
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

	RowLayout {
		id: bottomRowLayout
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		Layout.fillWidth: true
		Layout.fillHeight: true
		
		// TODO: Implement GIF browse/upload
		PlasmaComponents.Button {
			id: browseGifs
			iconSource: "image-gif"
			tooltip: i18n("Add a GIF")
		}
		
		FileDialog {
			id: fileDialog
			title: "Select an image to upload"
			folder: shortcuts.pictures
			nameFilters: [ "Image files (*.jpg *.png *.gif *.bmp)", "All files (*)" ]
			onAccepted: {
				changeSizeAnimation.running = true;
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
			tooltip: i18n("Add a picture")
			onClicked: fileDialog.open()
		}

		PlasmaComponents.Button {
			id: sendTweetButton
			iconSource: "im-twitter"
			tooltip: i18n("Tweet")
			
			// enabled: (inputQuery.text.length <= 0 || inputQuery.text.length >= 280) ? false : true
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
						backend.sendTweet(tweetMsg, filepath.toString());
					} else {
						backend.sendTweet(inputQuery.text, filepath.toString());
					}
				}
				checkText();
				filepath = "";
				inputQuery.text = "";
				inputQuery.focus = false;
				previewFadeOut.running = true;
				restoreSize.running = true;
				imgPreview.source = "";
			}
		}
	}
	
	PlasmaComponents.ToolButton {
		id: keepOpen
		anchors.right: parent.right
		anchors.top: parent.top
		width: Math.round(units.gridUnit * 1.25)
		height: width
		checkable: true
		iconSource: "window-pin"
		visible: main.fromCompact
		onCheckedChanged: plasmoid.hideOnWindowDeactivate = !checked
	}
	
	PropertyAnimation {
		id: changeSizeAnimation;
		target: parent;
		properties: "Layout.minimumHeight,Layout.maximumHeight";
		to: (units.gridUnit * 10) + 36;
		duration: 50;
	}
	
	PropertyAnimation {
		id: restoreSize;
		target: parent;
		properties: "Layout.minimumHeight,Layout.maximumHeight";
		to: units.gridUnit * 10;
		duration: 150;
	}
	
	PropertyAnimation {
		id: previewFadeIn;
		target: imgPreview;
		property: "visible";
		to: true;
		duration: 150;
		running: false;
	}
	
	PropertyAnimation {
		id: previewFadeOut;
		target: imgPreview;
		property: "visible";
		to: false;
		duration: 50;
		running: false;
	}
	
	Item {
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.leftMargin: 2
		width: 64
		height: width
		
		Rectangle {
			id: mask
			width: parent.width
			height: width
			radius: 2
			visible: false
		}
		
		Image {
			id: imgPreview
			Layout.fillWidth: true
			anchors.fill: parent
			fillMode: Image.PreserveAspectCrop
			smooth: true
			visible: false
			layer.enabled: true
			asynchronous: true
			layer.effect: OpacityMask {
				maskSource: mask
			}
			PlasmaComponents.ToolButton {
				id: removeImg
				iconSource: "remove"
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
				onClicked: {
					fileDialog.close();
					filepath = "";
					previewFadeOut.running = true;
					restoreSize.running = true;
				}
			}
		}
	}
}
