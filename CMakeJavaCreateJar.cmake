

macro(CMakeJavaCreateJar)
    set(${PROJECT_NAME}_m_evacu ${m})
    set(m ${PROJECT_NAME}.CMakeJarDirectory)
    list(APPEND ${m}_unsetter ${m}_GLOB ${m}_JAR ${m}_OUTPUT ${m}_WORKING_DIRECTORY ${m}_FILE ${m}_verbose ${m}_coption)
    cmake_parse_arguments( ${m} "DEBUG_VERBOSE" "JAR;OUTPUT;C_OPTION;FILE;WORKING_DIRECTORY" "GLOB" ${ARGV})
    
    if(${${m}_DEBUG_VERBOSE})
        include(CMakePrintHelpers)
        foreach(__var ${${m}_unsetter})
            cmake_print_variables(${__var})
        endforeach()
    endif()
    
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
            
        file(WRITE libs_jars.jar "")
        file(GLOB ${m}_libs_jar ${${m}_GLOB})
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

