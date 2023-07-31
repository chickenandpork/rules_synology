# Written this way so that the most recent release used is at the top, but allows for a history to
# be retained, parsed, etc in case reverting to a previous release is necessary
NAME_SHA_BY_VERSION = {
    # yup, a multi-arch at https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-darwin.
    # I started by using this for testing, so it's no big deal to leave this in here now as a pair
    # of binaries to lipo together.
    "1.11.0": {
        "bazelisk-darwin-amd64": {
            "sha256": "c725fd574ea723ab25187d63ca31a5c9176d40433af92cd2449d718ee97e76a2",
            "url": "https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-darwin-amd64",
        },
        "bazelisk-darwin-arm64": {
            "sha256": "1e18c98312d1a03525f704214304be2445478392c8687888d5d37e6a680f31e6",
            "url": "https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-darwin-arm64",
        },
    },
}

def preferred_release():
    """
    Returns a dict similar to:

    { bazelisk-darwin-amd64": { "url": "...", "sha256": "..." },
      bazelisk-darwin-arm64": { "url": "...", "sha256": "..." },
    }
    """

    # first set revision set listed - I could use NAME_SHA_BY_VERSION["1.11.0"] as well
    return NAME_SHA_BY_VERSION[NAME_SHA_BY_VERSION.keys()[0]]

def preferred_release_version():
    return NAME_SHA_BY_VERSION.keys()[0]

def binaries():
    """
    Convenience array/list to allow changes to the list of releases to be fairly DRY and self-contained.
    Returns a list/array to simply send to a lipo() call similar to

    [ "@bazelisk_darwin_amd64//file", "@bazelisk_darwin_arm64//file" ]
    """

    return ["@{}//file".format(a.replace("-", "_")) for a in preferred_release()]
