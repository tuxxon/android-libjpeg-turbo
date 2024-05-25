# Set these variables to suit your needs
NDK_PATH=$NDK/21.4.7075529
TOOLCHAIN=clang
ANDROID_VERSION=21
ABIS=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")  # ABI list

# Define the source directory
CURRENT_DIR=$(pwd)
SOURCE_DIR=${CURRENT_DIR}/libjpeg-turbo

# Loop through each ABI and build
for ABI in "${ABIS[@]}"; do
    # Create a build directory for each ABI
    BUILD_DIR=${SOURCE_DIR}/build/android/$ABI
    mkdir -p $BUILD_DIR
    cd $BUILD_DIR

    # Run CMake with the appropriate flags
    cmake -G"Unix Makefiles" \
        -DANDROID_ABI=${ABI} \
        -DANDROID_ARM_MODE=arm \
        -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
        -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
        -DCMAKE_ASM_FLAGS="--target=aarch64-linux-android${ANDROID_VERSION}" \
        -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
        -DCMAKE_MAKE_PROGRAM=$(which make) \
        -DCMAKE_C_COMPILER=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android${ANDROID_VERSION}-clang \
        -DCMAKE_CXX_COMPILER=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android${ANDROID_VERSION}-clang++ \
        $SOURCE_DIR

    # Run make to build the project
    make
done
