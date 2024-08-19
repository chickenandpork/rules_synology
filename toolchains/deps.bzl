load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# URL from https://archive.synology.com/download/ToolChain/toolchain/7.1-42661
syno_toolchains ={
    "denverton-gcc850_glibc226_x86_64-GPL": {
        "common_name": "Denverton",
        "prefix": "x86_64-pc-linux-gnu",
        "sha256": "06e77a4fc703d5dd593f1ca7580ef65eca7335329dfeed44ff80789394d8f23c",
    },
    "geminilake-gcc850_glibc226_x86_64-GPL": {
        "common_name": "GeminiLake",
        "prefix": "x86_64-pc-linux-gnu",
        "sha256": "653789339d20262c31546371ab457d99faff88729e16cf91f3f7cced5606daf6",
    },
}

def deps():
    maybe(
        repo_rule = http_archive,
        name = "arm64_gcc_linux_x86_64",
        urls = ["https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"],
        strip_prefix = "arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu",
        sha256 = "6e8112dce0d4334d93bd3193815f16abe6a2dd5e7872697987a0b12308f876a4",
        build_file = "@rules_synology//toolchains:arm64_gcc_linux_x86_64.BUILD",
    )

    for arch, parts in syno_toolchains.items():
        print("define toolchain {}".format(arch))
        maybe(
            repo_rule = http_archive,
            name = arch,
            urls = [
                "https://global.synologydownload.com/download/ToolChain/toolchain/7.1-42661/Intel%20x86%20Linux%204.4.180%20%28{}%29/{}.txz".format(parts["common_name"], arch),
            ],
            strip_prefix = parts["prefix"],
            sha256 = parts["sha256"],
            build_file = "@rules_synology//toolchains:{}.BUILD".format(arch),
        )

TOOLCHAINS = syno_toolchains.keys()
TOOLCHAINS_SHORT_LC = [ v["common_name"].lower() for k,v in syno_toolchains.items()]
TOOLCHAINS_PLUS_ARM = TOOLCHAINS + [ "arm64_gcc_linux_x86_64" ]
