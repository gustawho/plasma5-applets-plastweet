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
// * Actually do what is supposed to!
// * Show username and avatar of logged account

import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0 as QtControls
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import com.gustawho.plastweet 1.0

ColumnLayout {
	id: generalConfigPage
	
	// FIXME: This was set to test the save/apply function
	property alias cfg_txtConsKey: txtConsKey.text
	property alias cfg_txtConsSecret: txtConsSecret.text

	BackEnd {
		id: backend
	}
	
	GridLayout {
		id: authSection
		Layout.fillWidth: true
		columns: 2
		flow: GridLayout.TopToBottom
		anchors.fill: parent

		QtControls.Label {
			Layout.row: 0
			Layout.column: 0
			font.bold: true
			text: i18n("API Settings")
		}

		QtControls.Label {
			Layout.row: 1
			Layout.column: 1
			Layout.fillWidth: true
			wrapMode: Text.Wrap
			elide: Text.ElideLeft
			rightPadding: 22
			linkColor: theme.linkColor
			text: i18n("Third party clients have very limited access to Twitter with stricter rate limit, fewer features, and token limit. It's recommended to use your own key. You first have to register a new application (if you don't already have one) <a href='https://apps.twitter.com'>here</a>.")
			onLinkActivated: Qt.openUrlExternally(link)
			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
			}
		}

		QtControls.Label {
			id: lblConsKey
			Layout.row: 2
			Layout.column: 0
			Layout.alignment: Qt.AlignRight
			text: i18n("Consumer Key (API Key):")
		}

		QtControls.TextField {
			id: txtConsKey
			Layout.row: 2
			Layout.column: 1
			implicitWidth: 380
		}

		QtControls.Label {
			id: lblConsSecret
			Layout.row: 3
			Layout.column: 0
			Layout.alignment: Qt.AlignRight
			text: i18n("Consumer Secret (API Secret):")
		}

		QtControls.TextField {
			id: txtConsSecret
			Layout.row: 3
			Layout.column: 1
			implicitWidth: 380
		}

		Rectangle {
			Layout.row: 5
			Layout.column: 0
			height: 48
			color: "transparent"
		}

		QtControls.Label {
			Layout.row: 6
			Layout.column: 0
			font.bold: true
			text: i18n("Login")
		}
		
		QtControls.Button {
			id: tokenBtn
			Layout.row: 7
			Layout.column: 0
			text: i18n("Generate token")
			onClicked: {
				pinUrl.text = backend.AuthLink; // FIXME
			}
		}
		
		QtControls.Label {
			id: pinUrl
			Layout.row: 8
			Layout.column: 0
			linkColor: theme.linkColor
			onLinkActivated: Qt.openUrlExternally(link)
			MouseArea  {
				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
			}
		}
		
		QtControls.TextField {
			id: pinTextField
			Layout.row: 9
			Layout.column: 0
			implicitWidth: tokenBtn.width
			validator: RegExpValidator { regExp: /^[0-9]{7}$/ }
			placeholderText: "0000000"
			maximumLength: 7
			font.pointSize: 14
			font.family: "Hack" // FIXME: set a standard value
			horizontalAlignment: TextInput.AlignHCenter
		}
		
		QtControls.Button {
			id: loginBtn
			Layout.row: 10
			Layout.column: 0
			implicitWidth: userField.width
			text: i18n("Login")
		}
		
		RowLayout {
			Layout.row: 7
			Layout.column: 1
			Layout.rowSpan: 4
			
			QtControls.Label {
				anchors.verticalCenter: parent.verticalCenter
				text: "Logged in as: "
			}
			
			Item {
				anchors.verticalCenter: parent.verticalCenter
				width: 48
				height: width
				
				Rectangle {
					id: mask
					width: parent.width
					height: width
					radius: 50
					visible: false
				}
				
				Image {
					id: avatar
					anchors.fill: parent
					sourceSize.width: parent.width
					sourceSize.height: parent.width
					fillMode: Image.Stretch
					source: "https://twitter.com/" + username.text +"/profile_image?size=original"
					layer.enabled: true
					layer.effect: OpacityMask {
						maskSource: mask
					}
				}
			}
			
			// FIXME: Get username when logged in
			QtControls.Label {
				anchors.verticalCenter: parent.verticalCenter
				id: username
				text: "gustawho"
			}
		}
	}
	
}
