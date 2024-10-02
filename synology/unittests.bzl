load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template_rule")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

# In order to check that a linked binary is truly cross-compiled to match the chosen platform, we do this in three steps:
# 1. create a template that confirms the result of a "file" command matches some static expression
# 2. create a template expansion that swaps in the static expression by platform
# 3. test that the result of the expanded template on the object file is the intended result

# Wrap the test in a handy function to expand the components as needed: the intend is to ensure
# that the given binary matches the target platform and is indeed cross-compiled
def confirm_binary_matches_platform(binary):
    token = binary.replace(":", "_")
    token = token.replace("/", "_")
    # Create a template: the resulting script fast-fails if the "file" command fails; otherwise, dumps
    # it to a file.  The file is checked for the desired text, failing if not present.
    write_file(
        name = "{}_test_arch_tmpl".format(token),
        out = "{}_test_arch_tmpl.sh".format(token),
        content = [
            """echo "params: $*" >&2 """,
            "",
            "TMP=$(mktemp)",
            """trap "rm -f ${TMP} ${TMP}2" EXIT""",
            "",
            "file $(readlink -f $1) > ${TMP} || exit 2",
            """cat ${TMP}""",
            """exec grep "DETECT_STRING" ${TMP} >/dev/null""",
            "",
        ],
    )

    # Hydrate the template above, substituting the "expected" output if the "file" with a value
    # according to the current platform.  This allows us to still leverage caching by the different
    # platform, and allow the result to be build-avoided properly.
    #
    # to check:   bazel query --output=build //:test_arch
    expand_template_rule(
        name = "{}_test_arch".format(token),
        out = "{}_test_arch.sh".format(token),
        is_executable = True,
        substitutions = select({
            "@rules_synology//arch:armada37xx": {"DETECT_STRING": " ELF 64-bit LSB pie executable, ARM aarch64"},
            "@rules_synology//arch:denverton": {"DETECT_STRING": " ELF 64-bit LSB pie executable, x86-64"},
            "@rules_synology//arch:geminilake": {"DETECT_STRING": " ELF 64-bit LSB pie executable, x86-64"},
            "//conditions:default": {"DETECT_STRING": "no-possible-match"},
        }),
        template = ":{}_test_arch_tmpl".format(token),
    )

    native.sh_test(
        name = "{}_test_file_arch".format(token),
        size = "small",
        srcs = [":{}_test_arch".format(token)],
        args = ["$(location {})".format(binary)],
        data = [binary],
    )
