plasma_install_package(package org.kde.plastweet)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(plugin)
add_subdirectory(translations)

install(FILES plastweet.notifyrc DESTINATION ${KNOTIFYRC_INSTALL_DIR})
install(FILES ../img/plastweet.svg DESTINATION /usr/share/icons/hicolor/scalable/apps)
install(FILES ../img/plastweet-tray.svg DESTINATION /usr/share/icons/hicolor/22x22/apps)
