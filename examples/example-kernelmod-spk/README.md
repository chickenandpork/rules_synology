# SPK Build example: Kernel Mods

This example is intended to show how to package pre-compiled kernel mods as SPK for installation.
As the process simplifies, this example should reflect that simplification.

In this example, the kernel mods are built using a simple github-action-managed cross-build that is
separated due to the complexity of a crossbuild.  It would be awesome if I could wrap that in a
Bazel job, but it's not trivial yet today, so this is a remote job.  The resulting build has a
validating checking, and is cached between builds.  It should cache on a bazel remote/federated
cache, if the size isn't an issue for the cache.

## Currently

The current build command is:

(cd examples/example-kernelmod-spk && bazel build //... --platforms=@rules_synology//models:ds1819+ --incompatible_enable_cc_toolchain_resolution )

## Updated

A slight update reduces the toil in testing on a linux/x86 container from this:
```
bazel build --platforms=@rules_synology//models:ds1819+  --incompatible_enable_cc_toolchain_resolution --toolchain_resolution_debug=.* //...
```

This is perfectly functional in a non-linux environment that may lack cross toolchain coverage
because it's using the architecture to select a pre-built if available.  Compilation during the
build is tools arch, ie things that run on the build host, not binaries for execution on the
target platform.

We can, however, still pursue a container build for isolation, similar to the cross-helloworld
example:

```
docker build -t test-x86 - < tools/dockcross-linux-x86-bazel/Dockerfile
docker run --rm -it \
    -v /tmp/bazel_out:/out \
    -v ~/src/rules_synology:/rules_synology \
    -w /rules_synology/examples/example-kernelmod-spk \
    test-x86:latest bash
bazel --output_user_root=/out/x build --incompatible_strict_action_env --remote_cache=grpc://<cache_host>:9092/ //...
```

The resulting bazel-bin/spk/netfilter-mods/netfilter-mods.spk -- actually at
rules_synology/examples/example-kernelmod-spk/bazel-bin/spk/netfilter-mods/netfilter-mods.spk in a
normal build, or /tmp/bazel_out/x/bazel-bin/spk/netfilter-mods/netfilter-mods.spk in a container
with the output_user_root remapped -- will be an SPK that provides the kernel mods to have a proper
netfilter module.
