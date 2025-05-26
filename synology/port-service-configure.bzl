# This set of functions allows generation of a file that carries port-config information to a
# conf/resource file.  From what I've seen, public-serving apps don't tend to use more than one or
# two, but that means we're doing an array anyhow, so we could create a very large config if
# necessary.
#
# Some functions may not be available at first release; I'm sorry if that blocks you in the
# short-term.  If you don't have time or feel uncomfortable submitting a PR, please submit a
# sanitized test-case so that a unittest can be built to represent what you need to be unblocked.

# The collation works as a series of configs:
ServiceConfigInfo = provider(
    fields = {
        "key": "service-unique key for the section of the service configuration .ini file",
        "title": """Title of the service or service component being configured; this is shown as the field "Protocol" on the firewall config UI, selection of built-in service.""",
        "desc": """Description of the service or service-specific component; this is shown as the field "Applications" on the firewall config UI, selection of built-in service.""",
        "port_forward": "(Optional, but you want to set) set to activate port-forwarding from the external interfaces to the service.",
        "src_ports": """(Optional) if your service protocol has specific source ports (ie the client/requestor of your service connects FROM a specific port) you can configure that here.  This is less common, used in DNS, SUNRPC portmapper, DHCP, CORBA nameservice, etc.  "1:1024/tcp" can be used, for example, to configure that sources should use the port range typically reserved for non-guest root users on a server.  See DSM_Developer_Guide_7_enu.pdf, section "Port" in Workers, which was p 128 when I checked.""",
        "dst_ports": """This configures where the port on the Synology will listen to forward traffic to your service.  For example, a webserver might put "80,443/tcp" here (but more likely configure the revproxy); a web-based admin UI for a container or service would put that service's listening port here.""",
    },
)

def _service_config_impl(ctx):
    return [ServiceConfigInfo(
        key = ctx.attr.name,
        title = ctx.attr.title,
        desc = ctx.attr.description,
        port_forward = "yes" if ctx.attr.port_forward else "no",
        src_ports = ctx.attr.src_ports,
        dst_ports = ctx.attr.dst_ports,
    )]

service_config = rule(
    doc = "A function to define a service configuration (port-forward) for a package installed on Synology",
    implementation = _service_config_impl,
    attrs = {
        "title": attr.string(mandatory = True),
        "description": attr.string(mandatory = True),
        "port_forward": attr.bool(default = True, mandatory = False),
        "src_ports": attr.string(mandatory = False),
        "dst_ports": attr.string(mandatory = True),
    },
)

PortConfigInfo = provider(
    fields = {
        "protocol_file": "The single file representing a ser of one or more Port configs (port-forwards) for mege into a resource file.",
        "struct": "A struct that will be converted to JSON (in writing of the resource file, not here).",
    },
)

def _protocol_file_impl(ctx):
    content = []  # collect generated strings

    if ctx.outputs.out:
        outfile = ctx.outputs.out
        protocol_filename = ctx.outputs.out.short_path
    elif ctx.attr.package_name:
        protocol_filename = "{}.sc".format(ctx.attr.package_name)
        outfile = ctx.actions.declare_file(protocol_filename)
    else:
        fail('Either the "out" parameter or the "package_name" parameter is needed for protocol_file()')

    for block in ctx.attr.service_config:
        b = block[ServiceConfigInfo]
        content.extend([
            "[{}]".format(b.key),
            'title="{}"'.format(b.title),
            'desc="{}"'.format(b.desc),
            'port_forward="{}"'.format(b.port_forward),
            'dst.ports="{}"'.format(b.dst_ports),
        ])
        if b.src_ports:
            content.append('src.ports="{}"'.format(b.src_ports))

        content.append("")  # trailing blank line

    cont = "\n".join(content)
    ctx.actions.write(outfile, cont)

    return [
        DefaultInfo(
            files = depset(direct = [outfile]),
            runfiles = ctx.runfiles(files = [outfile]),
        ),
        PortConfigInfo(
            protocol_file = protocol_filename,
            struct = {"protocol-file": "conf/{}".format(protocol_filename)},
        ),
    ]

protocol_file = rule(
    doc = """The Protocol file is used as a wrapper/collector of service_configs: a building-block to generate the actual file as a buildable object for use in a Port Config resource.  Format is an INI file, as discussed in the DSM_Developer_Guide_7_enu.pdf, section "Port" on p 128 in my copy (search for "Configure Format Template").  Effectively, it builds the file that is pointed-to by a port-config.protocol-file entry in a resource JSON file.""",
    implementation = _protocol_file_impl,
    attrs = {
        "out": attr.output(),
        "package_name": attr.string(mandatory = False),
        "service_config": attr.label_list(mandatory = False, providers = [ServiceConfigInfo]),
    },
)
