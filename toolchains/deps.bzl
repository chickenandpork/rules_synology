load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//toolchains:toolchains.bzl", _TOOLCHAINS = "TOOLCHAINS")

# https://kb.synology.com/en-global/DSM/tutorial/What_kind_of_CPU_does_my_NAS_have
PACKAGE_ARCHES = {v["package_arch"]: {"cpu": v["cpu"], "desc": v["arch_desc"]} for k, v in _TOOLCHAINS.items()}

def deps():
    maybe(
        repo_rule = http_archive,
        name = "arm64_gcc_linux_x86_64",
        urls = ["https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"],
        strip_prefix = "arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu",
        sha256 = "6e8112dce0d4334d93bd3193815f16abe6a2dd5e7872697987a0b12308f876a4",
        build_file = "//toolchains:arm64_gcc_linux_x86_64.BUILD",
    )

    for arch, parts in _TOOLCHAINS.items():
        print("define toolchain {}".format(arch))
        http_archive(
            name = arch,
            urls = [
                "https://global.synologydownload.com/download/ToolChain/toolchain/7.1-42661/{}/{}.txz".format(parts["subdir"], arch),
                "https://global.synologydownload.com/download/ToolChain/toolchain/{}/{}/{}.txz".format(
                    parts["dsm_version"],
                    parts["subdir"],
                    arch,
                ),
            ],
            strip_prefix = parts["prefix"],
            sha256 = parts["sha256"],
            build_file = "//toolchains:{}.BUILD".format(arch),
        )

TOOLCHAINS = _TOOLCHAINS.keys()
TOOLCHAINS_SHORT_LC = [v["common_name"].lower() for k, v in _TOOLCHAINS.items()]
TOOLCHAINS_PLUS_ARM = TOOLCHAINS + ["arm64_gcc_linux_x86_64"]
