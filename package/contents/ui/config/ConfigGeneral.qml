/*
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
 */

import QtQuick 2.5
import QtQuick.Controls 2.5 as Controls
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami

Item {
	id: root
	
	property bool cfg_defaultCred
	property alias cfg_consKey: consKey.text
	property alias cfg_consSec: consSec.text
	property alias cfg_accToken: accToken.text
	property alias cfg_accTokenSec: accTokenSec.text
	
	function configChanged() {
		root.cfg_defaultCred = plasmoid.readConfig("defaultCred");
		root.cfg_consKey = plasmoid.readConfig("consKey")
		root.cfg_consSec = plasmoid.readConfig("consSec")
		root.cfg_accToken = plasmoid.readConfig("accToken")
		root.cfg_accTokenSec = plasmoid.readConfig("accTokenSec")
		plasmoid.backgroundHints = root.backgroundHints?1:0;
	}
	
	ColumnLayout {
		id: layout
		anchors.left: parent.left
		anchors.right: parent.right
		Controls.Label {
			text: i18n("Third-party clients have very limited access to Twitter with stricter rate limit and fewer features. It's recommended to use your own key. To do so, you first have to register a new application (if you don't already have one) <a href='https://apps.twitter.com'>here</a>.")
			onLinkActivated: Qt.openUrlExternally(link)
			wrapMode: Text.Wrap
			elide: Text.ElideLeft
			Layout.fillWidth: true
		}
		/* Controls.RadioButton {
			id: defaultCred
			Layout.fillWidth: true
			text: qsTr("Use default credentials")
			onCheckedChanged: if (checked) cfg_defaultCred = 0
		}
		Controls.RadioButton {
			id: customCred
			Layout.fillWidth: true
			text: qsTr("Use custom credentials")
			onCheckedChanged: if (checked) cfg_defaultCred = 1
		}
		 */
		ColumnLayout {
			id: consKeys
			Controls.Label { text: qsTr("Consumer API keys:") }
			// visible: customCred.checked
			Controls.TextField {
				id: consKey
				placeholderText: qsTr("Consumer Key")
				font.family: 'monospace'
			}
			Controls.TextField {
				id: consSec
				placeholderText: qsTr("Consumer Secret")
				font.family: 'monospace'
			}
		}
		ColumnLayout {
			id: accessData
			Controls.Label { text: qsTr("Access token & access token secret:") }
			Controls.TextField {
				id: accToken
				placeholderText: qsTr("Access Token")
				echoMode: TextInput.PasswordEchoOnEdit
				font.family: 'monospace'
			}
			Controls.TextField {
				id: accTokenSec
				placeholderText: qsTr("Access Token Secret")
				echoMode: TextInput.PasswordEchoOnEdit
				font.family: 'monospace'
			}
		}
	}
}
