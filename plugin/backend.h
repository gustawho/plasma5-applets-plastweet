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
// * Get rid of all the Q_INVOKABLE macros and instead use Q_PROPERTY

#ifndef BACKEND_H
#define BACKEND_H

#include <string>
#include <iostream>
using namespace std;

#include <QObject>

#include "twitcurl.h"

class BackEnd : public QObject {
	Q_OBJECT
public:
	explicit BackEnd(QObject *parent = 0);
	~BackEnd();
	
	Q_INVOKABLE QString originalStr;
	Q_INVOKABLE QString mediaPath;
	Q_INVOKABLE int mediaCheck;
	Q_INVOKABLE string strString;
	bool execMain(string strString, string strFilePath, string ck, string cs, string ak, string tk);
	Q_INVOKABLE int sendTweet(const QString &tweetTxt, const QString &tweetImg, const QString &consKey, const QString &consSec, const QString &accToken, const QString &accTokenKey);
signals:
	// Q_INVOKABLE void tweetSent();
private:
	twitCurl twitterObj;
	string strConsumerKey;
	string strConsumerSecret;
	string strAccessTokenKey;
	string strAccessTokenSecret;
	string strReplyMsg;
};

#endif
