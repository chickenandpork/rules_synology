# This set of functions allows generation of a conf/privilege file.
#
# Some functions may not be available at first release; I'm sorry if that blocks you in the
# short-term.  If you don't have time or feel uncomfortable submitting a PR, please submit a
# sanitized test-case so that a unittest can be built to represent what you need to be unblocked.
#
# See https://help.synology.com/developer-guide/privilege/privilege_config.html

#load("//synology:port-service-configure.bzl", "PortConfigInfo")

def _privilege_config_impl(ctx):
    privilege_list = {
        "defaults": {
            "run-as": "package",  # ( package | root )
        },
    }

    if ctx.attr.run_as_package or ctx.attr.run_as_root:
        priv = []
        for s in ctx.attr.run_as_package:
            priv.append({"run-as": "package", "action": s})
        for s in ctx.attr.run_as_root:
            priv.append({"run-as": "root", "action": s})
        privilege_list.update({"ctrl-script": priv})
    privilege_list.update({
        "groupname": ctx.attr.groupname,
        "username": ctx.attr.username,
    })

    if ctx.outputs.out:
        outfile = ctx.outputs.out
    else:
        outfile = ctx.actions.declare_file("privilege")

    # appending "" element and joining results in a finishing blank line which has no effect on JSON
    # parsers but gives a blank line at end which is easier to `cat` the results when manually
    # checking.  This might be easier as a simple append, but I had some syntax issues, and this
    # worked.
    ctx.actions.write(
        outfile,
        "\n".join([
            json.encode_indent(privilege_list, indent = "  "),
            "",
        ]),
    )

    return [
        DefaultInfo(
            files = depset(direct = [outfile]),
            runfiles = ctx.runfiles(files = [outfile]),
        ),
    ]

privilege_config = rule(
    doc = "A function (currently stubbed) to define a privilege configuration (conf/privilege) configuring packages installed in Synology.",
    implementation = _privilege_config_impl,
    attrs = {
        "out": attr.output(mandatory = False),
        "run_as_package": attr.string_list(doc = "list of apps/services that sound run-as the given username", mandatory = False),
        "run_as_root": attr.string_list(doc = "list of apps/services that sound run-as root", mandatory = False),
        "username": attr.string(doc = "app-specific posix/unix username under which the app/service runs", mandatory = True),
        "groupname": attr.string(default = "rules_synology", doc = "posix/unix groupname in which the app-specific user is added", mandatory = False),
    },
)
