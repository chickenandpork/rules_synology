# This set of functions allows generation of a conf/resource file.
#
# Some functions may not be available at first release; I'm sorry if that blocks you in the
# short-term.  If you don't have time or feel uncomfortable submitting a PR, please submit a
# sanitized test-case so that a unittest can be built to represent what you need to be unblocked.

load("//synology:data-share.bzl", "DataShareInfo")
load("//synology:docker-project.bzl", "DockerProject")
load("//synology:port-service-configure.bzl", "MDNSAliasInfo", "PortConfigInfo", "WebConfigInfo")
load("//synology:systemd-user-unit.bzl", "SystemdUserUnit")
load("//synology:usr-local-linker.bzl", "UsrLocalLinker")

def _web_config_type(port):
    if port == 80 or port == 443:
        return "www"
    return "server"

def _web_config_schema(port):
    if port == 443:
        return "https"
    return "http"

def _avahi_service_content(hostname, port):
    service_type = "_https._tcp" if port == 443 else "_http._tcp"
    return "\n".join([
        '<?xml version="1.0" standalone="no"?><!--*-nxml-*-->',
        '<!DOCTYPE service-group SYSTEM "avahi-service.dtd">',
        "",
        "<service-group>",
        '  <name replace-wildcards="yes">{}</name>'.format(hostname),
        "  <service>",
        "    <type>{}</type>".format(service_type),
        '    <host-name>{}</host-name>'.format(hostname),
        "    <port>{}</port>".format(port),
        "  </service>",
        "</service-group>",
        "",
    ])

def _resource_config_impl(ctx):
    resource_list = {}
    outfiles = []

    if ctx.outputs.out:
        outfile = ctx.outputs.out
    else:
        outfile = ctx.actions.declare_file("resource")
    outfiles.append(outfile)

    datashares = []

    for r in ctx.attr.resources:
        found_provider = False
        if DataShareInfo in r and r[DataShareInfo]:
            ds = {"name": r[DataShareInfo].name, "permission": {}}
            if r[DataShareInfo].permission_ro:
                ds["permission"].update({ "ro": r[DataShareInfo].permission_ro })
            if r[DataShareInfo].permission_rw:
                ds["permission"].update({ "rw": r[DataShareInfo].permission_rw })
            if "data-share" not in resource_list:
                resource_list["data-share"] = { "shares": [] }
            resource_list["data-share"]["shares"].append(ds)
            found_provider = True
        if DockerProject in r and r[DockerProject]:
            resource_list["docker-project"] = r[DockerProject].struct
            found_provider = True
        if PortConfigInfo in r and r[PortConfigInfo]:
            resource_list["port-config"] = r[PortConfigInfo].struct
            found_provider = True
        if WebConfigInfo in r and r[WebConfigInfo]:
            if "web-config" not in resource_list:
                resource_list["web-config"] = {"nginx-static-config": {"enable": []}}
            resource_list["web-config"]["nginx-static-config"]["enable"].append({
                "type": _web_config_type(r[WebConfigInfo].web_config_port),
                "ports": [{
                    "port": r[WebConfigInfo].web_config_port,
                    "protocol": "tcp",
                    "schema": _web_config_schema(r[WebConfigInfo].web_config_port),
                }],
                "alias": [r[WebConfigInfo].hostname],
            })
            found_provider = True
        if SystemdUserUnit in r and r[SystemdUserUnit]:
            resource_list["systemd-user-unit"] = r[SystemdUserUnit]
            found_provider = True
        if MDNSAliasInfo in r and r[MDNSAliasInfo] and WebConfigInfo in r and r[WebConfigInfo]:
            alias_file = ctx.actions.declare_file("{}-{}-mdns-alias.service".format(ctx.attr.name, r[MDNSAliasInfo].key))
            ctx.actions.write(
                alias_file,
                _avahi_service_content(r[MDNSAliasInfo].hostname, r[WebConfigInfo].web_config_port),
            )
            outfiles.append(alias_file)
            found_provider = True
        if UsrLocalLinker in r and r[UsrLocalLinker]:
            if "usr-local-linker" not in resource_list:
                resource_list["usr-local-linker"] = r[UsrLocalLinker]
            else:
                resource_list["usr-local-linker"].update({
                    "bin": resource_list["usr-local-linker"]["bin"] + r[UsrLocalLinker].bin,
                    "etc": resource_list["usr-local-linker"]["etc"] + r[UsrLocalLinker].etc,
                    "lib": resource_list["usr-local-linker"]["lib"] + r[UsrLocalLinker].lib,
                })
            found_provider = True
        if not found_provider:
            print(
                "WARNING: no providers generated from docker_project(), port_config(), web_config(), " +
                "mdns_alias(), systemd_user_unit(), nor usr_local_linker() were found.  May be an error in " +
                "resource_config(name = {},...)".format(ctx.attr.name),
            )

    # appending "" element and joining results in a finishing blank line which has no effect on JSON
    # parsers but gives a blank line at end which is easier to `cat` the results when manually
    # checking.  This might be easier as a simple append, but I had some syntax issues, and this
    # worked.
    ctx.actions.write(
        outfile,
        "\n".join([
            json.encode_indent(resource_list, indent = "  "),
            "",
        ]),
    )

    return [
        DefaultInfo(
            files = depset(direct = outfiles),
            runfiles = ctx.runfiles(files = outfiles),
        ),
    ]

resource_config = rule(
    doc = "A function to define a resource configuration (conf/resource) configuring packages installed in Synology.",
    implementation = _resource_config_impl,
    attrs = {
        "resources": attr.label_list(mandatory = True),
        "out": attr.output(mandatory = False),
    },
)
