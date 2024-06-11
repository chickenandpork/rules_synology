load("@bazel_skylib//rules:copy_file.bzl", "copy_file")

# this was originally loaded from "@rules_pkg//:pkg.bzl" but no bzl_library for that file
load("@rules_pkg//pkg/private/tar:tar.bzl", "pkg_tar")

# This set of functions allows population of a docker project struct inside the resource file:
#
# # resource file
# {
#   ...
#   "docker-project": {
#       "preload-image": "image.tar.gz",  # expect a ./image.tar.gz, likely a docker-import format of an image?
#       "projects": [{
#           "name": "bazel-buildfarm",
#           "path": "bfm"  # expect a ./bfm/compose.yaml
#       }, {
#           ...
#       }]
#   }
#   ...
# }
#
# These functions convert the given values to their markup in the resource file.  We leave open the
# possibility or sanity-checking at build time that there is, for example, a compose.yaml in the
# given path(s), or an exported docker image if specified.
#
# All values for "preload-image", "path" should be relative to the "target" directory into which
# the payload is unpacked: /var/packages/<pkgname>/target/

DockerProject = provider(
    fields = {
        "preload_image": "A docker image stream that can be 'docker load' to the local docker engine before activating the compose action",
        "projects": "A list of { name, path } naming compose projects and the relative paths containing them",
        "struct": "A verbatim instance of a 'docker-project' for the resource file: encompasses both preload_image and projects",
    },
)

DockerCompose = provider(
    fields = {
        "name": "A human-readable name for a docker-compose definition",
        "file": "The file that carries the docker-compose for this definition",
        "path": "The path of the compose file",
    },
)

def _docker_project_impl(ctx):
    #files = []  # accumulates depsets
    #for d in ctx.attr.projects:
    #    f = d[DefaultInfo]
    #    files.append(f.files)
    rez_struct = {"projects": [{"name": p[DockerCompose].name, "path": p[DockerCompose].path} for p in ctx.attr.projects]}
    if ctx.attr.preload_image:
        rez_struct.update({"preload-image": ctx.attr.preload_image})

    return [
        DefaultInfo(files = depset(transitive = [d[DefaultInfo].files for d in ctx.attr.projects])),  # collect the docker_compose outputs as transitive
        DockerProject(
            preload_image = ctx.attr.preload_image or None,
            projects = {p[DockerCompose].name: p[DockerCompose].path for p in ctx.attr.projects},
            struct = rez_struct,
        ),
    ]

doc = """
## Configure a collection of Docker Projects

The Docker Project is a [Worker](glossary.md#worker) that carries one or more docker-compose
definitions into a Synology NAS, and can be used to turn-up the project defined in the compose
files.

Each project's name and compose file are represented as a `docker_compose()` target; these targets
are collected in an list `projects` in a `docker_project()` target.

For example:

(`BUILD` file)
```
docker_compose(
    name = "nginx"
    compose = ":dc.yaml",
)

docker_compose(
    name = "cryptobot"
    compose = ":some_other_compose.yaml",
)

docker_project(
    name = "green_stack",
    projects = [ ":nginx", "cryptobot" ]
)
```

References:

- [Synology: Docker Project](https://help.synology.com/developer-guide/resource_acquisition/docker-project.html)
"""

docker_project = rule(
    doc = doc,
    implementation = _docker_project_impl,
    attrs = {
        "preload_image": attr.string(
            mandatory = False,
            doc = "OCI/Docker image to preload at install of the SPK",
        ),
        "projects": attr.label_list(
            mandatory = False,
            providers = [DockerCompose],
            doc = "List of docker_compose() targets to bundle to this project",
        ),
    },
)

def _docker_compose_impl(ctx):
    """This implementation merely passes along the values in a provided structure, relying on
    dependency to cause the matching packaging
    """

    return [
        DefaultInfo(files = depset([ctx.file.compose_tar])),
        DockerCompose(
            name = ctx.attr.project_name,
            file = ctx.file.compose_tar,
            path = ctx.attr.path,
        ),
    ]

_docker_compose = rule(
    doc = """The Docker Project Worker needs a list of possible projects as a name/path tuple.
    Lacking a way of giving a list of items, I've created this to track the compose (converted to
    tars) and projects so that they can be collated to a single docker-project entry to control the
    Docker-Project Worker provided by ContainerManager.

    _docker_compose is called by the docker_compose function, which createdtargets for tarballs
    of compose files and these rules to generate Providers that can be consumed by docker_project()
    """,
    implementation = _docker_compose_impl,
    attrs = {
        # using the upstream name as the name of the project
        "compose_tar": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "the tarfile in containing a {project}/compose.taml of aa docker-compose file for this project",
        ),
        "path": attr.string(
            mandatory = True,
            doc = "the path of the project's <path>/compose.yaml in the tarball",
        ),
        "project_name": attr.string(
            mandatory = True,
            doc = "the project name of the docker_compose corresponding to the project's <path>/compose.yaml in the tarball",
        ),
    },
)

def docker_compose(name, compose, project_name = None, path = None, debug = False):
    """
    ## Configure a single Docker Project (a docker-compose)

    The Docker Project is a [Worker](glossary.md#worker) that carries one or more docker-compose
    definitions into a Synology NAS, and can be used to turn-up the project defined in the compose
    files.

    The Synology Docker Project Worker expects a name and a compose file for each project.
    docker_compose() is used to provide a name/compose pair, which are then collected in a
    docker_project() target:

    (`BUILD` file)
    ```
    docker_compose(
        name = "nginx"
        compose = ":dc.yaml",
    )

    docker_compose(
        name = "cryptobot"
        compose = ":some_other_compose.yaml",
    )

    docker_project(
        name = "green_stack",
        projects = [ ":nginx", "cryptobot" ]
    )
    ```

    References:

    - [Synology: Docker Project](https://help.synology.com/developer-guide/resource_acquisition/docker-project.html)
    """

    path = path or name
    if debug:  # yeah, I went oldschool on debugging.  left it in for further development
        print("name is: " + name)
        print("path is: " + path)
        print("compose is: " + compose)

    # this copy is here because the remap_paths only handles known path prefixes; the compose file
    # provides may be a file, may be a derived object built by another target, so the path is
    # unknown at initial parse time.
    copy_file(name = "_compose_remap_{}".format(path), src = compose, out = "{}/compose.yaml".format(path))

    # Now the bog-standard tar rule does the actual work: really a one-file archive that can be
    # stacked with others at build-time.  This tar simply wraps up the compose file to be
    # <path>/compose.yaml as a tar
    pkg_tar(
        name = "_compose_tarfile_{}".format(path),
        srcs = ["_compose_remap_{}".format(path)],
        package_dir = path,
    )

    _docker_compose(name = name, compose_tar = "_compose_tarfile_{}".format(path), path = path, project_name = project_name or name)
