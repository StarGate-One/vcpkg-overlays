vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsdl-org/SDL_shadercross
    REF 6b06e55c7c5d7e7a09a8a14f76e866dcfad5ab99
    SHA512 f90c18b6804c273f5aa869bf5c9845086eb4203e919c16aca792189f08ebcb53c5a33316c7617ac549db6abf5fc0424deb1769e5960be24de2c0eae35464a60e
    HEAD_REF main
    PATCHES
        fix-directx-shader-compiler-includes.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSDLSHADERCROSS_INSTALL=ON
        -DSDLSHADERCROSS_INSTALL_CMAKEDIR_ROOT=share/sdl3_shadercross
        -DSDLSHADERCROSS_INSTALL_RUNTIME=OFF
        -DSDLSHADERCROSS_SPIRVCROSS_SHARED=OFF
        -DSDLSHADERCROSS_VENDORED=OFF
)

vcpkg_cmake_install()
if (VCPKG_TARGET_IS_WINDOWS)
    vcpkg_cmake_config_fixup(PACKAGE_NAME "sdl3_shadercross")
else()
    vcpkg_cmake_config_fixup(PACKAGE_NAME "sdl3_shadercross" CONFIG_PATH "share/sdl3_shadercross/SDL3_shadercross")
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

vcpkg_copy_tools(TOOL_NAMES shadercross AUTO_CLEAN)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
