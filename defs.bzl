# Formats guided by https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_synology//synology:images.bzl", _images = "images")
load("@rules_synology//synology:info-file.bzl", _info_file = "info_file")
load("@rules_synology//synology:maintainer.bzl", "Maintainer", _maintainer = "maintainer")
load("@rules_synology//synology:port-service-configure.bzl", _protocol_file = "protocol_file", _service_config = "service_config")
load("@rules_synology//synology:resource-configure.bzl", _resource_config = "resource_config")

SPK_REQUIRED_SCRIPTS = ["preinst", "postinst", "preuninst", "postuninst", "preupgrade", "postupgrade"]

# pass-thru

images = _images
info_file = _info_file
maintainer = _maintainer
protocol_file = _protocol_file
resource_config = _resource_config
service_config = _service_config
