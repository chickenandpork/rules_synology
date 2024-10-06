"""Provides the toolchains:
 - "simple" toolchains: pre-compiled binaries pulled to match architecture
 - "traditional" toolchains: compiler, tools, environment: for crossbuild

"""

load("@rules_synology//toolchains:deps.bzl", _synology_deps = "deps", _toolchains = "TOOLCHAINS")
load("@rules_synology//toolchains/bazelisk:deps.bzl", _bazelisk_deps = "deps")

def _impl(_):
    _synology_deps()
    _bazelisk_deps()

synology_deps = module_extension(
    implementation = _impl,
)

def _tc_impl(_):
    """
    The extension "synology_toolchain" intends to share a generated list of toolchains to which we
    can ultimately refer in a register_toolchains() function.
    """
    return _toolchains

synology_toolchains = module_extension(
    implementation = _tc_impl,
)
