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

#include <json/json.h>
#include <json/value.h>

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
	const QString &token_secret) {
	
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
		token_secret.toStdString());
	if (!response) std::cout << "(!!) Error getting tweet message" << std::endl;
}

bool BackEnd::execMain(
	std::string message,
	std::string image,
	std::string consumer_key,
	std::string consumer_secret,
	std::string user_token,
	std::string token_secret) {
	try {
		// Set Twitter consumer key and secret,
		//   OAuth access token key and secret
		twitter.getOAuth().setConsumerKey(consumer_key);
		twitter.getOAuth().setConsumerSecret(consumer_secret);
		twitter.getOAuth().setOAuthTokenKey(user_token);
		twitter.getOAuth().setOAuthTokenSecret(token_secret);

		// Verify account credentials
		if (!twitter.accountVerifyCredGet()) {
			twitter.getLastCurlError(api_response);
			std::cout << api_response << std::endl;
			return false;
		}
		
		if(image.empty()) {
			// Post a message
			api_response = "";
			if (twitter.statusUpdate(message)) {
				twitter.getLastWebResponse(api_response);
				// std::cout << api_response << std::endl;
			} else {
				twitter.getLastCurlError(api_response);
				std::cout << api_response << std::endl;
				return false;
			}
		} else {
			// Post a message + media
			bool result = twitter.uploadMedia(image);
			if(result) {
				std::string response = "";
				twitter.getLastWebResponse(response);
				
				Json::Value root;
				std::istringstream sin(response);
				sin >> root;
				std::string* media_id = new std::string[1] {root.get("media_id", "NULL").asString()};

				if (twitter.statusUpdateWithMedia(message, media_id, 1)) {
					twitter.getLastWebResponse(response);
					// std::cout << response << std::endl;
				} else {
					twitter.getLastCurlError(response);
					std::cout << response << std::endl;
				}
			} else {
				std::cout << "(!!) Error uploading media: " + api_response << std::endl;
			}
		}
	} catch (char *e) {
		std::cout << "[EXCEPTION] " << e << std::endl;
		return false;
	}
	// emit tweetSent(); // FIXME
	return true;
}
