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
// * Get rid of all the Q_INVOKABLE macros and instead use Q_PROPERTY

#ifndef BACKEND_H
#define BACKEND_H

#include <string>
#include <iostream>

#include <QObject>

#include "twitcurl.h"

class BackEnd : public QObject {
	Q_OBJECT
public:
	explicit BackEnd(QObject *parent = 0);
	~BackEnd();
	
	Q_INVOKABLE int sendTweet(const QString &message, const QString &image,
							const QString &consumer_key, const QString &consumer_secret,
						const QString &user_token, const QString &token_secret);
	bool execMain(std::string message, std::string image,
				std::string consumer_key, std::string consumer_secret,
			std::string user_token, std::string token_secret);
	
signals:
	// Q_INVOKABLE void tweetSent();
private:
	twitCurl twitter;
	std::string api_response;
};

#endif
