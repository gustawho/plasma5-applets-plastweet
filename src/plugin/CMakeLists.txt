set(plastweet_SRCS backend.cpp plastweet.cpp
twitcurl/base64.cpp twitcurl/HMAC_SHA1.cpp twitcurl/oauthlib.cpp twitcurl/SHA1.cpp twitcurl/twitcurl.cpp twitcurl/urlencode.cpp)

add_library(plastweet SHARED ${plastweet_SRCS})

target_link_libraries(plastweet Qt5::Core Qt5::Quick Qt5::WebEngine KF5::Plasma KF5::I18n KF5::Notifications KF5::ConfigCore curl jsoncpp)

install(TARGETS plastweet DESTINATION ${QML_INSTALL_DIR}/org/kde/plastweet)
install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plastweet)
