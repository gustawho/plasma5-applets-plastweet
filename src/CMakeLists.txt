plasma_install_package(package org.kde.plastweet)

include_directories (
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

add_subdirectory (translations)

install(FILES ../img/plastweet.svg DESTINATION /usr/share/icons/hicolor/scalable/apps)
install(FILES ../img/panel/plastweet.svg ../img/panel/plastweet-dark.svg DESTINATION /usr/share/icons/hicolor/22x22/apps)
