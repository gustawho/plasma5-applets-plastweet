plasma_install_package(package org.kde.plastweet)
install(FILES ../img/plastweet.svg DESTINATION /usr/share/icons/hicolor/scalable/apps)

include_directories (
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

add_subdirectory (translations)
