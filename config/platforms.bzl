PLATFORMS = {
    "ds1819+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "denverton",
        "version": "7.1.1",  # trimmed to "7.1" below: ...format(".".join(v["version"].split(".")[:2])),
    },
    "ds224+": {
        "cpu": "x86_64",
        "os": "linux",
        "synoarch": "geminilake",
        "version": "7.1.1",
    },
}


MINOR_VERSIONS_WITH_DUPES = [ ".".join(p["version"].split(".")[:2]) for k,p in PLATFORMS.items() ]
PATCH_VERSIONS_WITH_DUPES = [ p["version"] for k,p in PLATFORMS.items() ]

# this doesn't work: VERSIONS = list(set(VERSIONS_WITH_DUPES))
# dedupe using conditional list addition
MINOR_VERSIONS = []
[ MINOR_VERSIONS.append(x) for x in MINOR_VERSIONS_WITH_DUPES if x not in MINOR_VERSIONS]
PATCH_VERSIONS = []
[ PATCH_VERSIONS.append(x) for x in PATCH_VERSIONS_WITH_DUPES if x not in PATCH_VERSIONS]


