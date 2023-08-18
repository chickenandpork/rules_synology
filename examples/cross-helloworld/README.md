# Cross-Compile Example

This is intended to track the manual work needed for cross-compilation.

## Currently

The current build command is:

(cd examples/cross-helloworld && bazel build :main --platforms=@rules_synology//toolchains:toolchain_arm64_gcc --incompatible_enable_cc_toolchain_resolution )

