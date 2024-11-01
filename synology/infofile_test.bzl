load("@bazel_skylib//lib:unittest.bzl", "asserts", "analysistest")
load("//synology:info-file.bzl", "info_file", "InfoFile")

# ==== Check the InfoFile provider contents ====

def _info_file_version_test_impl(ctx):
    env = analysistest.begin(ctx)
    target_under_test = analysistest.target_under_test(env)

    # Check a few versions for validity
    asserts.equals(env, "some value", target_under_test[InfoFile].val)

    # Done: remember to return end()
    return analysistest.end(env)

# This global variable acts as a handle for the unittest.  It needs to be a global since macros get
# evaluated at loading time but the rule gets evaluated later, at analysis time. Since this is a
# test rule, its name must end with "_test".
info_file_contents_test = analysistest.make(_info_file_version_test_impl)

# Macro to setup the test.
def _test_info_file_contents():
    # Rule under test: tagged 'manual' to avoid building on ':all', but remain available as a
    # dependency of the test

    info_file(name = "info_file_contents_subject", tags = ["manual"])

    # Testing rule.
    info_file_contents_test(name = "info_file_contents_test", target_under_test = ":info_file_contents_subject")


def syno_test_suite(name):
    # call all tests which depend on an instance of the rule under test
#    _test_info_file_contents()

    native.test_suite(
        name = name,
        tests = [
            # Testing rules inside _test_info_file_contents()
            ":info_file_contents_test",
        ],
    )


