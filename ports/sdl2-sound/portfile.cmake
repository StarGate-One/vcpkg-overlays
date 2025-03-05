vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO icculus/SDL_sound
    REF  a7e7d1f6e9bdc5e813c696d13ba243706f8ccce3 #v2.0.2
    SHA512 13122f22a2011f8bf549ad3ff255c4723b290f7e4bed067422c0f56adfd83d31184b713a6978f50be58ba30032b841fd581fa9d461d267952eb0b80418b6ca78
    HEAD_REF main
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        shared        SDLSOUND_BUILD_SHARED
        static        SDLSOUND_BUILD_STATIC
        timidity      SDLSOUND_DECODER_MIDI
        tool          SDLSOUND_BUILD_TEST
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
	OPTIONS_DEBUG
        -DCMAKE_DEBUG_POSTFIX=d # SDL2_sound sets "d" for MSVC only.
)

vcpkg_cmake_install()
if(EXISTS "${CURRENT_PACKAGES_DIR}/cmake")
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL2_sound CONFIG_PATH cmake)
else()
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL2_sound CONFIG_PATH lib/cmake/SDL2_sound)
endif()

vcpkg_fixup_pkgconfig()

if ("tool" IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES
        playsound
        AUTO_CLEAN
    )
endif()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/licenses")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
