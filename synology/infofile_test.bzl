load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load("//synology:info-file.bzl", "InfoFile", "info_file", "valid_version")
load("//synology:maintainer.bzl", "maintainer")

# ==== Check the InfoFile provider contents ====

def _info_file_version_test_fail_impl(ctx):
    env = analysistest.begin(ctx)
    target_under_test = analysistest.target_under_test(env)

    asserts.false(env, valid_version(target_under_test[InfoFile].version))

    # Done: remember to return end()
    return analysistest.end(env)

def _info_file_version_test_pass_impl(ctx):
    env = analysistest.begin(ctx)
    target_under_test = analysistest.target_under_test(env)

    asserts.true(env, valid_version(target_under_test[InfoFile].version))

    # Done: remember to return end()
    return analysistest.end(env)

# This global variable acts as a handle for the unittest.  It needs to be a global since macros get
# evaluated at loading time but the rule gets evaluated later, at analysis time. Since this is a
# test rule, its name must end with "_test".
info_file_version_pass_test = analysistest.make(_info_file_version_test_pass_impl)
info_file_version_fail_test = analysistest.make(_info_file_version_test_fail_impl)  # "expect_failure = True" didn't work

pass_versions = {
    "P1": "1.2.3-1",
    "P2": "1.2.3.4.5-1234567890",
}
fail_versions = {
    "F1": "1.2.3-1rc14",
    "F2": "1.2.3-1-6",
    "F3": "1.2.3.4.5.6-1",
}

# Macro to setup the test.
def _test_info_file_contents():
    # Rule under test: tagged 'manual' to avoid building on ':all', but remain available as a
    # dependency of the test

    maintainer(
        name = "mock_maint",
        maintainer_name = "Allan Clark",
        maintainer_url = "example.com/allan-is-the-king",
    )

    [info_file(
        name = "info_file_contents_{}".format(k),
        description = "test package info file",
        maintainer = ":mock_maint",
        os_min_ver = "7.1",
        out = "INFO_{}".format(k),
        package_name = "mock_package",
        package_version = v,
        tags = ["manual"],
    ) for k, v in pass_versions.items()]

    [info_file(
        name = "info_file_contents_{}".format(k),
        description = "test package info file",
        maintainer = ":mock_maint",
        os_min_ver = "7.1",
        out = "INFO_{}".format(k),
        package_name = "mock_package",
        package_version = v,
        tags = ["manual"],
    ) for k, v in fail_versions.items()]

    # Testing rule.
    [info_file_version_pass_test(name = "info_file_version_{}_test".format(k), target_under_test = ":info_file_contents_{}".format(k)) for k in pass_versions.keys()]
    [info_file_version_fail_test(name = "info_file_version_{}_test".format(k), target_under_test = ":info_file_contents_{}".format(k)) for k in fail_versions.keys()]

def syno_test_suite(name):
    # call all tests which depend on an instance of the rule under test
    _test_info_file_contents()

    native.test_suite(
        name = name,
        tests = [
            # Testing rules inside _test_info_file_contents()
            ":info_file_version_{}_test".format(k)
            for k in pass_versions.keys()
        ] + [
            ":info_file_version_{}_test".format(k)
            for k in fail_versions.keys()
        ],
    )
