# Build examples

These examples should be near-copy-paste functional as builds from which to base your own builds.
Checking the WORKSPACE for each, there should be simply a change from using the rules_synology as a
local_repository to a reference by version, URL, checksum to pull the rules from the canonical
releases.

## Currently

The current build command is (where cross toolchain is marked up/available, ie linux):

(cd examples/{example} && bazel build //... --platforms=@rules_synology//models:ds1819+ --incompatible_enable_cc_toolchain_resolution )

## Simplified by Pre-Built Container

A pre-built disk image simplifies the build, but only for Denverton currently: the
`tools/dockcross-linux-x86-bazel/Dockerfile` build file seeds the
`--platforms=@rules_synology//models:ds1819+` into the image, setting the default image.
Eventually, in CI, I'll need to demonstrate a matrix build covering each architecture mapped as a
`--platforms={single platform}`

## Submit-to-BCR Validation

In testing BCR submission, although I had difficulty simulating the exact environment in the
BuildKite containers, I *think* I got close with this:

```
DIR=$(mktemp -d)
IMAGE=ubuntu2204
docker run --rm -it \
    -v ~/src/rules_synology:/rules_synology \
    -v ${DIR}:/tmp \
    -w /rules_synology/examples/cross-helloworld gcr.io/bazel-public/${IMAGE}:latest \
  bazel test \
    --flaky_test_attempts=3 --build_tests_only --local_test_jobs=12 --show_progress_rate_limit=5 \
    --curses=yes --color=yes --terminal_columns=143 \
    --show_timestamps --verbose_failures \
    --jobs=30 --announce_rc --experimental_repository_cache_hardlinks \
    --sandbox_tmpfs_path=/tmp \
    --test_env=HOME --test_env=BAZELISK_USER_AGENT --test_env=USE_BAZEL_VERSION \
    --platforms=@rules_synology//models:ds1819+ --incompatible_enable_cc_toolchain_resolution \
  //...
```

Notice that although `--platforms=@rules_synology//models:ds1819+ --incompatible_enable_cc_toolchain_resolution`
is in the `.bazelrc`, I had to specify it on the command line as well. THere might be something
eclipsing the config or the RC file (--announce_rc still reports it, but moving "common" to "test"
looked promising)
