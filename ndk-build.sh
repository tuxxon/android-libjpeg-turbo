# Set these variables to suit your needs
NDK_PATH=$NDK/23.1.7779620
TOOLCHAIN=clang
ANDROID_VERSION=23
ABIS=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")  # 원하는 ABI 목록

# Define the source directory
CURRENT_DIR=$(pwd)
SOURCE_DIR=${CURRENT_DIR}/libjpeg-turbo

# Loop through each ABI and build
for ABI in "${ABIS[@]}"; do
    # Create a build directory for each ABI
    BUILD_DIR=${SOURCE_DIR}/build/android/$ABI
    mkdir -p $BUILD_DIR
    cd $BUILD_DIR

    # Set the correct compiler prefix based on ABI
    if [ "$ABI" == "arm64-v8a" ]; then
        COMPILER_PREFIX="aarch64-linux-android"
    elif [ "$ABI" == "armeabi-v7a" ]; then
        COMPILER_PREFIX="armv7a-linux-androideabi"
    elif [ "$ABI" == "x86" ]; then
        COMPILER_PREFIX="i686-linux-android"
    elif [ "$ABI" == "x86_64" ]; then
        COMPILER_PREFIX="x86_64-linux-android"
    fi

    # Run CMake with the appropriate flags
    cmake -G"Unix Makefiles" \
        -DANDROID_ABI=${ABI} \
        -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
        -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
        -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
        -DCMAKE_MAKE_PROGRAM=$(which make) \
        -DCMAKE_C_COMPILER=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin/${COMPILER_PREFIX}${ANDROID_VERSION}-clang \
        -DCMAKE_CXX_COMPILER=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64/bin/${COMPILER_PREFIX}${ANDROID_VERSION}-clang++ \
        $SOURCE_DIR

    # Run make to build the project
    make

    # Optionally, copy built libraries to a lib directory
    LIB_DIR=${SOURCE_DIR}/build/android/libs/$ABI
    mkdir -p $LIB_DIR
    cp *.so $LIB_DIR
    cp *.a $LIB_DIR
done

# Create include directory if it doesn't exist
INCLUDE_DIR=${SOURCE_DIR}/build/android/include
mkdir -p $INCLUDE_DIR
# Copy header files to the include directory
cp ${SOURCE_DIR}/*.h $INCLUDE_DIR
cp ${SOURCE_DIR}/build/*.h $INCLUDE_DIR