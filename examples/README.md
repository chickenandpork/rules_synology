# Build examples

These examples should be near-copy-paste functional as builds from which to base your own builds.
Checking the WORSPACE for each, there should be simply a change from using the rules_synology as a
local_repository to a reference by version, URL, checksum to pull the rules from the canonical
releases.


## Currently

The current build command is (where cross toolchain is marked up/available, ie linux):

(cd examples/{example} && bazel build //... --platforms=@rules_synology//models:ds1819+ --incompatible_enable_cc_toolchain_resolution )

## Updated

A pre-built disk image simplifies the build, but only for Denverton currently: the
`tools/dockcross-linux-x86-bazel/Dockerfile` build file seeds the
`--platforms=@rules_synology//models:ds1819+` into the image, setting the default image.
Eventually, in CI, I'll need to demonstrate a matrix build covering each architecture mapped as a
`--platforms={single platform}`
