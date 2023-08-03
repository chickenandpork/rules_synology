load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_dependencies():
    go_repository(
        name = "com_github_disintegration_imaging",
        importpath = "github.com/disintegration/imaging",
        sum = "h1:w1LecBlG2Lnp8B3jk5zSuNqd7b4DXhcjwek1ei82L+c=",
        version = "v1.6.2",
    )
    go_repository(
        name = "org_golang_x_image",
#golang.org/x/image v0.0.0-20191009234506-e7c1f5e7dbb8 h1:hVwzHzIUGRjiF7EcUjqNxk3NCfkPxbDKRdnNE1Rpg0U=
#golang.org/x/image v0.0.0-20191009234506-e7c1f5e7dbb8/go.mod h1:FeLwcggjj3mMvU+oOTbSwawSJRM1uh48EjtB4UJZlP0=
        importpath = "golang.org/x/image",
        sum = "h1:hVwzHzIUGRjiF7EcUjqNxk3NCfkPxbDKRdnNE1Rpg0U=",
        version = "v0.0.0-20191009234506-e7c1f5e7dbb8",
    )
