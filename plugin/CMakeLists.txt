set(plasmoidplugin_SRCS
	backend.cpp
	plasmoidplugin.cpp
	)

add_library(plasmoidplugin SHARED ${plasmoidplugin_SRCS})

target_link_libraries(plasmoidplugin Qt5::Quick KF5::Plasma KF5::I18n twitcurl oauth curl)

install(TARGETS plasmoidplugin DESTINATION ${QML_INSTALL_DIR}/com/gustawho/plastweet)

install(FILES qmldir DESTINATION ${QML_INSTALL_DIR}/com/gustawho/plastweet)
