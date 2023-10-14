

include(FetchContent)

# TODO: Include guard?
message("Fetching OpenSubdiv")

# Set flags to make build simple and avoid downstream issues
# with usd
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
# Disable TBB since opensubdiv aggressively detects TBB
# in its own way with no include guard
set(NO_TBB ON CACHE BOOL "" FORCE)

FetchContent_Declare(
  OpenSubdiv
  GIT_REPOSITORY https://github.com/PixarAnimationStudios/OpenSubdiv.git
  GIT_TAG        ff76e0f # 3.4.4, Note can't use 3.5.0 since it includes a limits.h breaking builds on windows
)
FetchContent_MakeAvailable(OpenSubdiv)

# Set variables Usd relies on for its opensubdiv linking and incloudes
set(OPENSUBDIV_INCLUDE_DIR "$<BUILD_INTERFACE:${opensubdiv_SOURCE_DIR}>")
set(OPENSUBDIV_LIBRARIES osd_cpu_obj osd_gpu_obj sdc_obj far_obj vtr_obj glLoader_obj)

# Meke sure osd libraries are in the pxrTargets export set to avoid
# errors from cmake
install(TARGETS ${OPENSUBDIV_LIBRARIES} EXPORT pxrTargets)

# Create a list of all Opensubdiv targets to disable warnings
# that will make the build fail on windows
set(_ALL_OSD_TARGETS ${OPENSUBDIV_LIBRARIES})
list(APPEND _ALL_OSD_TARGETS "stringify" "regression_common_obj" "regression_far_utils_obj")
foreach(TARGET IN LISTS _ALL_OSD_TARGETS)
    # Disable problematic warnings on msvc
    target_compile_options(${TARGET} PRIVATE "/wd5045" "/wd4702" "/wd4191" "/wd4242")
endforeach()
