# this referenced from the `maybe(.., name="denverton-gcc850_glibc226_x86_64-GPL", ..)` allows the binaries to be accessible from the Bazel target @denverton-gcc850_glibc226_x86_64-GPL//:all
#
# This is ultimately called via:
#
# # get the toolchains
# load("@rules_synology//:deps.bzl", synology_deps="deps")
# synology_deps()
#
# bazel build :main --platforms=@rules_synology//models:ds120j --incompatible_enable_cc_toolchain_resolution

load("@bazel_tools//tools/cpp:unix_cc_toolchain_config.bzl", "cc_toolchain_config")

filegroup(
    name = "all",
    srcs = glob(["**/*",]),
)

# this allows the cc_toolchain to be accessible from the Bazel target @armada37xx-gcc850_glibc226_armv8-GPL//:cc_toolchain
cc_toolchain(
    name = "cc_toolchain",
    all_files = ":all",
    ar_files = ":all",
    as_files = ":all",
    compiler_files = ":all",
    dwp_files = ":all",
    linker_files = ":all",
    objcopy_files = ":all",
    strip_files = ":all",
    static_runtime_lib = ":all",
    toolchain_config = ":_cc_toolchain_config",
)

cc_toolchain_config(
    name = "_cc_toolchain_config",
    cpu = "arm64",  # "armv8",
    compiler = "gcc",
    toolchain_identifier = "armada37xx-gcc850_glibc226_armv8-GPL",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "unknown",
    abi_version = "unknown",
    abi_libc_version = "unknown",
    tool_paths = {
        "gcc": "bin/aarch64-unknown-linux-gnu-gcc",
        "cpp": "bin/aarch64-unknown-linux-gnu-cpp",
        "ar": "bin/aarch64-unknown-linux-gnu-ar",
        "nm": "bin/aarch64-unknown-linux-gnu-nm",
        "ld": "bin/aarch64-unknown-linux-gnu-ld",
        "as": "bin/aarch64-unknown-linux-gnu-as",
        "objcopy": "bin/aarch64-unknown-linux-gnu-objcopy",
        "objdump": "bin/aarch64-unknown-linux-gnu-objdump",
        "gcov": "bin/aarch64-unknown-linux-gnu-gcov",
        "strip": "bin/aarch64-unknown-linux-gnu-strip",
        "llvm-cov": "/bin/false",
    },
    compile_flags = [
	"-no-canonical-prefixes",  # based on "-no_canonical_headers in https://github.com/bazelbuild/bazel/issues/4605#issuecomment-944882878 (heaff1)
        "-isystem", "external/armada37xx-gcc850_glibc226_armv8-GPL/lib/gcc/aarch64-unknown-linux-gnu/8.5.0/include",
        "-isystem", "external/armada37xx-gcc850_glibc226_armv8-GPL/aarch64-unknown-linux-gnu/include",
        "-isystem", "external/armada37xx-gcc850_glibc226_armv8-GPL/aarch64-unknown-linux-gnu/include/c++/8.5.0",
        "-isystem", "external/armada37xx-gcc850_glibc226_armv8-GPL/aarch64-unknown-linux-gnu/include/c++/8.5.0/aarch64-unknown-linux-gnu",
        "-isystem", "external/armada37xx-gcc850_glibc226_armv8-GPL/aarch64-unknown-linux-gnu/lib64",
        "-isystem", "external/armada37xx-gcc850_glibc226_armv8-GPL/aarch64-unknown-linux-gnu/sys-root/usr/include",
    ],
    link_flags = [],
)
