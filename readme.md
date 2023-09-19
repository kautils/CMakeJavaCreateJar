### CMakeJavaCreateJar
* generate jar using directory or glob expression

### note
* JAR : path to jar executable.
* OUTPUT path to jar file to generate
* C_OPTION : -C option of  "jar ... -C arg"  
* FILE : file to zip 
* GLOB : expression after the <outvar> of CMake's "file(GLOB <outvar> [RELATIVE <arg>] <glob_expr>)"
* WORKING_DIRECTORY : working directory for CMake's execute_process. the default is ${CMAKE_CURRENT_LIST_DIR}.

### example
```cmake
# cd ${CMAKE_CURRENT_LIST_DIR} && jar cf ${CMAKE_CURRENT_LIST_DIR}/obj_classes.jar -C obj/ "" 
CMakeJavaCreateJar(
    JAR "path_to_jar"
    OUTPUT ${CMAKE_CURRENT_LIST_DIR}/obj_classes.jar
    C_OPTION obj/
    FILE "" 
)

#[[
    write_file(${CMAKE_CURRENT_LIST_DIR}/libs_jars.jar,"");
    for(f : files_globbed){
        jar ${CMAKE_CURRENT_LIST_DIR}/libs_jars.jar uf -C libs/ f      
    }
]]
CMakeJavaCreateJar(
    JAR "path_to_jar"
    OUTPUT ${CMAKE_CURRENT_LIST_DIR}/libs_jars.jar
    C_OPTION libs/
    GLOB RELATIVE ${CMAKE_CURRENT_LIST_DIR} libs/*.jar
)
```
