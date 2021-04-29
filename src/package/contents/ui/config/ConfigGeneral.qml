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

import QtQuick 2.5
import QtQuick.Controls 2.5 as QtControls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.12 as Kirigami

Kirigami.FormLayout {
	id: generalConfigPage
	
	property alias cfg_consKey: consKey.text
	property alias cfg_consSec: consSec.text
	property alias cfg_accToken: accToken.text
	property alias cfg_accTokenSec: accTokenSec.text
	
	function configChanged() {
		root.cfg_consKey = plasmoid.readConfig("consKey")
		root.cfg_consSec = plasmoid.readConfig("consSec")
		root.cfg_accToken = plasmoid.readConfig("accToken")
		root.cfg_accTokenSec = plasmoid.readConfig("accTokenSec")
		plasmoid.backgroundHints = root.backgroundHints ? 1 : 0;
	}
	
	Item {
		Kirigami.FormData.isSection: true
		Kirigami.FormData.label: i18nc("@title:group", "Compact Mode") 
		visible: false
	}
	
	QtControls.TextField {
		id: consKey
		Kirigami.FormData.label: i18nc("@label", "Consumer API keys:")
		placeholderText: i18nc("@info", "Consumer Key")
		Layout.fillWidth: true
	}
	
	QtControls.TextField {
		id: consSec
		placeholderText: i18nc("@info", "Consumer Secret")
		Layout.fillWidth: true
	}
	
	QtControls.TextField {
		id: accToken
		Kirigami.FormData.label: i18nc("@label", "Access token & access token secret:")
		placeholderText: i18nc("@info", "Access Token")
		Layout.fillWidth: true
	}
	
	QtControls.TextField {
		id: accTokenSec
		placeholderText: i18nc("@info", "Access Token Secret")
		Layout.fillWidth: true
	}
	
	Kirigami.InlineMessage {
		Layout.fillWidth: true
		visible: true
		text: i18nc("@info", "Third-party clients have very limited access to Twitter with stricter rate limit and fewer features. It's recommended to use your own key. To do so, you first have to register a new application (if you don't already have one) <a href=\"https://apps.twitter.com\">here</a>.")
		onLinkActivated: Qt.openUrlExternally(link)
	}

}
