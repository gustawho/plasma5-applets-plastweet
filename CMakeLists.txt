cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

project(plastweet)
set (PROJECT_VERSION "0.1")
set (PROJECT_VERSION_MAJOR 0)

include(FeatureSummary)

find_package(ECM 5.50.0 REQUIRED NO_MODULE)

set_package_properties (
    ECM PROPERTIES TYPE REQUIRED DESCRIPTION "Extra CMake Modules"
    URL "https://invent.kde.org/frameworks/extra-cmake-modules"
    )

feature_summary (WHAT REQUIRED_PACKAGES_NOT_FOUND FATAL_ON_MISSING_REQUIRED_PACKAGES)

set (
    CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${ECM_MODULE_PATH}
    ${ECM_KDE_MODULE_DIR}
    "${CMAKE_SOURCE_DIR}/cmake/modules"
    )

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)

set(QT_MIN_VERSION "5.12.0")
set(KF5_MIN_VERSION "5.68.0")

add_definitions(-fexceptions)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED Quick)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma I18n)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

add_subdirectory(src)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ltwitcurl -lcurl -ljson -std=c++11 -s")

