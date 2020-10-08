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

// TODO:
// * Implement multi-upload (pictures and video) and OAuth login
// * Use KNotifications on events (unable to login, media upload, tweet update status)
// * Implement a background service to receive user interactions
// * Safely store credentials (KWallet? KConfig?)

#include <iostream>
#include <string>

#include <QQmlApplicationEngine>
#include <QQmlContext>

// If build fails, try changing this
#include <json/json.h>
#include <json/value.h>
// to this
//#include <jsoncpp/json/json.h>
//#include <jsoncpp/json/value.h>

#include "backend.h"

BackEnd::BackEnd(QObject *parent) : QObject(parent) {
}

BackEnd::~BackEnd() {
}

void BackEnd::send_tweet(
	const QString &message,
	const QString &image,
	const QString &consumer_key,
	const QString &consumer_secret,
	const QString &user_token,
	const QString &token_secret
) {
	// Remove "file://" from the image path
	std::string newPath = image.toStdString();
	if(!newPath.empty()) {
		newPath = newPath.substr(7);
	}

	BackEnd backend;
	bool response = backend.execMain(
		message.toStdString(),
		newPath,
		consumer_key.toStdString(),
		consumer_secret.toStdString(),
		user_token.toStdString(),
		token_secret.toStdString()
	);
	if (!response) {
		backend.sendNotification(
			QStringLiteral("tweetNotSent"),
			QStringLiteral("error"),
			i18n("Tweet not sent"),
			i18n("There has been an error sending your tweet, try again.")
		);
	} else {
		backend.sendNotification(
			QStringLiteral("tweetSent"),
			QStringLiteral("dialog-ok"),
			i18n("Tweet sent"),
			i18n("Your status update has been successfully sent.")
		);
	}
}

bool BackEnd::execMain(
	std::string message,
	std::string image,
	std::string consumer_key,
	std::string consumer_secret,
	std::string user_token,
	std::string token_secret
) {
	twitter.getOAuth().setConsumerKey(consumer_key);
	twitter.getOAuth().setConsumerSecret(consumer_secret);
	twitter.getOAuth().setOAuthTokenKey(user_token);
	twitter.getOAuth().setOAuthTokenSecret(token_secret);
	twitter.accountVerifyCredGet();
	twitter.getLastWebResponse(api_response);
	
	Json::Value jsonResponse;
	std::istringstream jsonDoc(api_response);
	jsonDoc >> jsonResponse;
	const Json::Value chError = jsonResponse["errors"];
	//std::cout << chError << std::endl;

	// Verify account credentials
	if (!chError.empty()) {
		twitter.getLastCurlError(api_response);
		std::cout << api_response << std::endl;
		BackEnd::sendNotification(
			QStringLiteral("authError"),
			QStringLiteral("error"),
			i18n("Authentication problem"),
			i18n("There has been a problem validating your account, check your credentials and try again.")
		);
		return false;
	} else {
		if(image.empty()) {
			// Post a message
			if (twitter.statusUpdate(message)) {
				twitter.getLastWebResponse(api_response);
				// std::cout << api_response << std::endl;
				return true;
			} else {
				twitter.getLastCurlError(api_response);
				std::cout << api_response << std::endl;
				return false;
			}
		} else {
			// Post a message + media
			bool result = twitter.uploadMedia(image);
			if (result) {
				std::string response = "";
				twitter.getLastWebResponse(response);
				
				Json::Value uploadResponse;
				std::istringstream tmpResponse(response);
				tmpResponse >> uploadResponse;
				std::string* media_id = new std::string[1] {uploadResponse.get("media_id", "NULL").asString()};

				if (twitter.statusUpdateWithMedia(message, media_id, 1)) {
					twitter.getLastWebResponse(response);
					// std::cout << response << std::endl;
					return true;
				} else {
					twitter.getLastCurlError(response);
					std::cout << response << std::endl;
					return false;
				}
			} else {
				std::cout << "(!!) Error uploading media: " + api_response << std::endl;
				BackEnd::sendNotification(
					QStringLiteral("statusError"),
					QStringLiteral("error"),
					i18n("Unable to upload selected media"),
					i18n("Your media file could not be processed.")
				);
				return false;
			}
		}
	}
}
