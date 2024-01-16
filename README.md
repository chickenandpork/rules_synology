# Bazel Rules for Synology NAS Products

... or ...  Can we build SPKs with a Bazel Cross toolchain?

## Status

rules_synology is targeting the Denverton architecture initially -- it's what I have to test with
-- but new toolchains can be added on request (via github "Issues").  Minimum-Viable may be the
Denverton, but if you're willing to sign up as a tester, I'm willing to make changes to help you
unblock yourself.

## Overview

rules_synology offers a set of rules to work with Synology NAS products: cross-compile toolchains,
file-generation, image-manipulation, etc.  Rather than try to stuff one-off cases into, say,
rules_pkg, let's define them here and help keep things interoperable.

The short-term goal includes a basic build command such as:
```
bazel build //... --platforms=@rules_synology/models:ds918
```

The longer-term objective would be to allow as minimal initial config to define a package,
leveraging sensible defaults: perhaps a series of macros or facade-pattern wrappers to keep minimal
the user-investment to try these rules.  If the barrier-to-entry remains low, we can help more to
try this resource, helping as many as possible bring more cool things to Synology users.

... but right now, we're in Minimum-Viable-Product stage: cross-compile and package a binary tool
or service.

## Setup / Suggested Usage

The usage model needs some simplification -- and likely some bzlmod -- to be more approachable.
Current use, as confirmed by the `examples/cross-helloworld`, looks like:

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

http_archive(
    name = "rules_proto_grpc",
    sha256 = "928e4205f701b7798ce32f3d2171c1918b363e9a600390a25c876f075f1efc0a",
    strip_prefix = "rules_proto_grpc-4.4.0",
    urls = [
        "https://github.com/rules-proto-grpc/rules_proto_grpc/releases/download/4.4.0/rules_proto_grpc-4.4.0.tar.gz",
    ],
)

# Needed until https://github.com/bazelbuild/rules_pkg/issues/731 is resolved
local_repository(
    name = "patches",
    path = "../../patches",  # local path to @rules_synology//patches:rules_pkg-0.9.1.patch
)

http_archive(
    name = "rules_pkg",
    patch_args = ["-p1"],
    patches = [
        "@patches//:rules_pkg-0.9.1.patch",
    ],
    sha256 = "8f9ee2dc10c1ae514ee599a8b42ed99fa262b757058f65ad3c384289ff70c4b8",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz",
    ],
)

git_repository(
    name = "rules_synology",
    commit = "9e79430c176e94ad6f4e2f5ef38cb30697d3b7ca",
    remote = "https://github.com/chickenandpork/rules_synology.git",
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_repos", "rules_proto_grpc_toolchains")

rules_proto_grpc_toolchains()

rules_proto_grpc_repos()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

load("@rules_proto_grpc//:repositories.bzl", "bazel_gazelle", "io_bazel_rules_go")  # buildifier: disable=same-origin-load

io_bazel_rules_go()

bazel_gazelle()

load("@rules_proto_grpc//go:repositories.bzl", rules_proto_grpc_go_repos = "go_repos")

rules_proto_grpc_go_repos()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(
    version = "1.17.1",
)

# We likely don't need gazelle for this example as it's just a CC Hello World, but I'll plan to
# remove it when I've split this out to a Go Cross Example.

# gazelle:repo bazel_gazelle

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("//:bzl/go_dependencies.bzl", "go_dependencies")

# gazelle:repository_macro bzl/go_dependencies.bzl%go_dependencies
go_dependencies()

gazelle_dependencies()

load("@rules_synology//:deps.bzl", synology_deps = "deps")

synology_deps()

register_toolchains(
    "@rules_synology//toolchains:arm64_gcc_linux_x86_64",
    "@rules_synology//toolchains:denverton-gcc850_glibc226_x86_64-GPL",
)
```

So that WORKSPACE Needs to be simplified; if in doubt, refer to the example which is tested every
PR, but swap out the `local_repository(name="rules_synology", ...)` for the `git_repository()`




## References:
 - https://global.download.synology.com/download/Document/Software/DeveloperGuide/Firmware/DSM/All/enu/Synology_NAS_Server_3rd_Party_Apps_Integration_Guide.pdf
 - https://global.download.synology.com/download/Document/Software/DeveloperGuide/Package/SSOServer/All/enu/Synology_SSO_API_Guide.pdf
 - https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

### Older

 - https://global.download.synology.com/download/Document/Software/DeveloperGuide/Firmware/DSM/6.0/enu/DSM_Developer_Guide_6_0.pdf
 - https://help.synology.com/developer-guide/examples/compile_tmux.html
