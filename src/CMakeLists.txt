plasma_install_package(package org.kde.plastweet)

include_directories (
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

add_subdirectory(plugin)
add_subdirectory(translations)

install(FILES plastweet.notifyrc DESTINATION ${KNOTIFYRC_INSTALL_DIR})
