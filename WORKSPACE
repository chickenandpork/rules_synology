workspace(name = "rules_synology")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "bazel_gazelle",
    sha256 = "8ad77552825b078a10ad960bec6ef77d2ff8ec70faef2fd038db713f410f5d87",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.38.0/bazel-gazelle-v0.38.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.38.0/bazel-gazelle-v0.38.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
    ],
)

http_archive(
    name = "com_github_aignas_rules_shellcheck",
    sha256 = "936ece8097b734ac7fab10f833a68f7d646b4bc760eb5cde3ab17beb85779d50",
    strip_prefix = "rules_shellcheck-0.3.3",
    url = "https://github.com/aignas/rules_shellcheck/archive/refs/tags/0.3.3.tar.gz",
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "d93ef02f1e72c82d8bb3d5169519b36167b33cf68c252525e3b9d3d5dd143de7",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.49.0/rules_go-v0.49.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.49.0/rules_go-v0.49.0.zip",
    ],
)

http_archive(
    name = "rules_pkg",
    sha256 = "d20c951960ed77cb7b341c2a59488534e494d5ad1d30c4818c736d57772a9fef",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/1.0.1/rules_pkg-1.0.1.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/1.0.1/rules_pkg-1.0.1.tar.gz",
    ],
)

http_file(
    name = "screaming_goat",
    sha256 = "030c1aadeaf9b7b01b27d4966a64173fbfe2e0eea2ec3577543fb8838c3013f0",
    urls = [
        "https://dehayf5mhw1h7.cloudfront.net/wp-content/uploads/sites/816/2019/01/22193028/Screaming-Goat-832-832x476.jpg",
    ],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

load("@com_github_aignas_rules_shellcheck//:deps.bzl", "shellcheck_dependencies")

shellcheck_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@io_bazel_rules_go//go:deps.bzl", "go_download_sdk", "go_register_toolchains", "go_rules_dependencies")

# We give the SDK keys and SHA256s to reduce the delay during Analysis to hit a remote server and
# dynamically choose from its responses.  Also avoids impact of sunset versions disappearing from
# the live query we're processing.
go_download_sdk(
    name = "go_sdk",
    sdks = {
        # NOTE: In most cases the whole sdks attribute is not needed.
        # There are 2 "common" reasons you might want it:
        #
        # 1. You need to use an modified GO SDK, or an unsupported version
        #    (for example, a beta or release candidate)
        #
        # 2. You want to avoid the dependency on the index file for the
        #    SHA-256 checksums. In this case, You can get the expected
        #    filenames and checksums from https://go.dev/dl/
        "linux_amd64": ("go1.22.4.linux-amd64.tar.gz", "ba79d4526102575196273416239cca418a651e049c2b099f3159db85e7bade7d"),
        "darwin_amd64": ("go1.22.4.darwin-amd64.tar.gz", "c95967f50aa4ace34af0c236cbdb49a9a3e80ee2ad09d85775cb4462a5c19ed3"),
        "darwin_arm64": ("go1.22.4.darwin-arm64.tar.gz", "242b78dc4c8f3d5435d28a0d2cec9b4c1aa999b601fb8aa59fb4e5a1364bf827"),
    },
    version = "1.22.4",
)

go_rules_dependencies()

go_register_toolchains()  # version defaults to that given in ":go_sdk" above

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("//:bzl/go_dependencies.bzl", "go_dependencies")

# gazelle:repository_macro bzl/go_dependencies.bzl%go_dependencies
go_dependencies()

gazelle_dependencies(
    go_repository_default_config = "@//:WORKSPACE",
    go_sdk = "go_sdk",
)

#
# Toolchains
#

load("@rules_synology//:deps.bzl", synology_deps = "deps")

synology_deps()

load("@rules_synology//:go_deps.bzl", synology_go_deps = "deps")

synology_go_deps()

# Toolchain to bring in a binary to test packaging
load("//toolchains/bazelisk:deps.bzl", bazelisk_deps = "deps")

bazelisk_deps()
