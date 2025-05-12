def _image_impl(ctx):  # SINGLE image
    target_name = ctx.attr.image or "PACKAGE_ICON.PNG"
    target = ctx.actions.declare_file(target_name)
    ctx.actions.run(
        outputs = [target],
        inputs = [ctx.file.src],
        arguments = [
            "-src={}".format(ctx.file.src.path),
            "-size={}".format(ctx.attr.size),
            "-dest={}".format(target.path),
            "-verbose" if ctx.attr.verbose else "",
        ],
        executable = ctx.executable._resize,
        mnemonic = "Resizing",
    )

    return [DefaultInfo(
        files=depset([target]),
        runfiles= ctx.attr._resize[DefaultInfo].default_runfiles,
    )]


image = rule(
    doc = """Create a single resized image from the src image.""",
    implementation = _image_impl,
    attrs = {
        "size": attr.int(mandatory = False, default = 256, doc = "size (length of square bounding box) to convert src to."),
        "src": attr.label(allow_single_file = True,mandatory = True, doc = "Initial source image to convert to desired size."),
        "image": attr.string(doc = "name of target image file.  The name should end with a suffix that determines the resulting format: .png, .jpg, .PNG, etc.", mandatory=False),
        "_resize": attr.label(
            default=Label("//tools:resize"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "verbose": attr.bool(default=False, doc = "Verbosity can enable some debug messages from //tools:resize that can help resolve errors."),
    }
)

def _images_impl(ctx):
    out_collector = []
    images_template = ctx.attr.images_template or "PACKAGE_ICON_{}.PNG"
    for sz in ctx.attr.sizes:
        target_name = images_template.format(sz)
        target = ctx.actions.declare_file(target_name)
        ctx.actions.run(
            outputs = [target],
            inputs = [ctx.file.src],
            arguments = [
                "-src={}".format(ctx.file.src.path),
                "-size={}".format(sz),
                "-dest={}".format(target.path),
                "-verbose" if ctx.attr.verbose else "",
            ],
            executable = ctx.executable._resize,
            mnemonic = "Resizing",
        )
        out_collector.append(target)

    return [DefaultInfo(
        files=depset(out_collector),
        #runfiles= ctx.executable._resize[DefaultInfo].default_runfiles,
        runfiles= ctx.attr._resize[DefaultInfo].default_runfiles,
    )]


images = rule(
    doc = """Create a filegroup of resized images: 16x16, 24x24, etc""",
    implementation = _images_impl,
    attrs = {
        "sizes": attr.int_list(mandatory = False, default = [ 16, 24, 32, 48, 64, 72, 90, 120, 256 ], doc = "sizes to convert: use a list of ints, each of which is a desired size of a square bounding box."),
        "src": attr.label(allow_single_file = True,mandatory = True, doc = "Initial source image to convert to various sizes."),
        "images_template": attr.string(doc = "template for output files: use a string with a single {} that will be replaced with the size.  The template should end with a suffix that determines the resulting format: .png, .jpg, .PNG, etc.  Note that Synology SPK packaging requires files of the form PACKAGE_ICON_<size>.PNG so changing this should entail converting the result back however desired for the payload of the SPK.", mandatory=False),
        "_resize": attr.label(
            default=Label("//tools:resize"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "verbose": attr.bool(default=False, doc = "Verbosity can enable some debug messages from //tools:resize that can help resolve errors."),
    }
)
