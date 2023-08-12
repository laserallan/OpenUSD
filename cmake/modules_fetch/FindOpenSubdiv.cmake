

include(FetchContent)

# TODO: Include guard?
message("Fetching OpenSubdiv")
set(NO_DX ON CACHE BOOL "" FORCE)
set(NO_TESTS ON CACHE BOOL "" FORCE)
set(NO_EXAMPLES ON CACHE BOOL "" FORCE)
set(NO_REGRESSION ON CACHE BOOL "" FORCE)
set(NO_TUTORIALS ON CACHE BOOL "" FORCE)
set(NO_DOC ON CACHE BOOL "" FORCE)
set(NO_OMP ON CACHE BOOL "" FORCE)
set(NO_CUDA ON CACHE BOOL "" FORCE)
set(NO_OPENCL ON CACHE BOOL "" FORCE)
set(NO_GLEW ON CACHE BOOL "" FORCE)
set(NO_GLFW ON CACHE BOOL "" FORCE)
set(NO_CLEW ON CACHE BOOL "" FORCE)
set(NO_TBB ON CACHE BOOL "" FORCE)

FetchContent_Declare(
  OpenSubdiv
  GIT_REPOSITORY https://github.com/PixarAnimationStudios/OpenSubdiv.git
  GIT_TAG        ff76e0f # 3.4.4
)
FetchContent_MakeAvailable(OpenSubdiv)

set(OPENSUBDIV_INCLUDE_DIR "$<BUILD_INTERFACE:${opensubdiv_SOURCE_DIR}>")
set(OPENSUBDIV_LIBRARIES osd_cpu_obj osd_gpu_obj sdc_obj far_obj vtr_obj glLoader_obj)

install(TARGETS ${OPENSUBDIV_LIBRARIES} EXPORT pxrTargets)

# message(FATAL_ERROR "vds: ${OPENSUBDIV_INCLUDE_DIR}}")
function(print_all_targets DIR target_var)
    get_property(TGTS DIRECTORY "${DIR}" PROPERTY BUILDSYSTEM_TARGETS)
    foreach(TGT IN LISTS TGTS)
        list(APPEND ${target_var} ${TGT})
        message(STATUS "Target: ${TGT}")
        # TODO: Do something about it
    endforeach()

    get_property(SUBDIRS DIRECTORY "${DIR}" PROPERTY SUBDIRECTORIES)
    foreach(SUBDIR IN LISTS SUBDIRS)
        print_all_targets("${SUBDIR}" ${target_var})
    endforeach()
    set(${target_var} ${${target_var}} PARENT_SCOPE)
endfunction()

print_all_targets( "${opensubdiv_SOURCE_DIR}" ALL_TARGETS)
foreach(TARGET IN LISTS ALL_TARGETS)
    message("T: ${TARGET}")
    if(NOT ${TARGET} STREQUAL public_headers)
        target_compile_options(${TARGET} PRIVATE "/wd5045" "/wd4702" "/wd4191" "/wd4242")
        get_target_property(IC ${TARGET} INCLUDE_DIRECTORIES)
        message("${IC}")
        # get_target_property(IC ${TARGET} INTERFACE_INCLUDE_DIRECTORIES)
        # message("${IC}")
        # set_target_properties(${TARGET} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${IC}>)
    endif()
endforeach(TARGET IN LISTS ALL_TARGETS)
