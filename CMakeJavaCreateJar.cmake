if(NOT DEFINED KAUTIL_THIRD_PARTY_DIR)
    set(KAUTIL_THIRD_PARTY_DIR ${CMAKE_BINARY_DIR})
    file(MAKE_DIRECTORY "${KAUTIL_THIRD_PARTY_DIR}")
endif()

macro(git_clone url)
    get_filename_component(file_name ${url} NAME)
    if(NOT EXISTS ${KAUTIL_THIRD_PARTY_DIR}/kautil_cmake/${file_name})
        file(DOWNLOAD ${url} "${KAUTIL_THIRD_PARTY_DIR}/kautil_cmake/${file_name}")
    endif()
    include("${KAUTIL_THIRD_PARTY_DIR}/kautil_cmake/${file_name}")
    unset(file_name)
endmacro()
git_clone(https://raw.githubusercontent.com/kautils/CMakeUpdatedFile/v0.0.1/CMakeUpdatedFile.cmake)


macro(CMakeJavaCreateJar)
    set(${PROJECT_NAME}_m_evacu ${m})
    set(m ${PROJECT_NAME}.CMakeJarDirectory)
    list(APPEND ${m}_unsetter ${${m}_glob_mode} ${m}_UPDATED_ONLY ${m}_GLOB ${m}_GLOB_RECURSE ${m}_JAR ${m}_OUTPUT ${m}_WORKING_DIRECTORY ${m}_FILE ${m}_verbose ${m}_coption)
    cmake_parse_arguments( ${m} "UPDATED_ONLY;DEBUG_VERBOSE" "JAR;OUTPUT;C_OPTION;FILE;WORKING_DIRECTORY" "GLOB;GLOB_RECURSE" ${ARGV})
    
    if(NOT DEFINED ${m}_OUTPUT)
        message(FATAL_ERROR "must specify OUTPUT")
    endif()
    
    if(NOT DEFINED ${m}_WORKING_DIRECTORY)
        set(${m}_WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}")
    endif()
    
    
    if(NOT DEFINED ${m}_C_OPTION)
        unset(${m}_coption)
    else()
        set(${m}_coption -C "${${m}_C_OPTION}")
    endif()
    
    if(DEFINED ${m}_GLOB)
        set(${m}_glob_mode GLOB)
    elseif(${m}_GLOB_RECURSE)
        set(${m}_glob_mode GLOB_RECURSE)
    endif()
    
    if(${${m}_DEBUG_VERBOSE})
        include(CMakePrintHelpers)
        foreach(__var ${${m}_unsetter})
            cmake_print_variables(${__var})
        endforeach()
    endif()

    
    if(DEFINED ${m}_glob_mode)
        file(WRITE libs_jars.jar "")
        file(${${m}_glob_mode} ${m}_libs_jar ${${m}_${${m}_glob_mode}})
        
        if(${${m}_UPDATED_ONLY})
            CMakeUpdatedFile(READ FILES ${m}_libs_jar)
        endif()
        
        foreach(__jar ${${m}_libs_jar})
            execute_process(
                COMMAND ${${m}_JAR} uf "${${m}_OUTPUT}" ${${m}_C_OPTION} "${__jar}"
                OUTPUT_VARIABLE ${m}_out
                ERROR_VARIABLE ${m}_err
                RESULT_VARIABLE ${m}_ret
                WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
            )
    
            if(NOT ${${m}_ret} EQUAL 0)
                message("[output] : ${${m}_out}")
                message("[error]  : ${${m}_err}")
                message("[result] : ${${m}_res}")
                message(FATAL_ERROR "${__jar}")
            endif()
        endforeach()

#        if(${${m}_UPDATED_ONLY})
#        endif()
        CMakeUpdatedFile(WRITE FILES ${m}_libs_jar)
        
        
    else()
        execute_process(
            COMMAND ${${m}_JAR} cf "${${m}_OUTPUT}" ${${m}_coption} "${${m}_FILE}" 
            OUTPUT_VARIABLE ${m}_out
            ERROR_VARIABLE ${m}_err
            RESULT_VARIABLE ${m}_ret
            WORKING_DIRECTORY "${${m}_WORKING_DIRECTORY}"
        )
        
    endif()

    foreach(__v ${${m}_unsetter})
        unset(${__v})
    endforeach()
    unset(${m}_unsetter)
    set(m ${${PROJECT_NAME}_m_evacu})
    
    if(NOT ${${m}_ret} EQUAL 0)
        string(APPEND ${m}_msg "[output] : ${${m}_out}\n" "[error]  : ${${m}_err}\n" "[result] : ${${m}_res}\n")
        message(FATAL_ERROR "${${m}_msg}")
    endif()
    
    
endmacro()

