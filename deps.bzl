load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@rules_synology//toolchains:deps.bzl", toolchain_deps = "deps")

def deps():
    maybe(
        repo_rule = http_archive,
        name = "com_github_aignas_rules_shellcheck",
        sha256 = "4e7cc56d344d0adfd20283f7ad8cb4fba822c0b15ce122665b00dd87a27a74b6",
        strip_prefix = "rules_shellcheck-0.1.1",
        url = "https://github.com/aignas/rules_shellcheck/archive/refs/tags/v0.1.1.tar.gz",
    )

    toolchain_deps()
