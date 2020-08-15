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
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Item {
	id: root
	width: childrenRect.width
	height: childrenRect.height
	
	property alias cfg_consKey: consKey.text
	property alias cfg_consSec: consSec.text
	property alias cfg_accToken: accToken.text
	property alias cfg_accTokenSec: accTokenSec.text
	property alias cfg_iconThemeLight: lightTheme.checked
	property alias cfg_iconThemeDark: darkTheme.checked

	
	function configChanged() {
		root.cfg_consKey = plasmoid.readConfig("consKey")
		root.cfg_consSec = plasmoid.readConfig("consSec")
		root.cfg_accToken = plasmoid.readConfig("accToken")
		root.cfg_accTokenSec = plasmoid.readConfig("accTokenSec")
		plasmoid.backgroundHints = root.backgroundHints ? 1 : 0;
	}
	
	Kirigami.FormLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		
		Label {
			text: i18n("Third-party clients have very limited access to Twitter with stricter rate limit and fewer features. It's recommended to use your own key. To do so, you first have to register a new application (if you don't already have one) <a href='https://apps.twitter.com'>here</a>.")
			onLinkActivated: Qt.openUrlExternally(link)
			wrapMode: Text.Wrap
			elide: Text.ElideLeft
			Layout.fillWidth: true
		}
		
		TextField {
			id: consKey
			Kirigami.FormData.label: i18n ("Consumer API keys:")
			placeholderText: i18n("Consumer Key")
			Layout.fillWidth: true
		}
		TextField {
			id: consSec
			placeholderText: i18n("Consumer Secret")
			Layout.fillWidth: true
		}
		TextField {
			id: accToken
			Kirigami.FormData.label: i18n ("Access token & access token secret:")
			placeholderText: i18n("Access Token")
			Layout.fillWidth: true
		}
		TextField {
			id: accTokenSec
			placeholderText: i18n("Access Token Secret")
			Layout.fillWidth: true
		}

		RadioButton {
			id: lightTheme
			Kirigami.FormData.label: i18n("Tray icon theme:")
			text: i18n("Light")
		}
		RadioButton {
			id: darkTheme
			text: i18n("Dark")
		}
	}
}
