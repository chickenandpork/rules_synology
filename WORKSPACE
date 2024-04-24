workspace(name = "rules_synology")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "bazel_gazelle",
    sha256 = "75df288c4b31c81eb50f51e2e14f4763cb7548daae126817247064637fd9ea62",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.36.0/bazel-gazelle-v0.36.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.36.0/bazel-gazelle-v0.36.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "41449d7c7372d2e270e8504dfab09ee974325b0b40fdd98172c7fbe257b8bcc9",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.6.0/bazel-skylib-1.6.0.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.6.0/bazel-skylib-1.6.0.tar.gz",
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
    sha256 = "af47f30e9cbd70ae34e49866e201b3f77069abb111183f2c0297e7e74ba6bbc0",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.47.0/rules_go-v0.47.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.47.0/rules_go-v0.47.0.zip",
    ],
)

http_archive(
    name = "rules_pkg",
    sha256 = "d250924a2ecc5176808fc4c25d5cf5e9e79e6346d79d5ab1c493e289e722d1d0",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.10.1/rules_pkg-0.10.1.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.10.1/rules_pkg-0.10.1.tar.gz",
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
        "linux_amd64": ("go1.19.5.linux-amd64.tar.gz", "36519702ae2fd573c9869461990ae550c8c0d955cd28d2827a6b159fda81ff95"),
        "darwin_amd64": ("go1.19.5.darwin-amd64.tar.gz", "23d22bb6571bbd60197bee8aaa10e702f9802786c2e2ddce5c84527e86b66aa0"),
        "darwin_arm64": ("go1.19.5.darwin-arm64.tar.gz", "4a67f2bf0601afe2177eb58f825adf83509511d77ab79174db0712dc9efa16c8"),
    },
    #goos = "linux",
    #goarch = "amd64",
    version = "1.19.5",
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
