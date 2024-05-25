# android-libjpeg-turbo
Build libjpeg-turbo for android with ndk-build
ABIS=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")

| Script        | Platform        | Description                                   |
|---------------|-----------------|-----------------------------------------------|
| build.sh      | Linux, macOS    | Builds the project for Linux and macOS.       |
| ndk-build.sh  | Android         | Builds the project using Android NDK.  

### 0. prerequisite
1. install android studio
2. install android sdk
3. install android ndk


### 1. git clone

```
$ git clone --recursive https://github.com/tuxxon/android-libjpeg-turbo.git
```

### 2. Buid libjpeg-turbo for android

```
$ ./ndk-build.sh
```

if you use build.sh in this repo, then you just can get the result of c libraries.

### 3. Look at output directory

```
$ cd libjpeg-turbo/build/android
$ ls -al
```