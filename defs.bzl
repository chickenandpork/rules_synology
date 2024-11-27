# Formats guided by https://global.download.synology.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Developer_Guide_7_enu.pdf

load("//synology:docker-project.bzl", _docker_compose = "docker_compose", _docker_project = "docker_project")
load("//synology:images.bzl", _images = "images")
load("//synology:info-file.bzl", _info_file = "info_file")
load("//synology:maintainer.bzl", "Maintainer", _maintainer = "maintainer")
load("//synology:port-service-configure.bzl", _protocol_file = "protocol_file", _service_config = "service_config")
load("//synology:privilege-configure.bzl", _privilege_config = "privilege_config")
load("//synology:resource-configure.bzl", _resource_config = "resource_config")
load("//synology:unittests.bzl", _confirm_binary_matches_platform = "confirm_binary_matches_platform", _spk_component = "spk_component")
load("//synology:usr-local-linker.bzl", _usr_local_linker = "usr_local_linker")

SPK_REQUIRED_SCRIPTS = ["preinst", "postinst", "preuninst", "postuninst", "preupgrade", "postupgrade"]

# pass-thru

confirm_binary_matches_platform = _confirm_binary_matches_platform

#docker_compose = _docker_compose
docker_compose = _docker_compose
docker_project = _docker_project
images = _images
info_file = _info_file
maintainer = _maintainer
privilege_config = _privilege_config
protocol_file = _protocol_file
resource_config = _resource_config
service_config = _service_config
spk_component = _spk_component
usr_local_linker = _usr_local_linker
