#ifndef CONFIG_H
#define CONFIG_H 

#include <cstdlib>
#include <iostream>
#include <QString>
#include <QStandardPaths>

using namespace std;

class Config {
public:
	static Config& instance();
	QString getFilesPath();
private:
	Config();
	Config(const Config & c);
	Config & operator=(const Config & c);
	static const QString FILES_PATH;
	QString m_filesPath;
};

#endif
