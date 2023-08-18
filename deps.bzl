load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_gazelle//:deps.bzl", "go_repository")

def deps():
    maybe(
        repo_rule=http_archive,
        name = "com_github_aignas_rules_shellcheck",
        sha256 = "4e7cc56d344d0adfd20283f7ad8cb4fba822c0b15ce122665b00dd87a27a74b6",
        strip_prefix = "rules_shellcheck-0.1.1",
        url = "https://github.com/aignas/rules_shellcheck/archive/refs/tags/v0.1.1.tar.gz",
    )

    maybe(
        repo_rule = go_repository,
        name="com_github_disintegration_imaging",
        importpath = "github.com/disintegration/imaging",
        sum = "h1:w1LecBlG2Lnp8B3jk5zSuNqd7b4DXhcjwek1ei82L+c=",
        version = "v1.6.2",
    )

    maybe(
        repo_rule=go_repository,
        name = "org_golang_x_image",
        importpath = "golang.org/x/image",
        sum = "h1:hVwzHzIUGRjiF7EcUjqNxk3NCfkPxbDKRdnNE1Rpg0U=",
        version = "v0.0.0-20191009234506-e7c1f5e7dbb8",
    )

    maybe(
        repo_rule=http_archive,
        name = "arm64_gcc_linux_x86_64",
        urls = ["https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"],
        strip_prefix = "arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu",
        sha256 = "6e8112dce0d4334d93bd3193815f16abe6a2dd5e7872697987a0b12308f876a4",
        build_file = "@rules_synology//toolchains:arm64_gcc_linux_x86_64.BUILD",
    )
