/*
 * 
 *	Copyright 2020 Gustavo Castro <gustawho@gmail.com>
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
 */

// TODO:
// * Implement multi-upload (pictures and video) and OAuth login
// * Use KNotifications on events (unable to login, media upload, tweet update status)
// * A background service

#include <iostream>
#include <string>

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend.h"

using namespace std;

// TODO: Safely save/read keys (KWallet? KConfig? Ciphered file?)

BackEnd::BackEnd(QObject *parent) : QObject(parent) {
}

BackEnd::~BackEnd() {
}


int BackEnd::sendTweet(const QString &tweetTxt, const QString &tweetImg, const QString &consKey, const QString &consSec, const QString &accToken, const QString &accTokenKey) {
	// twitcurl takes std::string, but QML returns QString, so a conversion is necessary
	string utf8_text = tweetTxt.toUtf8().constData();
	string utf8_path_tmp = tweetImg.toUtf8().constData();
	string utf8_path;
	string tmpCK = consKey.toUtf8().constData();
	string tmpCS = consSec.toUtf8().constData();
	string tmpAK = accToken.toUtf8().constData();
	string tmpTK = accTokenKey.toUtf8().constData();
	if(utf8_path_tmp.empty()) {
		utf8_path = "";
	} else {
		utf8_path = utf8_path_tmp.substr(7);;
	}
	if(utf8_text.size() > 280) {
		cout << "(!!) Status exceeds the character limit" << endl;
	} else {
		BackEnd objMain;
		bool bRet = objMain.execMain(utf8_text, utf8_path, tmpCK, tmpCS, tmpAK, tmpTK);
		if (!bRet) cout << "(!!) Error getting tweet message" << endl;
	}
	return 0;
}

bool BackEnd::execMain(string strString, string strFilePath, string ck, string cs, string ak, string tk) {
	try {
		// Set Twitter consumer key and secret,
		//   OAuth access token key and secret
		twitterObj.getOAuth().setConsumerKey(ck);
		twitterObj.getOAuth().setConsumerSecret(cs);
		twitterObj.getOAuth().setOAuthTokenKey(ak);
		twitterObj.getOAuth().setOAuthTokenSecret(tk);

		// Verify account credentials
		if (!twitterObj.accountVerifyCredGet()) {
			twitterObj.getLastCurlError(strReplyMsg);
			cout << strReplyMsg << endl;
			return false;
		}
		
		if(strFilePath.empty()) {
			// Post a message
			strReplyMsg = "";
			if (twitterObj.statusUpdate(strString)) {
				twitterObj.getLastWebResponse(strReplyMsg);
				cout << strReplyMsg << endl;
			} else {
				twitterObj.getLastCurlError(strReplyMsg);
				cout << strReplyMsg << endl;
				return false;
			}
		} else {
			// Post a message + media
			bool result = twitterObj.uploadMedia(strFilePath);
			if(result) {
				string response = "";
				twitterObj.getLastWebResponse(response);
				cout << "Response: " << response << endl;
				string::size_type start = 12;
				string::size_type length = 19;
				string* sub = new string[1] {response.substr(start,length)};
				cout << "Media ID: " << sub << endl;
				if (twitterObj.statusUpdateWithMedia(string(strString), sub, 1)) {
					twitterObj.getLastWebResponse(response);
					cout << response << endl;
				} else {
					twitterObj.getLastCurlError(response);
					cout << response << endl;
				}
			} else {
				cout << "(!!) Error uploading media: " << strReplyMsg << endl;
			}
		}
	} catch (char *e) {
		cout << "[EXCEPTION] " << e << endl;
		return false;
	}
	// emit tweetSent(); // FIXME
	return true;
}
