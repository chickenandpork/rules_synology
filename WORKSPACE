workspace(name="rules_synology")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "bazel_gazelle",
    sha256 = "29218f8e0cebe583643cbf93cae6f971be8a2484cdcfa1e45057658df8d54002",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.32.0/bazel-gazelle-v0.32.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.32.0/bazel-gazelle-v0.32.0.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
    ],
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "278b7ff5a826f3dc10f04feaf0b70d48b68748ccd512d7f98bf442077f043fe3",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.41.0/rules_go-v0.41.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.41.0/rules_go-v0.41.0.zip",
    ],
)

http_archive(
    name = "rules_pkg",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz",
    ],
    sha256 = "8f9ee2dc10c1ae514ee599a8b42ed99fa262b757058f65ad3c384289ff70c4b8",
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

#load("@rules_synology//synology:deps.bzl", "deps")
# deps()

# Toolchain to bring in a binary to test packaging
load("//toolchains/bazelisk:deps.bzl", bazelisk_deps = "deps")

bazelisk_deps()
