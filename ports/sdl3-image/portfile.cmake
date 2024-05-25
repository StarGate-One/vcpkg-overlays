vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libsdl-org/SDL_image
    REF 2fc5310a9a2700fc856663200f94edebeb5e554a
    SHA512 e84fe135d711ea44f145dbc0e4f62b265742b0270f10eae07782ff62f82609a553cc347e11d7ffddb1ab1a21da5de2707b9473f771147be761bf94f1f4d7d694
    HEAD_REF main
    PATCHES 
    #    fix-findwebp.patch
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        aom           SDL3IMAGE_AOM
        dav1d         SDL3IMAGE_DAV1D
        libavif       SDL3IMAGE_AVIF
        libjxl        SDL3IMAGE_JXL
        libpng        SDL3IMAGE_PNG
        libjpeg-turbo SDL3IMAGE_JPG
        libwebp       SDL3IMAGE_WEBP
        #stb
        tiff          SDL3IMAGE_TIF
        zlib          SDL3IMAGE_ZLIB
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSDL3IMAGE_BACKEND_IMAGEIO=OFF
        -DSDL3IMAGE_BACKEND_STB=OFF
        -DSDL3IMAGE_DEPS_SHARED=OFF
        -DSDL3IMAGE_SAMPLES=OFF
        -DSDL3IMAGE_VENDORED=OFF
        -DSDL3IMAGE_ZLIB=ON
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if(EXISTS "${CURRENT_PACKAGES_DIR}/cmake")
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_image CONFIG_PATH cmake)
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/SDL3_image.framework/Resources")
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_image CONFIG_PATH SDL3_image.framework/Resources)
else()
    vcpkg_cmake_config_fixup(PACKAGE_NAME SDL3_image CONFIG_PATH lib/cmake/SDL3_image)
endif()

vcpkg_fixup_pkgconfig()

if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/SDL3-image.pc" "-lSDL3_image" "-lSDL3_imaged")
endif()

file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/SDL3_image.framework"
    "${CURRENT_PACKAGES_DIR}/debug/SDL3_image.framework"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
