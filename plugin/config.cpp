#include <stddef.h>  // defines NULL
#include "config.h"

Config::Config() {

	QString writableLocation = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
	m_filesPath = writableLocation;
}

Config& Config::instance() {
	static Config instance;
	return instance;
}

QString Config::getFilesPath() {
	return m_filesPath;
}
