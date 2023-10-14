include(FetchContent)
if(TARGET boost_python311)
    return()
endif()
# TODO: Include guard?
message("Fetching boost")
# find_package(PythonLibs 3.11 REQUIRED)
set(BOOST_ENABLE_PYTHON TRUE)
FetchContent_Declare(
  Boost
  GIT_REPOSITORY https://github.com/boostorg/boost.git
  GIT_TAG        564e2ac # release-1.83.0
)

FetchContent_MakeAvailable(Boost)

# At this point there seems to be no variables to identify the python
# version in scope meaning we are falling back to a hack to identify
# the appropriate boost python target

# Scan likely python minor versions
set(_BOOST_PYTHON_FOUND FALSE)
foreach(_V RANGE 6 12)
    set(_BOOST_PYTHON_TARGET boost_python3${_V})
    if(TARGET ${_BOOST_PYTHON_TARGET})
        message("Found boost python target ${_BOOST_PYTHON_TARGET}")
        # Sneaking in boost dependencies here as targets
        # Ideally boost should be explicit about boost dependencies and this
        # means we are linking more boost libraries than we need in many cases
        set(Boost_PYTHON3${_V}_LIBRARY ${_BOOST_PYTHON_TARGET} boost_vmd boost_any boost_assign boost_variant boost_multi_index boost_crc)
        set(_BOOST_PYTHON_FOUND TRUE)        
        break()
    endif()
endforeach()
if(NOT _BOOST_PYTHON_FOUND)
    message(FATAL_ERROR "Failed to found version specific boost target")
endif()

if(NOT TARGET ${_BOOST_PYTHON_TARGET})
    message(FATAL_ERROR "no python target found")
endif()
set(PROJECT_VERSION "1.83.0")
set(_BOOST_LIBS ${_BOOST_PYTHON_TARGET}
                boost_align
                boost_assign
                boost_ptr_container
                boost_circular_buffer 
                boost_bind 
                boost_config 
                boost_conversion 
                boost_core 
                boost_detail 
                boost_foreach
                boost_function
                boost_iterator
                boost_lexical_cast
                boost_mpl
                boost_numeric_conversion
                boost_preprocessor
                boost_smart_ptr
                boost_static_assert
                boost_tuple
                boost_type_traits
                boost_utility
                boost_assert
                boost_throw_exception
                boost_typeof
                boost_range
                boost_concept_check
                boost_function_types
                boost_fusion
                boost_optional
                boost_array
                boost_container
                boost_integer
                boost_predef
                boost_move
                boost_io
                boost_container_hash
                boost_regex
                boost_functional
                boost_describe
                boost_mp11
                boost_intrusive
                boost_graph
                boost_algorithm
                boost_any
                boost_bimap
                boost_math
                boost_multi_index
                boost_parameter
                boost_property_map
                boost_property_tree
                boost_random
                boost_serialization
                boost_spirit
                boost_tti
                boost_unordered
                boost_xpressive
                boost_exception
                boost_type_index
                boost_lambda
                boost_format
                boost_dynamic_bitset
                boost_system
                boost_variant
                boost_endian
                boost_phoenix
                boost_pool
                boost_proto
                boost_thread
                boost_variant2
                boost_winapi
                boost_atomic
                boost_chrono
                boost_date_time
                boost_ratio
                boost_tokenizer
                boost_rational
                boost_vmd
                boost_crc)

# Clean up libraries to avoid issues when using in usd
foreach(T ${_BOOST_LIBS})
    # Install with exports in a usd friendly way to avoid
    # complaints about targets missing in pxrTargets
    install(TARGETS ${T} EXPORT pxrTargets
        # explicit destination specification required for 3.13, 3.14 no longer needs it
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        PRIVATE_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
        PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    )

    # For some reason the boost python target has messed up interface include 
    # locations
    if(${T} STREQUAL ${_BOOST_PYTHON_TARGET})
        set_target_properties(${_BOOST_PYTHON_TARGET} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES 
            "$<BUILD_INTERFACE:${Boost_SOURCE_DIR}/libs/python/include>;$<INSTALL_INTERFACE:include/boost-1_83>")
    endif()
endforeach()
