/***************************************************************************

	Copyright 2017 Gustavo Castro <gustawho@gmail.com>                         *

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
	along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

 ***************************************************************************/

// TODO:
// * Implement file upload (pictures and video) and OAuth login
// * Use KNotifications on events (unable to login, media upload, tweet update status)

#include <iostream>
#include <string>
using namespace std;

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "backend.h"

// TODO: Safely save/read keys (KWallet? KConfig? Ciphered file?)
BackEnd::BackEnd(QObject *parent) : QObject(parent) {
	// Given that OAuth login isn't implemented yet, you have to register your own app
	// and add the credentials here
	strConsumerKey       = "";
	strConsumerSecret    = "";
	strAccessTokenKey    = "";
	strAccessTokenSecret = "";
}

BackEnd::~BackEnd() {
}

int BackEnd::sendTweet(const QString &tweetTxt) {
	// twitcurl takes std::string, but QML returns QString, so a conversion is necessary
	string sysMsg;
	sysMsg = "";
	string utf8_text = tweetTxt.toUtf8().constData();
	if(utf8_text.size() > 280) {
		qDebug() << "ERROR: Tweet exceeds the character limit!";
	} else {
		BackEnd objMain;
		bool bRet = objMain.execMain(utf8_text);
		if (!bRet) cout << "ERROR!" << endl;
	}
	return 0;
}

bool BackEnd::execMain(string strString) {
	try {
		// Set Twitter consumer key and secret,
		//   OAuth access token key and secret
		twitterObj.getOAuth().setConsumerKey(strConsumerKey);
		twitterObj.getOAuth().setConsumerSecret(strConsumerSecret);
		twitterObj.getOAuth().setOAuthTokenKey(strAccessTokenKey);
		twitterObj.getOAuth().setOAuthTokenSecret(strAccessTokenSecret);
		
		// Verify account credentials
		if (!twitterObj.accountVerifyCredGet()) {
			twitterObj.getLastCurlError(strReplyMsg);
			cerr << "\ntwitCurl::accountVerifyCredGet error:\n"
			<< strReplyMsg.c_str() << endl;
			return false;
		}
		
		// Post a message
		strReplyMsg = "";
		if (!twitterObj.statusUpdate(strString)) {
			twitterObj.getLastCurlError(strReplyMsg);
			cerr << "\ntwitCurl::statusUpdate error:\n"
			<< strReplyMsg.c_str() << endl;
			return false;
		}
	} catch (char *e) {
		cerr << "[EXCEPTION] " << e << endl;
		return false;
	}
	emit tweetSent(); // FIXME
	return true;
}
