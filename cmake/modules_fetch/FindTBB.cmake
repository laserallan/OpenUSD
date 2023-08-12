
include(FetchContent)

# TODO: Include guard?
message("Fetching tbb")
FetchContent_Declare(
  TBB
  GIT_REPOSITORY https://github.com/wjakob/tbb.git
  GIT_TAG        9e219e2 
)
FetchContent_MakeAvailable(TBB)

set(TBB_INCLUDE_DIR $<BUILD_INTERFACE:${tbb_SOURCE_DIR}/include>)
set(TBB_INCLUDE_DIRS $<BUILD_INTERFACE:${tbb_SOURCE_DIR}/include>)
# message(FATAL_ERROR "Blah: ${TBB_INCLUDE_DIRS}")
set(TBB_LIBRARIES tbb)
set(TBB_tbb_LIBRARY tbb)
target_compile_definitions(tbb PUBLIC TBB_USE_THREADING_TOOLS=0 TBB_USE_ASSERT=0 TBB_USE_PERFORMANCE_WARNINGS=0)