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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami

Item {
	id: root
	width: childrenRect.width
	height: childrenRect.height
	
	property alias cfg_consKey: consKey.text
	property alias cfg_consSec: consSec.text
	property alias cfg_accToken: accToken.text
	
	Kirigami.FormLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		
		ColumnLayout {
			Layout.rowSpan: 3
			RadioButton {
				id: mentionReply
				text: i18n("Mentions and replies")
			}
			RadioButton {
				id: retweets
				text: i18n("Retweets")
			}
			RadioButton {
				id: likes
				text: i18n("Likes")
			}
		}
	}
}
