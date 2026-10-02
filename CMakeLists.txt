cmake_minimum_required(VERSION 4.4)

# This experimental feature identifier applies to CMake 4.4.
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "f35a9ac6-8463-4d38-8eec-5d6008153e7d")
set(CMAKE_CXX_COMPILER "/opt/homebrew/opt/llvm/bin/clang++")
set(CMAKE_CXX_STDLIB_MODULES_JSON "/opt/homebrew/opt/llvm/lib/c++/libc++.modules.json")
set(CMAKE_CXX_FLAGS_INIT "-stdlib=libc++")
# Use Apple's archive tools for the macOS linker.
set(CMAKE_AR "/usr/bin/ar" CACHE FILEPATH "macOS archiver" FORCE)
set(CMAKE_RANLIB "/usr/bin/ranlib" CACHE FILEPATH "macOS archive indexer" FORCE)

project(paporotnic LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_MODULE_STD ON)

# Each nonempty lab*/*.cpp is a standalone exercise with its own main(),
# except for helper sources explicitly excluded below.
# Keep build directories outside the lab* folders.
file(GLOB LAB_SOURCES LIST_DIRECTORIES false CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/lab*/*.cpp"
)
list(FILTER LAB_SOURCES EXCLUDE REGEX "/previous_sum\\.cpp$")

foreach(LAB_SOURCE IN LISTS LAB_SOURCES)
    # Notice when a newly created empty exercise receives its first code.
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${LAB_SOURCE}")
    file(SIZE "${LAB_SOURCE}" LAB_SOURCE_SIZE)
    if(LAB_SOURCE_SIZE EQUAL 0)
        continue()
    endif()

    file(RELATIVE_PATH LAB_RELATIVE_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}" "${LAB_SOURCE}")
    string(REGEX REPLACE "\\.cpp$" "" LAB_TARGET "${LAB_RELATIVE_SOURCE}")
    string(MAKE_C_IDENTIFIER "${LAB_TARGET}" LAB_TARGET)
    if(TARGET "${LAB_TARGET}")
        message(FATAL_ERROR "Duplicate exercise target: ${LAB_TARGET}")
    endif()

    add_executable("${LAB_TARGET}" "${LAB_SOURCE}")
    target_link_directories("${LAB_TARGET}" PRIVATE "/opt/homebrew/opt/llvm/lib/c++")
endforeach()

target_sources(lab2_4 PRIVATE lab2/previous_sum.cpp)
