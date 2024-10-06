_PLATFORMS = {
    # x24
    "ds124": {
        "synoarch": "rtd1619b",
        "version": "7.1",
    },
    "ds224+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",  # trimmed to "7.1" below: ...format(".".join(v["version"].split(".")[:2])),
    },

    # x23
    "rs2423rp+": {
        "package_arch": "v1000",
        "version": "7.1",
    },
    "rs2423+": {
        "package_arch": "v1000",
        "version": "7.1",
    },
    "ds1823xs+": {
        "package_arch": "v1000",
        "version": "7.1",
    },
    "ds923+": {
        "package_arch": "r1000",
        "version": "7.1",
    },
    "ds723+": {
        "package_arch": "r1000",
        "version": "7.1",
    },
    "ds423": {
        "package_arch": "rtd1619b",
        "version": "7.1",
    },
    "ds423+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    "ds223": {
        "package_arch": "rtd1619b",
        "version": "7.1",
    },
    "ds223j": {
        # TODO: dupe?
        "package_arch": "rtd1619b",
        "version": "7.1",
    },

    # x22
    "dva1622": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    # x20
    "ds120j": {
        "cpu": "aarch64",
        "os": "linux",
        "synoarch": "armada37xx",
        "version": "7.1.1",
    },
    "ds220+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    "ds420+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    "ds720+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    "ds920+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    "ds1520+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
    # x19
    "ds119j": {
        "cpu": "aarch64",  # or are we "arm64" this week?
        "os": "linux",
        "synoarch": "armada37xx",
        "version": "7.1.1",  # trimmed to "7.1" below: ...format(".".join(v["version"].split(".")[:2])),
    },
    "ds1819+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "denverton",
        "version": "7.1.1",
    },
}

PLATFORMS = {k: v for k, v in _PLATFORMS.items() if "cpu" in v and "os" in v and "synoarch" in v}

MINOR_VERSIONS_WITH_DUPES = [".".join(p["version"].split(".")[:2]) for k, p in PLATFORMS.items()]
PATCH_VERSIONS_WITH_DUPES = [p["version"] for k, p in PLATFORMS.items()]

# this doesn't work: VERSIONS = list(set(VERSIONS_WITH_DUPES))
# dedupe using conditional list addition
MINOR_VERSIONS = []
[MINOR_VERSIONS.append(x) for x in MINOR_VERSIONS_WITH_DUPES if x not in MINOR_VERSIONS]
PATCH_VERSIONS = []
[PATCH_VERSIONS.append(x) for x in PATCH_VERSIONS_WITH_DUPES if x not in PATCH_VERSIONS]
