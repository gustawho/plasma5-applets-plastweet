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

// TODO: Add the Notifications GUI

import QtQuick 2.3
import org.kde.plasma.configuration 2.0

import "../ui" as UI

ConfigModel {
	ConfigCategory {
		name: i18n('General')
		icon: 'preferences-other'
		source: 'config/ConfigGeneral.qml'
	}
	
	ConfigCategory {
		name: i18n('Notifications')
		icon: 'preferences-desktop-notification'
		source: 'config/ConfigNotifications.qml'
	}
}
