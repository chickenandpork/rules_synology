# Formats guided by https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//:synology/maintainer.bzl", "Maintainer", _maintainer = "maintainer")
load("//:synology/port-service-configure.bzl", _service_config = "service_config", _protocol_file="protocol_file")
load("//:synology/resource-configure.bzl", _resource_config = "resource_config")

def INFO_file(ctx):
    # Build a manifest per some fairly predictable ordering: key:value pairs, but by wrapping as
    # parameters, we have the option of generating or deriving values.
    #
    # Corresponding to DSM_Developer_Guide_7_enu.pdf p37, these are the necessary fields:
    #
    # package_name: ("package" in Synology): a unique non-namespace package identity.  Also the
    #    name of the link in /var/packages/ that will point to where package files are unpacked.
    # package_version: ("version"): a version string that Synology describes as being any string of
    #    numbers separated by periods, dash, or underscore.  I'd personally prefer to be
    #    <semver>-<buildserial> such as "1.2.3-4416"
    # os_min_ver: Earliest version of DSM that can install the package; ie "DSM 7.1.1-42962".  There
    #    seems to be no handling of the extended hard-to-parse suffixes used by Synology such as
    #    "DSM 7.1.1-42962 Update 6" (we as humans can interpret and make a good assumption,
    #    but machines?  no)
    # description: a short, but multiline if needed, description of the package
    # arch: a string of space-separated multiple values, each of which is one of the CPU
    #    architectures (DSM_Developer_Guide_7_enu.pdf Appendix A).
    #    ie: "x86_64 alpine", defaults to "noarch"
    # maintainer: freeform string representation of the package maintainer
    # rule_name: optional name of the generated rule rather than ${package_name}_INFO
    #
    # I strongly envision most use of this function will be indirectly through other rules that
    # simplify the build of cmake, autotools, go-specific, react front-ends, etc.

    if ctx.outputs.out:
        outfile = ctx.outputs.out
    else:
        outfile = ctx.actions.declare_file("INFO")

    content = [
        'package="{}"'.format(ctx.attr.package_name),
        'version="{}"'.format(ctx.attr.package_version),
        'os_min_ver="{}"'.format(ctx.attr.os_min_ver),
        'description="{}"'.format(ctx.attr.description),
        'maintainer="{}"'.format(ctx.attr.maintainer[Maintainer].name),
        'arch="{}"'.format(" ".join(ctx.attr.arch_strings)),
    ]

    # optional bits
    if ctx.attr.maintainer[Maintainer].url:
        content.append('maintainer_url="{}"'.format(ctx.attr.maintainer[Maintainer].url))

    content.append("")  # ensure the file ends with a Newline by appending a zero-len line

    ctx.actions.write(outfile, "\n".join(content), is_executable = False)

    return [DefaultInfo(files = depset([outfile]))]

info_file = rule(
    doc = "Create an INFO file: the intent is to simplify and provide a single choke-point for sanity-checking and instantiating defaults that may accelerate a new project creation",
    implementation = INFO_file,  # TODO: rename
    attrs = {
        "package_name": attr.string(doc = "Name of the package, unique within Synology SPKs, hopefully resembles external package name", mandatory = True),
        "package_version": attr.string(doc = "Version of the package; although I recommend semver-ish X.Y.Z-BUILDNUM, Synology describes as being any string of numbers separated by periods, dash, or underscore", mandatory = True),
        "os_min_ver": attr.string(doc = """Earliest version of DSM that can install the package; ie "DSM 7.1.1-42962".  There seems to be no handling of the extended hard-to-parse suffixes used by Synology such as "DSM 7.1.1-42962 Update 6".""", mandatory = True),
        "description": attr.string(doc = "Brief description of the package: copy-paste from the upstream if permissible.  Although this can be a looooong single-line string, it does display on the UIs to install a package, so brevity is still encouraged.", mandatory = True),
        "maintainer": attr.label(doc = "Maintainer of the build logic for the component (primary if multiple, a person)", providers = [Maintainer], mandatory = True),
        "arch_strings": attr.string_list(doc = """array of architectures (current strings): [ "alpine", ...] (default: ["noarch"]).""", default = ["noarch"], mandatory = False),
        "out": attr.output(doc = "Name of the Info file, if INFO is not preferred.", mandatory = False),
    },
)

def images(name = "images", src = ":PACKAGE_ICON.PNG"):
    sizes = [16, 24, 32, 48, 64, 72, 90, 120, 256]

    [native.genrule(
        name = "{}_{}".format(name, sz),
        srcs = [src],
        outs = ["PACKAGE_ICON_{}.PNG".format(sz)],
        #cmd = "echo $(location //tools:resize) -src=$< -size={} -dest=$@ XXXXX".format(sz),
        cmd = "$(location //tools:resize) -src=$< -size={} -dest=$@".format(sz),
        tools = ["//tools:resize"],
    ) for sz in sizes]

    native.filegroup(
        name = "{}.group".format(name),
        srcs = [":{}_{}".format(name, sz) for sz in sizes],
    )

# pass-thru

maintainer = _maintainer
protocol_file = _protocol_file
resource_config = _resource_config
service_config = _service_config
