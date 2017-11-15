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
// * Change the elements to use OAuth login
// * Show username and avatar of logged account

import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0 as QtControls

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

ColumnLayout {
	id: generalConfigPage
	
	GridLayout {
		id: authSection
		Layout.fillWidth: true
		columns: 2
		anchors.top: parent.top
		
		QtControls.Label {
			Layout.row: 0
			Layout.column: 0
			font.bold: true
			text: i18n("Twitter API")
		}
		
		QtControls.Label {
			Layout.row: 1
			Layout.column: 1
			Layout.fillWidth: true
			wrapMode: Text.Wrap
			elide: Text.ElideLeft
			text: i18n("Third party clients have very limited access to Twitter with stricter rate limit, fewer features, and token limit. It's recommended to use your own key. You first have to register a new application (if you don't already have one) <a href='https://apps.twitter.com'>here</a>.")
			onLinkActivated: Qt.openUrlExternally(link)
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
		
		QtControls.Label {
			id: lblToken
			Layout.row: 4
			Layout.column: 0
			Layout.alignment: Qt.AlignRight
			text: i18n("Access Token:")
		}
		
		QtControls.TextField {
			id: txtToken
			Layout.row: 4
			Layout.column: 1
			implicitWidth: 380
		}
		
		QtControls.Label {
			id: lblTokenSecret
			Layout.row: 5
			Layout.column: 0
			Layout.alignment: Qt.AlignRight
			text: i18n("Access Token Secret:")
		}
		
		QtControls.TextField {
			id: txtTokenSecret
			Layout.row: 5
			Layout.column: 1
			implicitWidth: 380
		}
	}

}
