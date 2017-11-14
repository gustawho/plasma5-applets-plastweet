set(plastweet_SRCS
	backend.cpp
	plastweet.cpp
	)

add_library(plastweet SHARED ${plastweet_SRCS})

target_link_libraries(plastweet Qt5::Quick KF5::Plasma KF5::I18n twitcurl oauth curl)

install(TARGETS plastweet DESTINATION ${QML_INSTALL_DIR}/com/gustawho/plastweet)

install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/com/gustawho/plastweet)
