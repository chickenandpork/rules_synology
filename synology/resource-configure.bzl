# This set of functions allows generation of a conf/resource file.
#
# Some functions may not be available at first release; I'm sorry if that blocks you in the
# short-term.  If you don't have time or feel uncomfortable submitting a PR, please submit a
# sanitized test-case so that a unittest can be built to represent what you need to be unblocked.

load("@rules_synology//synology:port-service-configure.bzl", "PortConfigInfo")

def _resource_config_impl(ctx):
    resource_list = {}

    if ctx.outputs.out:
        outfile = ctx.outputs.out
    else:
        outfile = ctx.actions.declare_file("resource")

    for r in ctx.attr.resources:
        if r[PortConfigInfo]:
            resource_list["port-config"] = r[PortConfigInfo].struct

    # appending "" element and joining results in a finishing blank line which has no effect on JSON
    # parsers but gives a blank line at end which is easier to `cat` the results when manually
    # checking.  This might be easier as a simple append, but I had some syntax issues, and this
    # worked.
    ctx.actions.write(
        outfile,
        "\n".join([
            json.encode_indent(resource_list, indent="  "),
            ""
        ])
    )

    return [
        DefaultInfo(
            files = depset(direct = [outfile]),
            runfiles = ctx.runfiles(files = [outfile]),
        )
    ]

resource_config = rule(
    doc = "A function to define a resource configuration (conf/resource) configuring packages installed in Synology.",
    implementation = _resource_config_impl,
    attrs = {
        "resources": attr.label_list(mandatory = True, providers = [PortConfigInfo]),
        "out": attr.output(mandatory=False),
    },
)
