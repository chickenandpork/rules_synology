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
