/***************************************************************************
	Copyright 2017 Gustavo Castro <gustawho@gmail.com>
	
	This file is part of Plastweet.

	Foobar is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Foobar is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
***************************************************************************/

// TODO:
// * Add a progressbar that informs about media upload
// * Media preview interface
// * Clear TextArea content if tweet is sent

import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
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
	
	property string tweetMsg: plasmoid.nativeInterface.strString
	
	BackEnd {
		id: backend
	}
	
	RowLayout {
		id: topRowLayout
		z: 1
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.left: parent.left
		Layout.fillWidth: true
		Layout.fillHeight: false

		PlasmaComponents.TextArea {
			id: inputQuery
			implicitHeight: parent.minimumHeight
			implicitWidth: parent.minimumHeight
			wrapMode: TextEdit.Wrap
			anchors.top: parent.top
			anchors.left: parent.left
			Layout.fillWidth: true
			focus: true
			placeholderText: i18n("What's happening?")
			textColor: text.length >= 280 ? "red" : theme.viewTextColor
			PlasmaComponents.Label {
				id: charCounter
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.rightMargin: 8
				text: inputQuery.text.length
				font.italic: true
				visible: inputQuery.text.length <= 0 ? false : true
				color: inputQuery.text.length >= 280 ? "red" : "grey"
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
		
		// TODO: Implement picture/video upload
		PlasmaComponents.Button {
			id: selectImageButton
			iconSource: "viewimage"
			tooltip: i18n("Add photos or video")
		}

		PlasmaComponents.Button {
			id: sendTweetButton
			iconSource: "im-twitter"
			tooltip: i18n("Tweet")
			enabled: (inputQuery.text.length <= 0 || inputQuery.text.length >= 280) ? false : true
			onClicked: { // FIXME
				print(inputQuery.text);
				tweetMsg = inputQuery.text;	// Test
				print(tweetMsg)				//
				plasmoid.nativeInterface.SendTweet(tweetMsg);
			}
		}
	}

	PlasmaComponents.ToolButton {
		id: keepOpen
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		width: Math.round(units.gridUnit * 1.25)
		height: width
		checkable: true
		iconSource: "window-pin"
		visible: main.fromCompact
		onCheckedChanged: plasmoid.hideOnWindowDeactivate = !checked
	}
}
