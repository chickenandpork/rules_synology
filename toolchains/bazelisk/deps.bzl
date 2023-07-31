# Downloadable pre-built toolchains

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("//toolchains/bazelisk:name-version-sha.bzl", "preferred_release")

def deps():
    """
    Convenience array/list of `http_file` definitions suitable for a WORKSPACE but allows changes
    to the list of arch binaries to be self-contained in the toolchain dir.

    Returns a list of http_file similar to:

    http_file(
        name = "bazelisk-darwin-amd64",

        executable = True,
        sha256 = "...",
        urls = [ "..." ],
    )

    http_file(
        name = "bazelisk-darwin-arm64",
        ...
    )
    """

    p = preferred_release()
    for a in p:
        name = a.replace("-", "_")
        http_file(name = name, urls = [p[a]["url"]], sha256 = p[a]["sha256"], executable = True)
