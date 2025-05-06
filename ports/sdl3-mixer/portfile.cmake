vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsdl-org/SDL_mixer
    # REF "release-${VERSION}"
    REF b3a6fa8b5ad183f0a1bad02527d89a00c3c90106 # release-3.0.0

    SHA512 dc75161ae71c697fc66885394448b171fa1cce73d3ff85d0d87699b0da2985128a55eca55cf15701776d986ac4738bb8678cfe6f6cba41a0471c8b529b3b33d0
   #  PATCHES 
   #     fix-pkg-prefix.patch
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        fluidsynth SDLMIXER_MIDI_FLUIDSYNTH
        libflac SDLMIXER_FLAC
        libflac SDLMIXER_FLAC_LIBFLAC
        libmodplug SDLMIXER_MOD
        libmodplug SDLMIXER_MOD_MODPLUG
        mpg123 SDLMIXER_MP3
        mpg123 SDLMIXER_MP3_MPG123
        timidity SDLMIXER_MIDI_TIMIDITY
        wavpack SDLMIXER_WAVPACK
        wavpack SDLMIXER_WAVPACK_DSD
        libxmp SDLMIXER_MOD_XMP
        opusfile SDLMIXER_OPUS
)

if("fluidsynth" IN_LIST FEATURES OR "timidity" IN_LIST FEATURES)
    list(APPEND FEATURE_OPTIONS "-DSDL3MIXER_MIDI=ON")
else()
    list(APPEND FEATURE_OPTIONS "-DSDL3MIXER_MIDI=OFF")
endif()

if("fluidsynth" IN_LIST FEATURES)
    vcpkg_find_acquire_program(PKGCONFIG)
    list(APPEND EXTRA_OPTIONS "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}")
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        ${EXTRA_OPTIONS}
        -DSDLMIXER_VENDORED=OFF
        -DSDLMIXER_SAMPLES=OFF
        -DSDLMIXER_DEPS_SHARED=OFF
        -DSDLMIXER_OPUS_SHARED=OFF
        -DSDLMIXER_VORBIS_VORBISFILE_SHARED=OFF
        -DSDLMIXER_VORBIS="VORBISFILE"
        -DSDLMIXER_FLAC_DRFLAC=OFF
        -DSDLMIXER_MIDI_NATIVE=OFF
        -DSDLMIXER_MP3_DRMP3=OFF
        -DSDLMIXER_MOD_XMP_SHARED=${BUILD_SHARED}
    MAYBE_UNUSED_VARIABLES
        SDLMIXER_MP3_DRMP3
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
#vcpkg_cmake_config_fixup(
#    PACKAGE_NAME "SDL3_mixer"
#    CONFIG_PATH "lib/cmake/SDL3_mixer"
#)
vcpkg_fixup_pkgconfig()

#if(NOT VCPKG_BUILD_TYPE)
#    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/SDL3_mixer.pc" "-lSDL3_mixer" "-lSDL3_mixerd")
#endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
