/***************************************************************************

	Copyright 2017 Gustavo Castro <gustawho@gmail.com>

	This file is part of Plastweet.
	* 
	Foobar is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	* 
	Foobar is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	* 
	You should have received a copy of the GNU General Public License
	along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

***************************************************************************/

#ifndef BACKEND_H
#define BACKEND_H

#include <string>
#include <iostream>
#include <twitcurl.h>
using namespace std;

#include <QObject>
#include <QDebug>

class BackEnd : public QObject {
	Q_OBJECT
	Q_PROPERTY(QString originalStr READ originalStr WRITE sendTweet NOTIFY tweetSent)
public:
	explicit BackEnd(QObject *parent = 0);
	~BackEnd();
	QString originalStr;
	string strString;
	bool execMain(string strString);
	void sendTweet(QString originalStr);
signals:
	void tweetSent();
private:
	twitCurl twitterObj;
	string strConsumerKey;
	string strConsumerSecret;
	string strAccessTokenKey;
	string strAccessTokenSecret;
	string strReplyMsg;
};

#endif
