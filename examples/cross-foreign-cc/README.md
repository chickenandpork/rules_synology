# Cross-Compile Example

This is intended to track the manual work needed for cross-compilation.

## Currently

The current build command is:

(cd examples/cross-helloworld && bazel build :main --platforms=@rules_synology//toolchains:toolchain_arm64_gcc --incompatible_enable_cc_toolchain_resolution )

## Updated

A slight update reduces the toil in testing on a linux/x86 container from this:

```
build --platforms=@rules_synology//models:ds1819+  --incompatible_enable_cc_toolchain_resolution --toolchain_resolution_debug=.*
```

... to this: the new command leverages a layer we add that offers a bazelisk binary as "bazel" and a
.bazelrc that "burns in" selection of the DS1819+ architecture, a Denverton (notice how the working
path is two subdirs into the workspace dir):

```
docker build -t test-x86 - < tools/dockcross-linux-x86-bazel/Dockerfile
docker run --rm -it -v $(pwd):/rules_synology -w /rules_synology/examples/cross-helloworld test-x86:latest /bin/bash
bazel build //...
```

The resulting bazel-bin/main -- actually at rules_synology/examples/cross-helloworld/bazel-bin/main
-- will be a Hello World that runs on a Denverton such as my DS1819+
