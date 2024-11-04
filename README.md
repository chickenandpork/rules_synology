# Bazel Rules for Synology NAS Products

... or ...  Can we build SPKs with a Bazel Cross toolchain?

## Status

rules_synology is targeting the Denverton architecture initially -- it's what I have to test with
-- but new toolchains can be added on request (via github "Issues").  Minimum-Viable may be the
Denverton, but if you're willing to sign up as a tester, I'm willing to make changes to help you
unblock yourself.

## Overview

rules_synology offers a set of rules to work with Synology NAS products: cross-compile toolchains,
file-generation, image-manipulation, etc.  Rather than try to stuff one-off cases into, say,
rules_pkg, let's define them here and help keep things interoperable.

The short-term goal includes a basic build command such as:

```
bazel build //... --platforms=@rules_synology/models:ds918-7.1
```

The longer-term objective would be to allow as minimal initial config to define a package,
leveraging sensible defaults: perhaps a series of macros or facade-pattern wrappers to keep minimal
the user-investment to try these rules.  If the barrier-to-entry remains low, we can help more to
try this resource, helping as many as possible bring more cool things to Synology users.

... but right now, we're in Minimum-Viable-Product stage: cross-compile and package a binary tool
or service.

## Setup / Suggested Usage

Simplest usage is a goal; currently, the recommended usage, as confirmed by the
`examples/cross-helloworld`, looks like:

(`MODULE.bazel`)

```
bazel_dep(name = "rules_synology", version = "0.0.1")

# If you need cross-build toolchains
register_toolchains("@rules_synology//toolchains:all")
```

In order to use this, you'll need to activate a specific platform at build (or in a `.bazelrc`):

```
bazel build --incompatible_enable_cc_toolchain_resolution --platforms=@rules_synology//models:ds1819+-7.1
```

...this it's down to creating a SPK.  At this stage, the easiest method forward is to look at the
examples in the `examples` directory.

## Testing

In order to ensure that the crosstool selection still works despite whatever changes, I've cut a
script that shows an example of running the cross-build, and confirming that the cross toolchain is
considered and ultimately chosen.

```
bash -x  examples/cross-helloworld/confirm-cross-selection.bash
```

## References:

- https://global.download.synology.com/download/Document/Software/DeveloperGuide/Firmware/DSM/All/enu/Synology_NAS_Server_3rd_Party_Apps_Integration_Guide.pdf
- https://global.download.synology.com/download/Document/Software/DeveloperGuide/Package/SSOServer/All/enu/Synology_SSO_API_Guide.pdf
- https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

### Older

- https://global.download.synology.com/download/Document/Software/DeveloperGuide/Firmware/DSM/6.0/enu/DSM_Developer_Guide_6_0.pdf
- https://help.synology.com/developer-guide/examples/compile_tmux.html
