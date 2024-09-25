# this referenced from the `maybe(.., name="denverton-gcc850_glibc226_x86_64-GPL", ..)` allows the binaries to be accessible from the Bazel target @denverton-gcc850_glibc226_x86_64-GPL//:all
#
# This is ultimately called via:
#
# # get the toolchains
# load("@rules_synology//:deps.bzl", synology_deps="deps")
# synology_deps()
#
# bazel build :main --platforms=@rules_synology//models:ds1819+ --incompatible_enable_cc_toolchain_resolution

load("@bazel_tools//tools/cpp:unix_cc_toolchain_config.bzl", "cc_toolchain_config")

filegroup(
    name = "all",
    srcs = glob(["**/*",]),
)

# this allows the cc_toolchain to be accessible from the Bazel target @denverton-gcc850_glibc226_x86_64-GPL//:cc_toolchain
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
    cpu = "x86_64",
    compiler = "gcc",
    toolchain_identifier = "denverton-gcc850_glibc226_x86_64-GPL",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "unknown",
    abi_version = "unknown",
    abi_libc_version = "unknown",
    tool_paths = {
        "gcc": "bin/x86_64-pc-linux-gnu-gcc",
        "cpp": "bin/x86_64-pc-linux-gnu-cpp",
        "ar": "bin/x86_64-pc-linux-gnu-ar",
        "nm": "bin/x86_64-pc-linux-gnu-nm",
        "ld": "bin/x86_64-pc-linux-gnu-ld",
        "as": "bin/x86_64-pc-linux-gnu-as",
        "objcopy": "bin/x86_64-pc-linux-gnu-objcopy",
        "objdump": "bin/x86_64-pc-linux-gnu-objdump",
        "gcov": "bin/x86_64-pc-linux-gnu-gcov",
        "strip": "bin/x86_64-pc-linux-gnu-strip",
        "llvm-cov": "/bin/false",
    },
    compile_flags = [
	"-no-canonical-prefixes",  # based on "-no_canonical_headers in https://github.com/bazelbuild/bazel/issues/4605#issuecomment-944882878 (heaff1)
        "-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/lib/gcc/x86_64-pc-linux-gnu/8.5.0/include",
        "-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/include",
        "-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/include/c++/8.5.0",
        "-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/include/c++/8.5.0/x86_64-pc-linux-gnu",
        "-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/lib64",
        "-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include",
        #"-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits",
        #"-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/sys",
        #"-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/gnu",
        #"-isystem", "external/denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/types",
    ],
    # x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/include/bits/syslog.h
    # cxx_builtin_include_directories = [
    #     "x86_64-pc-linux-gnu/x86_64-pc-linux-gnu",
    #     "usr/include",
    #     "sys-root/usr/include",
    #     "x86_64-pc-linux-gnu/sys-root/usr/include",
    #     "./x86_64-pc-linux-gnu/sys-root/usr/include",
    #     "@@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include",
    #     "external/rules_synology~~synology_deps~denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include",
    #     "denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/stdio.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/libc-header-start.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/features.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/sys/cdefs.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/wordsize.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/long-double.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/gnu/stubs.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/gnu/stubs-64.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/lib/gcc/x86_64-pc-linux-gnu/8.5.0/include/stddef.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/types.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/typesizes.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/types/__FILE.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/types/FILE.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/libio.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/_G_config.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/types/__mbstate_t.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/lib/gcc/x86_64-pc-linux-gnu/8.5.0/include/stdarg.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/stdio_lim.h",
    #     "@denverton-gcc850_glibc226_x86_64-GPL/x86_64-pc-linux-gnu/sys-root/usr/include/bits/sys_errlist.h",
    # ],
    link_flags = [],
)
