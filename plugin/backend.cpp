/***************************************************************************
 * 
 *	Copyright 2017 Gustavo Castro <gustawho@gmail.com>
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
// * Implement multi-upload (pictures and video) and OAuth login
// * Use KNotifications on events (unable to login, media upload, tweet update status)
// * A background service

#include <iostream>
#include <string>
using namespace std;

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
// #include <QDir>
// #include <QStandardPaths>

#include "backend.h"

// TODO: Safely save/read keys (KWallet? KConfig? Ciphered file?)
BackEnd::BackEnd(QObject *parent) : QObject(parent) {
	// Given that OAuth login isn't implemented yet, you have to register your own app
	// and add the credentials here
// 	string appData = "/plastweet/config/";
// 	QString qAppData = QString::fromStdString(appData);
// 	QString writableLocation = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
// 	QDir().mkpath(writableLocation.append(qAppData));
// 	
// 	string configDir = writableLocation.toUtf8().constData();
// 		
// 	myConsumerKey = configDir.append(appData).append("consumerKey.txt");
// 	myConsumerSecret = configDir.append(appData).append("consumerSecret.txt");
// 	myTokenKeyFile = configDir.append(appData).append("tokenKey.txt");
// 	myTokenSecretFile = configDir.append(appData).append("tokenSecret.txt");
// 	
// 	ifstream getTokenKey(myTokenKeyFile);
// 	ifstream getTokenSecret(myTokenSecretFile);
// 	
// 	stringstream streamKey;
// 	stringstream streamSecret;
// 	
// 	streamKey << getTokenKey.rdbuf();
// 	streamSecret << getTokenSecret.rdbuf();
// 	
// 	string keyStr = streamKey.str();
// 	string secretStr = streamSecret.str();

	strConsumerKey       = "";
	strConsumerSecret    = "";
	strAccessTokenKey    = "";
	strAccessTokenSecret = "";
}

BackEnd::~BackEnd() {
}

// OAuth login
// int BackEnd::getAuthLink(const QString &username, const QString &password) {
// 	twitCurl twitterObj;
// 	
// 	string utf8_user = username.toUtf8().constData();
// 	string utf8_pass = password.toUtf8().constData();
// 	
// 	twitterObj.setTwitterUsername( utf8_user );
// 	twitterObj.setTwitterUsername( utf8_pass );
// 
// 	// Read pre-set consumer credentials
// 	twitterObj.getOAuth().setConsumerKey(strConsumerKey);
// 	twitterObj.getOAuth().setConsumerSecret(strConsumerSecret);
// 	
// 	// Set token files
// 	string myOAuthAccessTokenKey = "";
// 	string myOAuthAccessTokenSecret = "";
// 	ifstream newTokenKeyFile;
// 	ifstream newTokenSecretFile;
// 	
// 	newTokenKeyFile.open(myTokenKeyFile);
// 	newTokenSecretFile.open(myTokenSecretFile);
// 	
// 	char tmpBuf[1024];
// 	
// 	memset( tmpBuf, 0, 1024 );
// 	newTokenKeyFile >> tmpBuf;
// 	myOAuthAccessTokenKey = tmpBuf;
// 	
// 	memset( tmpBuf, 0, 1024 );
// 	newTokenSecretFile >> tmpBuf;
// 	myOAuthAccessTokenSecret = tmpBuf;
// 	
// 	newTokenKeyFile.close();
// 	newTokenSecretFile.close();
// 	
// 	// Check if files are empty
// 	if( myOAuthAccessTokenKey.size() && myOAuthAccessTokenSecret.size() ) {
// 		printf( "\nUsing:\nKey: %s\nSecret: %s\n\n", myOAuthAccessTokenKey.c_str(), myOAuthAccessTokenSecret.c_str() );
// 		twitterObj.getOAuth().setOAuthTokenKey( myOAuthAccessTokenKey );
// 		twitterObj.getOAuth().setOAuthTokenKey( myOAuthAccessTokenKey );
// 	} else {
// 		string authUrl;
// 		twitterObj.oAuthRequestToken(authUrl);
// 		twitterObj.oAuthHandlePIN(authUrl);
// 		twitterObj.oAuthAccessToken();
// 		twitterObj.getOAuth().getOAuthTokenKey( myOAuthAccessTokenKey );
// 		twitterObj.getOAuth().getOAuthTokenSecret( myOAuthAccessTokenSecret );
// 		
// 		ofstream saveTokenKey;
// 		ofstream saveTokenSecret;
// 		
// 		saveTokenKey.open(myTokenKeyFile);
// 		saveTokenSecret.open(myTokenSecretFile);
// 		
// 		saveTokenKey.clear();
// 		saveTokenSecret.clear();
// 		
// 		saveTokenKey << myOAuthAccessTokenKey.c_str();
// 		saveTokenSecret << myOAuthAccessTokenSecret.c_str();
// 		
// 		saveTokenKey.close();
// 		saveTokenSecret.close();
// 	}
// 	return 0;
// }

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
