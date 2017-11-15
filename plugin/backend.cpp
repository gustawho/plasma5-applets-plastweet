/***************************************************************************
 * 
 *	Copyright 2017 Gustavo Castro <gustawho@gmail.com>                         *
 * 
 *	This file is part of Plastweet.
 * 
 *	Plastweet is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 * 
 *	Plastweet is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 * 
 *	You should have received a copy of the GNU General Public License
 *	along with Plastweet.  If not, see <http://www.gnu.org/licenses/>.
 * 
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

int BackEnd::sendTweet(const QString &tweetTxt, const QString &tweetImg) {
	// twitcurl takes std::string, but QML returns QString, so a conversion is necessary
	string utf8_text = tweetTxt.toUtf8().constData();
	string utf8_path_tmp = tweetImg.toUtf8().constData();
	string utf8_path;
	if(utf8_path_tmp.empty()) {
		utf8_path = "";
	} else {
		utf8_path = utf8_path_tmp.substr(7);
	}
	cout << "File path: " << utf8_path << endl;
	if(utf8_text.size() > 280) {
		qDebug() << "ERROR: Tweet exceeds the character limit!";
	} else {
		BackEnd objMain;
		bool bRet = objMain.execMain(utf8_text, utf8_path);
		if (!bRet) qDebug() << "ERROR getting tweet message!";
	}
	return 0;
}

bool BackEnd::execMain(string strString, string strFilePath) {
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
			cerr << "\nERROR verifying account:\n"
			<< strReplyMsg.c_str() << endl;
			return false;
		}
		
		if(strFilePath.empty()) {
			// Post a message
			strReplyMsg = "";
			if (!twitterObj.statusUpdate(strString)) {
				twitterObj.getLastCurlError(strReplyMsg);
				cerr << "\nERROR sending tweet:\n"
				<< strReplyMsg.c_str() << endl;
				return false;
			}
		} else {
			// Post a message + media
			bool result = twitterObj.uploadMedia(strFilePath);
			if(result) {
				string response = "";
				twitterObj.getLastWebResponse(response);
				string::size_type start = 12;
				string::size_type length = 18;
				string* sub = new string[1] {response.substr(start,length)};
				if (!twitterObj.statusUpdateWithMedia(string(strString), sub, 1)) {
					cerr << "\nERROR sending tweet with media:\n"
					<< strReplyMsg.c_str() << endl;
				}
			} else {
				qDebug() << "ERROR uploading media";
			}
		}
	} catch (char *e) {
		cerr << "[EXCEPTION] " << e << endl;
		return false;
	}
	emit tweetSent(); // FIXME
	return true;
}
