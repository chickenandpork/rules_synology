# This set of functions allows population of a /usr/local/ linker, which is configured from a
# struct inside the resource file:
#
# # resource file
# {
#   ...
#   "usr-local-linker": {
#      "bin" ["<relpath>", ...],
#      "lib" ["<relpath>", ...],
#      "etc" ["<relpath>", ...]
#   }
#   ...
# }
#
# These functions simply convert the stringlists to a UsrLocalLinker provider which can be
# assembled into a resource file.  All values should be relative to the "target" directory into
# which the payload is unpacked: /var/packages/<pkgname>/target/

doc = """## Configure a /usr/local Linker

The /usr/local linker is a [Worker](glossary.md#worker) that softlinks payload binaries, libraries,
and config files to bin, lib, and etc subdirectories in /usr/local on package start and removes on
package stop.  If the link or file pre-exists, /usr/local worker will unlink() those files,
effectively overwriting.  Any failure to pre-delete or create a link results in the process
failing, triggering any rollback.

### Example
This will cause a softlink to be created in `/usr/local/bin` that points to
`/var/packages/<package>/target/bin/netfilter-mods`:
```
load("@rules_synology//:defs.bzl", "usr_local_linker")

usr_local_linker(
    name = "softlinks",
    bin = ["netfilter-mods"],
)

```

There is currently no method of linking to a target with a different name: the underlying config
that Synology doesn't offer that capability.


References:

* [Synology: /usr/local linker](https://help.synology.com/developer-guide/resource_acquisition/usrlocal_linker.html)
"""

UsrLocalLinker = provider(
    doc = """UsrLocalLinker relates to a /usr/local linker in the packaging subsystem of Synology""",
    fields = {
        "bin": "A list of binary paths to softlink into /usr/local/bin.",
        "etc": "A list of binary paths to softlink into /usr/local/etc.",
        "lib": "A list of binary paths to softlink into /usr/local/lib.",
    },
)

def _usr_local_linker_impl(ctx):
    return [
        DefaultInfo(),  # stub
        UsrLocalLinker(
            bin = ctx.attr.bin,
            etc = ctx.attr.etc,
            lib = ctx.attr.lib,
        ),
    ]

usr_local_linker = rule(
    doc = doc,
    implementation = _usr_local_linker_impl,
    attrs = {
        "bin": attr.string_list(mandatory = False, doc = "binary paths to softlink into /usr/local/bin"),
        "etc": attr.string_list(mandatory = False, doc = "configfile paths to softlink into /usr/local/etc"),
        "lib": attr.string_list(mandatory = False, doc = "library paths to softlink into /usr/local/lib"),
    },
)
