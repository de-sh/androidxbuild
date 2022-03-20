FROM ubuntu:20.04

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

COPY android-ndk.sh /
RUN /android-ndk.sh arm64 21
RUN /android-ndk.sh arm 21
RUN /android-ndk.sh x86 21
RUN /android-ndk.sh x86_64 21
RUN rm /android-ndk.sh
ENV PATH=$PATH:/android-ndk/bin

COPY android-system.sh /
RUN /android-system.sh arm64
RUN /android-system.sh arm
RUN /android-system.sh x86
RUN /android-system.sh x86_64

COPY qemu.sh /
RUN /qemu.sh aarch64
RUN /qemu.sh arm
RUN /qemu.sh i386
RUN /qemu.sh x86_64

RUN cp /android-ndk/sysroot/usr/lib/libz.so /system/lib/

# Libz is distributed in the android ndk, but for some unknown reason it is not
# found in the build process of some crates, so we explicit set the DEP_Z_ROOT
ENV CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android-gcc \
    CARGO_TARGET_ARM_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc \
    CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc \
    CARGO_TARGET_I686_LINUX_ANDROID_LINKER=i686-linux-android-gcc \
    CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER=x86_64-linux-android-gcc \
    CARGO_TARGET_AARCH64_LINUX_ANDROID_RUNNER=qemu-aarch64 \
    CARGO_TARGET_ARM_LINUX_ANDROIDEABI_RUNNER=qemu-arm \
    CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_RUNNER=qemu-arm \
    CARGO_TARGET_I686_LINUX_ANDROID_RUNNER="qemu-i386 -cpu n270" \
    CARGO_TARGET_X86_64_LINUX_ANDROID_RUNNER="qemu-x86_64 -cpu qemu64,+mmx,+sse,+sse2,+sse3,+ssse3,+sse4.1,+sse4.2,+popcnt" \
    CC_aarch64_linux_android=aarch64-linux-android-gcc \
    CC_arm_linux_androideabi=arm-linux-androideabi-gcc \
    CC_armv7_linux_androideabi=arm-linux-androideabi-gcc \
    CC_i686_linux_android=i686-linux-android-gcc \
    CC_x86_64_linux_android=x86_64-linux-android-gcc \
    CXX_aarch64_linux_android=aarch64-linux-android-g++ \
    CXX_arm_linux_androideabi=arm-linux-androideabi-g++ \
    CXX_armv7_linux_androideabi=arm-linux-androideabi-g++ \
    CXX_i686_linux_android=i686-linux-android-g++ \
    CXX_x86_64_linux_android=x86_64-linux-android-g++ \
    DEP_Z_INCLUDE=/android-ndk/sysroot/usr/include/ \
    RUST_TEST_THREADS=1 \
    HOME=/tmp/ \
    TMPDIR=/tmp/ \
    ANDROID_DATA=/ \
    ANDROID_DNS_MODE=local \
    ANDROID_ROOT=/system
