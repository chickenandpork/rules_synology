# SPK Build example: Docker Project(s)

This example is intended to show how to package docker-compose files as "docker-project" markup in
a resources file, which should then be activated at install time.  This process is intended to
avoid the user knowing the intricacies and internals of SPK packaging, and by creating this
wrapper, allows the implementation a chance to improve while keeping the API constant, or simplify
the "API" available to the user to package a docker-compose files.

In this example, the user should indicate a name of a project and a file that should become the
docker-compose file.  Rules_synology may later validate the yaml itself or validate the content
against a schema to push error-discovery closer to the author, but this won't be a criterion for
minimum-ship.

## Currently

The current build command is:

(cd examples/example-docker-project && bazel build //... )

