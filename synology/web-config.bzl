"""A host-based DSM nginx proxy and matching Avahi service description.

Package the nginx output at relpath and the avahi output with an unprivileged
Avahi publisher. An XML host-name is an SRV target; it does not publish a DNS
address or CNAME by itself.
"""

WebProxyInfo = provider(fields = {"config": "DSM web-config enable entry"})

def _web_config_impl(ctx):
    hostname = ctx.attr.hostname
    if not hostname.endswith(".local"):
        fail("hostname must end in .local")
    for label in hostname.split("."):
        if not label or len(label) > 63 or label.startswith("-") or label.endswith("-"):
            fail("invalid hostname label")
        for char in label.elems():
            if char not in "abcdefghijklmnopqrstuvwxyz0123456789-":
                fail("hostname must be a lowercase DNS name")
    if ctx.attr.port != 80:
        fail("this HTTP proxy currently requires port 80")
    if ctx.attr.backend_port < 1 or ctx.attr.backend_port > 65535:
        fail("backend_port must be in 1..65535")
    if ctx.attr.relpath.startswith("/") or ".." in ctx.attr.relpath.split("/"):
        fail("relpath must stay inside the package payload")

    nginx = ctx.actions.declare_file(ctx.label.name + ".conf")
    avahi = ctx.actions.declare_file(ctx.label.name + ".service")
    ctx.actions.write(nginx, "\n".join([
        "server {",
        "    listen 80;",
        "    listen [::]:80;",
        "    server_name " + hostname + ";",
        "",
        "    location / {",
        "        proxy_pass http://127.0.0.1:" + str(ctx.attr.backend_port) + ";",
        "        proxy_http_version 1.1;",
        "        proxy_set_header Host $http_host;",
        "        proxy_set_header X-Real-IP $remote_addr;",
        "        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;",
        "        proxy_set_header X-Forwarded-Proto $scheme;",
        "        proxy_set_header Upgrade $http_upgrade;",
        '        proxy_set_header Connection "upgrade";',
        "        proxy_read_timeout 3600s;",
        "    }",
        "}",
        "",
    ]))
    ctx.actions.write(avahi, "\n".join([
        '<?xml version="1.0" standalone="no"?>',
        '<!DOCTYPE service-group SYSTEM "avahi-service.dtd">',
        "<service-group>",
        "  <name>" + hostname + "</name>",
        "  <service>",
        "    <type>_http._tcp</type>",
        "    <host-name>" + hostname + "</host-name>",
        "    <port>80</port>",
        "    <txt-record>path=/</txt-record>",
        "  </service>",
        "</service-group>",
        "",
    ]))
    return [
        DefaultInfo(files = depset([nginx, avahi])),
        OutputGroupInfo(nginx = depset([nginx]), avahi = depset([avahi])),
        WebProxyInfo(config = {
            "type": "server",
            "relpath": ctx.attr.relpath,
            "alias": [hostname],
        }),
    ]

web_config = rule(
    doc = "Generates a DSM nginx HTTP proxy configuration and an Avahi service description, exposed through the nginx and avahi output groups. Pass this target to resource_config and package the nginx file at relpath. Publish the Avahi file separately; its host-name is an SRV target and does not create an address record or CNAME.",
    implementation = _web_config_impl,
    attrs = {
        "hostname": attr.string(
            mandatory = True,
            doc = "Lowercase DNS hostname ending in .local, used as the nginx server name, web-config alias, and Avahi SRV target. Labels must contain 1 to 63 lowercase letters, digits, or hyphens and cannot start or end with a hyphen.",
        ),
        "port": attr.int(
            default = 80,
            doc = "Public HTTP port for the nginx listener and Avahi advertisement. Currently only port 80 is supported.",
        ),
        "backend_port": attr.int(
            mandatory = True,
            doc = "HTTP backend port on 127.0.0.1 to which nginx proxies requests. Must be in the range 1 to 65535.",
        ),
        "relpath": attr.string(
            mandatory = True,
            doc = "Path relative to the package payload where the generated nginx configuration will be installed. Recorded in the web-config resource entry; must not start with / or contain a .. path component.",
        ),
    },
)
