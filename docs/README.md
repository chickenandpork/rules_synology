# Documentation Maintenance

Updating and previewing the documentation content is a three-terminal affair:

1. edit terminal, editing synology/\*bzl et al
1. terminal running `ibazel run //docs:collate_docs`
1. terminal running `cd docs && mkdocs serve -o`
1. (previous item will open a browser to the rendered docs)

NOTE: until `bazel-watcher` has `bzlmod` compatibility, you may need an empty //:WORKSPACE file
