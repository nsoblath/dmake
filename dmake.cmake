# dmake is written by Dan Furse (dlfurse@mit.edu)

# the goal of dmake is to help you stay away from wanting to rip your balls off and bleed out when you use cmake
message( STATUS "*** dmake! take it easy:-D" )

# this macro declares a project and declares some installation and structural cache variables so you can tell cmake what you want
macro( dmake_project_begin LOCAL_PROJECT_NAME LOCAL_MAJOR_VERSION LOCAL_MINOR_VERSION LOCAL_REVISION_VERSION )    
    
    # deal with satan a little
    project( ${LOCAL_PROJECT_NAME} )
    set( CMAKE_INSTALL_PREFIX "" CACHE INTERNAL "" FORCE )
    mark_as_advanced( CMAKE_BUILD_TYPE )
    
    # some project internal variables
    set( DM_PROJECT_NAME ${LOCAL_PROJECT_NAME} )
    set( ${DM_PROJECT_NAME}_DEPENDENCIES "" )
    set( ${DM_PROJECT_NAME}_INCLUDES "" )
    set( ${DM_PROJECT_NAME}_HEADERS "" )
    set( ${DM_PROJECT_NAME}_LIBRARIES "" )
    set( ${DM_PROJECT_NAME}_EXECUTABLES "" )
    set( ${DM_PROJECT_NAME}_VERSION_MAJOR ${LOCAL_MAJOR_VERSION} )
    set( ${DM_PROJECT_NAME}_VERSION_MINOR ${LOCAL_MINOR_VERSION} )
    set( ${DM_PROJECT_NAME}_VERSION_REVISION ${LOCAL_REVISION_VERSION} )
    set( ${DM_PROJECT_NAME}_VERSION_FULL "${${DM_PROJECT_NAME}_VERSION_MAJOR}.${${DM_PROJECT_NAME}_VERSION_MINOR}.${${DM_PROJECT_NAME}_VERSION_REVISION}" )
    set( ${DM_PROJECT_NAME}_IDENTIFIER "${DM_PROJECT_NAME}.${${DM_PROJECT_NAME}_VERSION_FULL}" )
    
    # some advanced project structual cache variables
    set( ${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY "Include" CACHE STRING "name of subdirectory in library subdirectories in which header files are kept" )
    set( ${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY "Source" CACHE STRING "name of subdirectory in library subdirectories in which source are kept" )
    set( ${DM_PROJECT_NAME}_VERBOSE ON CACHE BOOL "report back to the user that everything is going ok" )
    mark_as_advanced( FORCE ${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY ${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY ${DM_PROJECT_NAME}_VERBOSE )
    
    # some project installation cache variables
    set( ${DM_PROJECT_NAME}_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/.. )
    set( ${DM_PROJECT_NAME}_INSTALL_PREFIX "${${DM_PROJECT_NAME}_ROOT}/Install" CACHE PATH "installation prefix (changing this will recompute other install locations)" )    
    if( "${${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL}" STREQUAL "${${DM_PROJECT_NAME}_INSTALL_PREFIX}" )
        set( ${DM_PROJECT_NAME}_INSTALL_HEADERS_DIR "${${DM_PROJECT_NAME}_INSTALL_PREFIX}/include" CACHE PATH "installation directory for headers" )
        set( ${DM_PROJECT_NAME}_INSTALL_LIBRARIES_DIR "${${DM_PROJECT_NAME}_INSTALL_PREFIX}/lib" CACHE PATH "installation directory for libraries" )
        set( ${DM_PROJECT_NAME}_INSTALL_EXECUTABLES_DIR "${${DM_PROJECT_NAME}_INSTALL_PREFIX}/bin" CACHE PATH "installation directory for libraries" )
    else( "${${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL}" STREQUAL "${${DM_PROJECT_NAME}_INSTALL_PREFIX}" )
        set( ${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL "${${DM_PROJECT_NAME}_INSTALL_PREFIX}" CACHE INTERNAL "" )
        set( ${DM_PROJECT_NAME}_INSTALL_HEADERS_DIR "${${DM_PROJECT_NAME}_INSTALL_PREFIX}/include" CACHE PATH "installation directory for headers" FORCE )
        set( ${DM_PROJECT_NAME}_INSTALL_LIBRARIES_DIR "${${DM_PROJECT_NAME}_INSTALL_PREFIX}/lib" CACHE PATH "installation directory for libraries" FORCE )
        set( ${DM_PROJECT_NAME}_INSTALL_EXECUTABLES_DIR "${${DM_PROJECT_NAME}_INSTALL_PREFIX}/bin" CACHE PATH "installation directory for libraries" FORCE )
    endif( "${${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL}" STREQUAL "${${DM_PROJECT_NAME}_INSTALL_PREFIX}" )
    
    if( NOT DEFINED ${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL )
        set( ${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL "${${DM_PROJECT_NAME}_INSTALL_PREFIX}" CACHE INTERNAL "" )
    endif( NOT DEFINED ${DM_PROJECT_NAME}_INSTALL_PREFIX_INTERNAL ) 
    
endmacro()

macro( dmake_dependency LOCAL_PROJECT_NAME LOCAL_MAJOR_VERSION LOCAL_MINOR_VERSION LOCAL_REVISION_VERSION )
    message( STATUS "*** external dependency declared <${LOCAL_PROJECT_NAME}>" )
    
    # import the dependency's things
    include( $ENV{HOME}/.dmake/${LOCAL_PROJECT_NAME}.${LOCAL_MAJOR_VERSION}.${LOCAL_MINOR_VERSION}.${LOCAL_REVISION_VERSION}.cmake )
    

    
    # talk about our feelings
    if( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
        message( STATUS "*** external includes now <${${DM_PROJECT_NAME}_EXTERNAL_INCLUDES}>" )
        message( STATUS "*** external libraries now <${${DM_PROJECT_NAME}_EXTERNAL_LIBRARIES}>" )
    endif( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )    
    
endmacro()

# declare the existence of a library and the root subdirectory where its source code is kept
macro( dmake_library_declare LOCAL_LIBRARY_NAME LOCAL_LIBRARY_ROOT )
    
    # record root directory and enable toggle for the library
    set( ${LOCAL_LIBRARY_NAME}_ROOT ${LOCAL_LIBRARY_ROOT} )
    set( ${LOCAL_LIBRARY_NAME}_SHARED ON CACHE BOOL "enable or disable shared nature of library <${LOCAL_LIBRARY_NAME}>" )
    set( ${LOCAL_LIBRARY_NAME}_ENABLED ON CACHE BOOL "enable or disable building of library <${LOCAL_LIBRARY_NAME}>" )
    mark_as_advanced( ${LOCAL_LIBRARY_NAME}_SHARED ${LOCAL_LIBRARY_NAME}_ENABLED )
    
    # clear out headers and sources for the library
    set( ${LOCAL_LIBRARY_NAME}_HEADERS "" )
    set( ${LOCAL_LIBRARY_NAME}_SOURCES "" )
    
    # append the path to the headers in the library directory to the global include list
    if( "${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}" STREQUAL "" )
        list( APPEND ${DM_PROJECT_NAME}_INCLUDES ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_LIBRARY_NAME}_ROOT} )
    else( "${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}" STREQUAL "" )
        list( APPEND ${DM_PROJECT_NAME}_INCLUDES ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_LIBRARY_NAME}_ROOT}/${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY} )
    endif( "${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}" STREQUAL "" )
    
    # append the name of the library to the global library list
    list( APPEND ${DM_PROJECT_NAME}_LIBRARIES ${LOCAL_LIBRARY_NAME} )
    
    # talk about our feelings
    if( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
        message( STATUS "*** declared a library called <${LOCAL_LIBRARY_NAME}> in subdirectory <${${LOCAL_LIBRARY_NAME}_ROOT}>" )
    endif( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
    
endmacro()

# add header content to a library (MUST be previously declared!)
macro( dmake_library_headers LOCAL_LIBRARY_NAME )
    if( "${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}" STREQUAL "" )
    
        foreach( HEADER_FILE ${ARGN} )
            list( APPEND ${LOCAL_LIBRARY_NAME}_HEADERS ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_LIBRARY_NAME}_ROOT}/${HEADER_FILE} )
        endforeach()
    else( "${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}" STREQUAL "" )
        foreach( HEADER_FILE ${ARGN} )
            list( APPEND ${LOCAL_LIBRARY_NAME}_HEADERS ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_LIBRARY_NAME}_ROOT}/${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}/${HEADER_FILE} )
        endforeach()
    endif( "${${DM_PROJECT_NAME}_HEADER_SUBDIRECTORY}" STREQUAL "" )
    
    # talk about our feelings
    if( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
        message( STATUS "*** library called <${LOCAL_LIBRARY_NAME}> has headers <${${LOCAL_LIBRARY_NAME}_HEADERS}>" )
    endif( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
    
endmacro()

# add source content to a library (MUST be previously declared!)
macro( dmake_library_sources LOCAL_LIBRARY_NAME )

    if( "${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}" STREQUAL "" )
        foreach( SOURCE_FILE ${ARGN} )
            list( APPEND ${LOCAL_LIBRARY_NAME}_SOURCES ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_LIBRARY_NAME}_ROOT}/${SOURCE_FILE} )
        endforeach()
    else( "${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}" STREQUAL "" )
        foreach( SOURCE_FILE ${ARGN} )
            list( APPEND ${LOCAL_LIBRARY_NAME}_SOURCES ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_LIBRARY_NAME}_ROOT}/${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}/${SOURCE_FILE} )
        endforeach()
    endif( "${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}" STREQUAL "" )
    
    # talk about our feelings
    if( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
        message( STATUS "*** library called <${LOCAL_LIBRARY_NAME}> has sources <${${LOCAL_LIBRARY_NAME}_SOURCES}>" )
    endif( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )

endmacro()

# declare the existence of an executable and the root subdirectory where its sources are kept
macro( dmake_executable_declare LOCAL_EXECUTABLE_NAME LOCAL_EXECUTABLE_ROOT )
    
    # record root directory and enable toggle for the executable
    set( ${LOCAL_EXECUTABLE_NAME}_ROOT ${LOCAL_EXECUTABLE_ROOT} ) 
    set( ${LOCAL_EXECUTABLE_NAME}_ENABLED ON CACHE BOOL "enable or disable building of library <${LOCAL_LIBRARY_NAME}>" )
    mark_as_advanced( ${LOCAL_EXECUTABLE_NAME}_ENABLED )

    # clear out sources for the executable    
    set( ${LOCAL_EXECUTABLE_NAME}_SOURCES "" )
   
    # append the name of the library to the global library list
    list( APPEND ${DM_PROJECT_NAME}_EXECUTABLES ${LOCAL_EXECUTABLE_NAME} )
    
    # talk about our feelings
    if( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
        message( STATUS "*** declared an executable called <${LOCAL_EXECUTABLE_NAME}> at <${${LOCAL_EXECUTABLE_NAME}_ROOT}>" )
    endif( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
    
endmacro()

# add source content to an executable (MUST be previously declared!)
macro( dmake_executable_sources LOCAL_EXECUTABLE_NAME )

    if( "${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}" STREQUAL "" )
        foreach( SOURCE_FILE ${ARGN} )
            list( APPEND ${LOCAL_EXECUTABLE_NAME}_SOURCES ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_EXECUTABLE_NAME}_ROOT}/${SOURCE_FILE} )
        endforeach()
    else( "${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}" STREQUAL "" )
        foreach( SOURCE_FILE ${ARGN} )
            list( APPEND ${LOCAL_EXECUTABLE_NAME}_SOURCES ${${DM_PROJECT_NAME}_ROOT}/${${LOCAL_EXECUTABLE_NAME}_ROOT}/${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}/${SOURCE_FILE} )
        endforeach()
    endif( "${${DM_PROJECT_NAME}_SOURCE_SUBDIRECTORY}" STREQUAL "" )
    
    # talk about our feelings
    if( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )
        message( STATUS "*** executable called <${LOCAL_EXECUTABLE_NAME}> has sources <${${LOCAL_EXECUTABLE_NAME}_SOURCES}>" )
    endif( "${${DM_PROJECT_NAME}_VERBOSE}" STREQUAL "ON" )

endmacro()

# trigger everything and finish
macro( dmake_project_end )

    # update the external includes
    set( ${DM_PROJECT_NAME}_EXTERNAL_INCLUDES "${${DM_PROJECT_NAME}_EXTERNAL_INCLUDES} -I${${LOCAL_PROJECT_NAME}_INSTALL_HEADERS_DIR}" )
    
    # update the external libraries
    set( ${DM_PROJECT_NAME}_EXTERNAL_LIBRARIES "${${DM_PROJECT_NAME}_EXTERNAL_LIBRARIES} -L${${LOCAL_PROJECT_NAME}_INSTALL_HEADERS_DIR}" )
    foreach( EXTERNAL_LIBRARY ${${LOCAL_PROJECT_NAME}_LIBRARIES} )
        set( ${DM_PROJECT_NAME}_EXTERNAL_LIBRARIES "${${DM_PROJECT_NAME}_EXTERNAL_LIBRARIES} -l${EXTERNAL_LIBRARY}" )
    endforeach()

    # tell satan to add all includes to the global include path
    foreach( INCLUDE_NAME ${${DM_PROJECT_NAME}_INCLUDES} )
        include_directories( ${INCLUDE_NAME} )
    endforeach()

    # tell satan to add all libraries to the build
    foreach( LIBRARY_NAME ${${DM_PROJECT_NAME}_LIBRARIES} )
        if( "${${LIBRARY_NAME}_ENABLED}" STREQUAL "ON" )
            if( "${${LIBRARY_NAME}_SHARED}" STREQUAL "ON" )
                add_library( ${LIBRARY_NAME} SHARED ${${LIBRARY_NAME}_SOURCES} )
            else( "${${LIBRARY_NAME}_SHARED}" STREQUAL "ON" )
                add_library( ${LIBRARY_NAME} STATIC ${${LIBRARY_NAME}_SOURCES} )
            endif( "${${LIBRARY_NAME}_SHARED}" STREQUAL "ON" )
        endif( "${${LIBRARY_NAME}_ENABLED}" STREQUAL "ON" )
    endforeach()
    
    # tell satan to add all executables to the build
    foreach( EXECUTABLE_NAME ${${DM_PROJECT_NAME}_EXECUTABLES} )
        if( "${${EXECUTABLE_NAME}_ENABLED}" STREQUAL "ON" )
            add_executable( ${EXECUTABLE_NAME} ${${EXECUTABLE_NAME}_SOURCES} )
        endif( "${${EXECUTABLE_NAME}_ENABLED}" STREQUAL "ON" )
    endforeach()
    
    # prepare the cache directory
    set( PACKAGE_CACHE_DIRECTORY $ENV{HOME}/.dmake )
    make_directory( ${PACKAGE_CACHE_DIRECTORY} )
    
    # prepare the cache file
    set( PACKAGE_CACHE_FILE $ENV{HOME}/.dmake/${${DM_PROJECT_NAME}_IDENTIFIER}.cmake )
    file( WRITE  ${PACKAGE_CACHE_FILE} "\# this file was automatically generated by dmake to describe an installation of <${DM_PROJECT_NAME}>\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_VERSION_MAJOR ${${DM_PROJECT_NAME}_VERSION_MAJOR} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_VERSION_MINOR ${${DM_PROJECT_NAME}_VERSION_MINOR} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_VERSION_REVISION ${${DM_PROJECT_NAME}_VERSION_REVISION} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_VERSION_FULL ${${DM_PROJECT_NAME}_VERSION_FULL} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_IDENTIFIER ${${DM_PROJECT_NAME}_IDENTIFIER} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_INSTALL_HEADERS_DIR ${${DM_PROJECT_NAME}_INSTALL_HEADERS_DIR} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_LIBRARIES ${${DM_PROJECT_NAME}_LIBRARIES} ) \n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_INSTALL_LIBRARIES_DIR ${${DM_PROJECT_NAME}_INSTALL_LIBRARIES_DIR} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_EXECUTABLES ${${DM_PROJECT_NAME}_EXECUTABLES} )\n" )
    file( APPEND ${PACKAGE_CACHE_FILE} "set( ${DM_PROJECT_NAME}_INSTALL_EXECUTABLES_DIR ${${DM_PROJECT_NAME}_INSTALL_EXECUTABLES_DIR} )\n" )

    #install everything
    install( FILES ${${DM_PROJECT_NAME}_HEADERS} DESTINATION ${${DM_PROJECT_NAME}_INSTALL_HEADERS_DIR} )
    install( TARGETS ${${DM_PROJECT_NAME}_LIBRARIES} DESTINATION ${${DM_PROJECT_NAME}_INSTALL_LIBRARIES_DIR} )
    install( TARGETS ${${DM_PROJECT_NAME}_EXECUTABLES} DESTINATION ${${DM_PROJECT_NAME}_INSTALL_EXECUTABLES_DIR} )
    
endmacro()

# bye
