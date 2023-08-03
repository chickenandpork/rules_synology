# define an maintainer as a provider so we can re-use them across maintained deliverables as single
# items.  We want simplicity, and type-checking, as opposed to copy-paste of strings that might
# mismatch and have typos.
#
# We keep open the idea of collecting all defined maintainers to a single dataset generating a
# roster on build

Maintainer = provider(
    fields = [
        "name",
        "url",
    ],
)

def _maintainer_impl(ctx):
    return [Maintainer(name = ctx.attr.maintainer_name, url = ctx.attr.maintainer_url)]

maintainer = rule(
    doc = "A simple wrapper for re-use and typing, this produces a Maintainer that can be used as an attribute to targets they maintain.",
    implementation = _maintainer_impl,
    attrs = {
        "maintainer_name": attr.string(mandatory = True),
        "maintainer_url": attr.string(),
    },
)
