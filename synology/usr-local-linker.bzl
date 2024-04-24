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


UsrLocalLinker = provider(
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
    doc = """The /usr/local linker is a Worker that softlinks payload binaries, libraries, etc config files to /usr/local on package start and removes on package stop.  If the link or file pre-exists, /usr/local worker will unlink() those files.  Any failure to pre-delete or create a link results in the process failing, reiggering any rollback.""",
    implementation = _usr_local_linker_impl,
    attrs = {
        "bin": attr.string_list(mandatory = False),
        "etc": attr.string_list(mandatory = False),
        "lib": attr.string_list(mandatory = False),
    },
)
