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

import QtQuick 2.2
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.1

Item {
	id: root
	signal configurationChanged
	
	function saveConfig() {
		var names = []
		for(var i in layout.children) {
			var cur = layout.children[i]
			if (cur.checked)
				names.push(cur.name)
		}
		plasmoid.configuration.key = names
	}
	
	ColumnLayout {
		id: layout
		Controls.CheckBox {
			Layout.fillWidth: true
			readonly property string name: "Mentions and replies"
			checked: plasmoid.configuration.key.indexOf(name) >= 0
			text: i18n("Mentions and replies")
			onCheckedChanged: root.configurationChanged()
		}
		Controls.CheckBox {
			Layout.fillWidth: true
			readonly property string name: "Retweets"
			checked: plasmoid.configuration.key.indexOf(name) >= 0
			text: i18n("Retweets and likes")
			onCheckedChanged: root.configurationChanged()
		}
	}
}
