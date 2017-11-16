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
	along with Plastweet.  If not, see <http://www.gnu.org/licenses/>.

***************************************************************************/

// TODO:
// * Actually do what is supposed to!

import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0 as QtControls

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

ColumnLayout {
	id: notificationsConfigPage
	
	property alias cfg_mentionsBox: mentionsBox.checked
	property alias cfg_rtBox: rtBox.checked
	property alias cfg_likesBox: likesBox.checked
	property alias cfg_syncTimeSpinBox: syncTimeSpinBox.value
	
	GridLayout {
		id: notificationsGrid
		Layout.fillWidth: true
		columns: 2
		anchors.top: parent.top
		
		QtControls.CheckBox {
			id: mentionsBox
			Layout.row: 0
			Layout.column: 0
		}
		
		QtControls.Label {
			id: mentionsLbl
			Layout.row: 0
			Layout.column: 1
			Layout.alignment: Qt.AlignLeft
			text: i18n("Mentions and replies")
		}
		
		QtControls.CheckBox {
			id: rtBox
			Layout.row: 1
			Layout.column: 0
		}
		
		QtControls.Label {
			id: rtLbl
			Layout.row: 1
			Layout.column: 1
			Layout.alignment: Qt.AlignLeft
			text: i18n("Retweets")
		}
		
		QtControls.CheckBox {
			id: likesBox
			Layout.row: 2
			Layout.column: 0
		}
		
		QtControls.Label {
			id: likesLbl
			Layout.row: 2
			Layout.column: 1
			Layout.alignment: Qt.AlignLeft
			text: i18n("Likes")
		}
	}
	
	RowLayout {
		id: syncGrid
		Layout.fillWidth: true
		// anchors.top: FIXME
		
		QtControls.Label {
			id: syncTimeLabel
			Layout.alignment: Qt.AlignRight
			text: i18n("Sync interval:")
		}
		
		QtControls.SpinBox {
			id: syncTimeSpinBox
			minimumValue: 1
			suffix: i18n(" min")
		}
	}

}
