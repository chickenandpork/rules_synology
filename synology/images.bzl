def images(name = "images", src = ":PACKAGE_ICON.PNG"):
    sizes = [16, 24, 32, 48, 64, 72, 90, 120, 256]

    [native.genrule(
        name = "{}_{}".format(name, sz),
        srcs = [src],
        outs = ["PACKAGE_ICON_{}.PNG".format(sz)],
        #cmd = "echo $(location //tools:resize) -src=$< -size={} -dest=$@ XXXXX".format(sz),
        cmd = "$(location @rules_synology//tools:resize) -src=$< -size={} -dest=$@".format(sz),
        tools = ["@rules_synology//tools:resize"],
    ) for sz in sizes]

    native.filegroup(
        name = "{}.group".format(name),
        srcs = [":{}_{}".format(name, sz) for sz in sizes],
    )
