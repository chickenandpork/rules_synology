# Formats guided by https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

load("@bazel_skylib//rules:write_file.bzl", "write_file")

def INFO_file(
        package_name,
        package_version,
        os_min_ver,
        description,
        maintainer,
        arch = ["noarch"],
        rule_name = None,
        info_filename = None):
    # Build a manifest per some fairly predictable ordering: key:value pairs, but by wrapping as
    # parameters, we have the option of generating or deriving values.
    #
    # Corresponding to DSM_Developer_Guide_7_enu.pdf p37, these are the necessary fields:
    #
    # package_name: ("package" in Synology): a unique non-namespace package identity.  Also the
    #    name of the link in /var/packages/ that will point to where package files are unpacked.
    # package_version: ("version"): a version string that Synology describes as being any string of
    #    numbers separated by periods, dash, or underscore.  I'd personally prefer to be
    #    <semver>-<buildserial> such as "1.2.3-4416"
    # os_min_ver: Earliest version of DSM that can install the package; ie "DSM 7.1.1-42962".  There
    #    seems to be no handling of the extended hard-to-parse suffixes used by Synology such as
    #    "DSM 7.1.1-42962 Update 6" (we as humans can interpret and make a good assumption,
    #    but machines?  no)
    # description: a short, but multiline if needed, description of the package
    # arch: a string of space-separated multiple values, each of which is one of the CPU
    #    architectures (DSM_Developer_Guide_7_enu.pdf Appendix A).
    #    ie: "x86_64 alpine", defaults to "noarch"
    # maintainer: freeform string representation of the package maintainer
    # rule_name: optional name of the generated rule rather than ${package_name}_INFO

    content = [
        'package="{}"'.format(package_name),
        'version="{}"'.format(package_version),
        'os_min_ver="{}"'.format(os_min_ver),
        'description="{}"'.format(description),
        'maintainer="{}"'.format(maintainer),
        'arch="{}"'.format(" ".join(arch)),
    ]

    # future optional bits
    #if os_min_ver:
    #    content.append('os_min_ver="{}"'.format(os_min_ver))

    content.append("")  # ensure the file ends with a Newline by appending a zero-len line

    write_file(rule_name or "{}_INFO".format(package_name), info_filename or "INFO", content)
