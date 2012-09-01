cmake_minimum_required(VERSION 2.8)
mark_as_advanced( CMAKE_BUILD_TYPE CMAKE_INSTALL_PREFIX )
set( DMAKE_CACHE_DIRECTORY "$ENV{HOME}/.dmake" CACHE PATH "directory where the dmake main file and its cache files will be installed" )
install( FILES ./dmake.cmake DESTINATION $ENV{HOME}/.dmake )
