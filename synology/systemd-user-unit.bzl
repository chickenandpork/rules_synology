# This set of functions allows registration of a systemd unit config (USER, not System, yet).
#
# With this code, a file at conf/systemd/pkguser-<name> is registered for copy to
# home/.config/systemd/user/ during postinst, and removed in postuninst stages.  Per the document
# at ref (using 7.2.2 version for this initial work), the package should then use
# `synosystemctl start` and `synosystemctl stop` to control the service inside scripts (which should
# include the SSS script).
#
# The config this creates is a trivial block in the resource file, triggering Synology install
# routines to look in a conventional/assumed location:
#
# inside the resource file:
#
# # resource file
# {
#   ...
#   "systemd-user-unit": {}
#   ...
# }
#
# Documentation doesn't indicate how the assumed file is named, but it seems to be a single file at
# conf/systemd/pkguser-<name>.  It *seems* that the install prociess at postinst stage will copy
# one (or more?) units to this home/.config/systemd/user/ path.  Likely if multiple units exist,
# they will be copied to that path, avoiding name-clash within the package by requiring uniqueness
# in the wrapping tar archive, and avoiding name-clash on the running Synology by using the
# username as a namespace.
#
# The resulting file is a standard system unit config from what I can see; this portion of the unit
# simply logs that the installer needs to do the copy/removal at the proper stages.  The installer
# doesn't run the start/stop automatically, it seems running those in a SSS file is conventional
# means of activating.

doc = """## Configure a /usr/local Linker

The Systemd User Unit is a [Worker](glossary.md#worker) that triggers the install process to make
available the systemd unit(s) in `conf/systemd/pkguser-<name>` into `home/.config/systemd/user/`
during postinst, removing during postuninst.  The package should then use `synosystemctl start` and
`synosystemctl stop` to control the service inside scripts (which should include the SSS script).

### Example
This will cause a system user unit module to be copied from `conf/systemd/pkguser-awesomesauce` to
`home/.config/systemd/user/` so that the postinst step can trigger `synosystemctl start` in an SSS
script run during `postinst` stage (including the enclosing wrappers for clarity):

```
load("@//:defs.bzl", "resource_config", "systemd_user_unit")

systemd_user_unit(
    name = "systemd-awesome",
)
...
resource_config(
    name = "rez",
    resources = [ ... ":systemd-awesome" ],
)

pkg_files(
    name = "conf",
    srcs = [ ...  ":rez" ],
    prefix = "conf",
)

pkg_tar(
    name = "awesomesauce",
    srcs = [ ...  ":conf" ],
    ],
    extension = "tar",
    package_file_name = "awesomesauce.spk",
)

```

References:

* [Synology: Systemd User Unit](https://help.synology.com/developer-guide/resource_acquisition/systemd_user_unit.html)
"""

SystemdUserUnit = provider(
    doc = """SystemdUserUnit triggers opinionated packaging and behavior uing uinstall for systemd user units.""",
    fields = {
        #"unit": "Future intentions to carry the names of user-unit files, generate a pkg_files or pkg_tar of the unit file remapped to proper path",
    },  # type detection only
)

def _systemd_user_unit_impl(ctx):
    return [
        DefaultInfo(),  # stub
        SystemdUserUnit(),  # provider signature used only
    ]

systemd_user_unit = rule(
    doc = doc,
    implementation = _systemd_user_unit_impl,
    attrs = { },
)
