cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

project(plastweet)
set (PROJECT_VERSION "0.1")
set (PROJECT_VERSION_MAJOR 0)

set(QT_MIN_VERSION "5.15.0")
set(KF5_MIN_VERSION "5.64.0")

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
   message(FATAL_ERROR "This application requires an out of source build. Please create a separate build directory.")
endif()

include(FeatureSummary)

find_package(ECM 5.64.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})
set_package_properties (
    ECM PROPERTIES TYPE REQUIRED DESCRIPTION "Extra CMake Modules"
    URL "https://invent.kde.org/frameworks/extra-cmake-modules"
    )

include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDEClangFormat)
include(ECMPoQmTools)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick QuickControls2)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Kirigami2 Plasma I18n Notifications Config CoreAddons)
find_package(Qt5WebEngine REQUIRED)

add_definitions(-DQT_NO_FOREACH)
kde_enable_exceptions()

add_subdirectory(src)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
