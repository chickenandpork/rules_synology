# Formats guided by https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

load("//synology:maintainer.bzl", "Maintainer")

doc = """## Create an INFO file

The INFO file is the simple metadata k/v dict of the SPK: a number of `key=value` pairs that define
attributes of the package.

This file is needed to inform the Synology NAS of the name and unique ID of the package, quote
maintainers and distributors, and indicate architecture and OS constraints to install.  I
personally expect that the simple format of this file allows the UI to show install dialogs with
minimal complexity.

Likely the reader will notice that the `maintainer()` block collects more information than it needs
to for the `INFO` file: the additional URL is optional, but can help track down a maintainer if a
user or collaborator needs to find them.  This is not necessarily intended to be the upstream
URL(s) of a project (ie github pages, docker URLs,etc) but is intended to be a valid URL that can
help precisely identify where the preferred path to find that maintainer.

This implementation mimics the defaults from Synology's documentation so that the bare minimum
attributes can be provided to unblock immediate progress.

### Examples

(`BUILD` file)
```
load("@rules_synology//:defs.bzl", "info_file", "maintainer")

maintainer(
    name = "chickenandpork",
    maintainer_name = "Allan Clark",
    maintainer_url = "http://linkedin.com/in/goldfish",
    visibility = ["//visibility:public"],
)

info_file(
    name = "floppydog_info",
    package_name = "FloppyDog",
    description = "Provides the FloppyDog set of CLI tools for Great Justice",
    maintainer = ":chickenandpork",
    os_min_ver = "7.0-1",  # correct-format=[^\\d+(\\.\\d+){1,2}(-\\d+){1,2}$]
    package_version = "1.0.0-1",
)
```

The `INFO` file generated by this looks similar to:
```
package="FloppyDog"
version="1.0.0-1"
os_min_ver="7.0-1"
description="Provides the FloppyDog set of CLI tools for Great Justice"
maintainer="Allan Clark"
arch="noarch"
ctl_stop="yes"
startable="yes"
thirdparty="yes"
```

`info_file()` uses [maintainer()](docs.md#maintainer) to carry information about the package's
maintainer: referring to a maintainer by target ID allows greatest re-use of a DRY data element,
and should allow the author to associate a maintainer globally maintained in a dependency resource:

(`MODULE.bazel`)
```
bazel_dep(name = "firehydrant_stuff", version = "1.2.3")
```
(`BUILD.bazel`)
```
info_file(
    name = "firehydrant_info",
    package_name = "FireHydrant",
    description = "A great Incident-Management resource made by SREs for SREs",
    maintainer = "@firehydrant_stuff//maint:robertross",
    os_min_ver = "7.0-1",  # correct-format=[^\\d+(\\.\\d+){1,2}(-\\d+){1,2}$]
    package_version = "1.0.0-1",
)
```

Ref:
* [Synology: INFO](https://help.synology.com/developer-guide/synology_package/INFO.html)
"""

def valid_version(version):
    """Pre-check that the given version is valid for Synology

    Despite how standards are better if we all adhere to them -- pick one, don't make a new one --
    I'm not checking due to any bias about formats: *SYNOLOGY* accepts only a specific format here.

    synopkg will report an error if the version in an INFO file does not match the correct
    format=[^\\d+(\\.\\d+){0,5}(-\\d+)?$] -- problem is, Bazel not supporting regex, the steps to check
    this are more complex:

    1. split across the "-": confirm either 1 or two results; fail otherwise
    2. confirm that the second item of the "-" split is all numbers; fail otherwise
    3. split the first  item of the "-" split by decimal
    4. confirm that the decimal-split has 6 or fewer items; fail otherwise
    5. confirmthat each of the results of the decimal-split are all just numbers
    """

    dash = version.split("-")

    if len(dash) < 1 or len(dash) > 2:
        print("format of version {} should match {}, one or two parts separated by hyphens, you have {} blocks".format(version, "[^\\d+(\\.\\d+){0,5}(-\\d+)?$]", len(dash)))
        return False
    if len(dash) == 2 and not dash[1].isdigit():
        print("format of version {} should match {}, and {} should be numbers".format(version, "[^\\d+(\\.\\d+){0,5}(-\\d+)?$]", dash[1]))
        return False

    dots = dash[0].split(".", 7)
    if len(dots) < 1 or len(dots) > 5:
        print("format of version {} should match {}, 1-6 [0-9]+ between dots.  you have {} sets of numbers".format(version, "[^\\d+(\\.\\d+){0,5}(-\\d+)?$]", len(dots)))
        return False

    for d in dots:
        if not d.isdigit():
            print("format of version {} should match {} (ie numbers sep by dots), your maj/min/patch block is non-digit {}".format(version, "[^\\d+(\\.\\d+){0,5}(-\\d+)?$]", d))
            return False

    return True

InfoFile = provider(fields = {
    "package": "A unique name for the package: no namespacing,might clash with other definitions",
    "version": "Package Version: a dotted-integer version with an optional hyphenated suffice number: 4.2.4-2668",
    "os_min_ver": "Minimum DSM version that can install this package: a string without clear constraints: 'DSM 7.1.1-42962'",
    "description": "A brief description of the Package: it may be multiline, but should be brief and concise",
    "maintainer": "The name of the maintainer: we draw this from a Maintainer provider from the 'maintainer()' target",
    "maintainer_url": "The email address of the maintainer: we draw this from a Maintainer provider from the 'maintainer()' target",
    "arch": "Spec-separated text indicating comaptible architectures for this SPK: 'noarch x86_64'",
    "ctl_stop": "Boolean: is there a start-stop-status script to allow the SPK to start or stop? (writes both startable and ctl_stop)",
    "thirdparty": "Boolean: is this SPK built outside of Synology corporation? (typically yes)",
})

def info_file_impl(ctx):
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
    #    ie: "x86_64 alpine".  Defaults to "noarch"
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
        'ctl_stop="{}"'.format("yes" if ctx.attr.ctl_stop else "no"),
        'startable="{}"'.format("yes" if ctx.attr.ctl_stop else "no"),  # see also ctl_stop
        'thirdparty="yes"',
    ]

    # optional bits
    if ctx.attr.maintainer[Maintainer].url:
        content.append('maintainer_url="{}"'.format(ctx.attr.maintainer[Maintainer].url))

    content.append("")  # ensure the file ends with a Newline by appending a zero-len line

    ctx.actions.write(outfile, "\n".join(content), is_executable = False)

    return [
        DefaultInfo(files = depset([outfile])),
        InfoFile(
            package = ctx.attr.package_name,
            version = ctx.attr.package_version,
            os_min_ver = ctx.attr.os_min_ver,
            description = ctx.attr.description,
            maintainer = ctx.attr.maintainer[Maintainer].name,
            maintainer_url = ctx.attr.maintainer[Maintainer].url,
            arch = " ".join(ctx.attr.arch_strings),
            ctl_stop = "yes" if ctx.attr.ctl_stop else "no",
            thirdparty = "yes",
        ),
    ]

info_file = rule(
    doc = doc,
    implementation = info_file_impl,
    attrs = {
        "package_name": attr.string(
            doc = "Name of the package, unique within Synology SPKs, hopefully resembles external package name",
            mandatory = True,
        ),
        "package_version": attr.string(
            doc = "Version of the package; although I recommend semver-ish X.Y.Z-BUILDNUM, Synology describes as being any string of numbers separated by periods, dash, or underscore",
            mandatory = True,
        ),
        "os_min_ver": attr.string(
            doc = """Earliest version of DSM that can install the package; ie "DSM 7.1.1-42962".  There seems to be no handling of the extended hard-to-parse suffixes used by Synology such as "DSM 7.1.1-42962 Update 6".""",
            mandatory = True,
        ),
        "description": attr.string(
            doc = "Brief description of the package: copy-paste from the upstream if permissible.  Although this is permitted be a looooong single-line string, it does display on the UIs to install a package, so brevity is still encouraged.",
            mandatory = True,
        ),
        "maintainer": attr.label(
            doc = "Maintainer of the build logic for the component (primary if multiple, a person)",
            providers = [Maintainer],
            mandatory = True,
        ),
        "arch_strings": attr.string_list(
            doc = """array of architectures (strings): [ "alpine", ...] (default: ["noarch"]).""",
            default = ["noarch"],
            mandatory = False,
        ),
        "out": attr.output(
            doc = "Name of the Info file, if INFO is not preferred (changing this is not recommended).",
            mandatory = False,
        ),
        "ctl_stop": attr.bool(
            default = True,
            doc = "Indicates (boolean) whether there is a start-stop-script and the SPK can be started or stopped (previously: startable).",
            mandatory = False,
        ),
    },
)
