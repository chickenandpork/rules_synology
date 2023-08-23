load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def deps():
    maybe(
        repo_rule = http_archive,
        name = "arm64_gcc_linux_x86_64",
        urls = ["https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"],
        strip_prefix = "arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu",
        sha256 = "6e8112dce0d4334d93bd3193815f16abe6a2dd5e7872697987a0b12308f876a4",
        build_file = "@rules_synology//toolchains:arm64_gcc_linux_x86_64.BUILD",
    )

    # URL from https://archive.synology.com/download/ToolChain/toolchain/7.1-42661
    maybe(
        repo_rule = http_archive,
        name = "denverton-gcc850_glibc226_x86_64-GPL",
        urls = [
            "https://global.synologydownload.com/download/ToolChain/toolchain/7.1-42661/Intel%20x86%20Linux%204.4.180%20%28Denverton%29/denverton-gcc850_glibc226_x86_64-GPL.txz",
        ],
        strip_prefix = "x86_64-pc-linux-gnu",
        # MD5 bb29ea30fe3fb44604e18a53ad020e67
        sha256 = "06e77a4fc703d5dd593f1ca7580ef65eca7335329dfeed44ff80789394d8f23c",
        build_file = "@rules_synology//toolchains:denverton-gcc850_glibc226_x86_64-GPL.BUILD",
    )
