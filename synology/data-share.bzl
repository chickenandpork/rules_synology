doc = """## Configure a shared resource (folder/export)

The Data Share is a [Worker](glossary.md#worker) that configures a shared storage on installation
of the SPK, assigning the given readonly/readwrite permissions.  Generally, for a package
`bobknight` defining a share `bobstuff`, the path `/var/packages/bobknight/shares/bobstuff/` will
point to that storage space which is also available in the "File Station" app, and may be visible
in a `showmounts -e` if exported via NFS as well.

The created share `/var/packages/bobknight/shares/bobstuff/` is actuallt a softlink to a share such
as `/volume1/bobstuff` which will be owned by root, but has posix permissions of 1777 so that any
may write to it.  It seems that content may be stored there during the install process and will be
owned by the user and group of the installed package defining the share.

### Example
This will cause a share to be created as "bobstuff" -- visible as such in File Station and the
"Shared Folder" menu in Control Panel -- with a path of `/var/packages/bobknight/shares/bobstuff`
as a softlink pointing to `/volumeX/bobstuff`:

```
load("@rules_pkg//pkg:mappings.bzl", "pkg_files")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("@rules_synology//:defs.bzl", "data_share", "resource_config", "systemd_user_unit")


data_share(
  name = "datashare",
  sharename = "bobstuff",
  permissions = {
    "bobknight": "rw",
    # "otheruser": "ro",
  },
)

resource_config(
    name = "rez",
    resources = [ ... ":datashare" ],
)

pkg_files(
    name = "conf",
    srcs = [ ...  ":rez" ],
    prefix = "conf",
)

pkg_tar(
    name = "spk",
    srcs = [ ...  ":conf" ],
    ],
    extension = "tar",
    package_file_name = "theapplication.spk",
)

```

References:

* [Synology: Systemd User Unit](https://help.synology.com/developer-guide/resource_acquisition/data_share.html)
"""



DataShareInfo = provider(
    fields = {
        "name": "name of the share",
        "permission_ro": "list of usernames with readonly priv to the share",
        "permission_rw": "list of usernames with read/write priv to the share",
    },
)

def _data_share_impl(ctx):
    return [DataShareInfo(
        name = ctx.attr.sharename or ctx.attr.name,
        permission_ro = [user for user, access in ctx.attr.permissions.items() if access == "ro"],
        permission_rw = [user for user, access in ctx.attr.permissions.items() if access == "rw"],
    )]

data_share = rule(
    doc = "A function to define a data-share config that will be copied to the resource of the SPK.",
    implementation = _data_share_impl,
    attrs = {
        "sharename": attr.string(doc = "Name of the share; if not given, the rule name will be used.", mandatory = False),
        "permissions": attr.string_dict(doc = "Permissions on the share. as a dict: {user}:{ro|rw}, {user}:{ro|rw}", mandatory = False),
    },
)
