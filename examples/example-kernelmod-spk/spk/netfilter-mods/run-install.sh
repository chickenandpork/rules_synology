#!/bin/bash

# INSTALL_K3S_SKIP_DOWNLOAD: we already have the k3s binary in the payload, and this allow us to
#     avoid net traffic and be aggressively consistent
# INSTALL_K3S_SKIP_SELINUX_RPM: DSM has no selinux, so skip.  This is the default because the
#     /usr/share/selinux directory won't be found by the installer. but let's make the implicit
#     very explicit here
# INSTALL_K3S_SYMLINK: pre-remove any symlink to the other (non-k3s) binaries, create symlinks in
#     /usr/local/bin/ for the binaries to the k3s binary (which this script assumes is in
#     /usr/local/bin already)
# INSTALL_K3S_BIN_DIR_READ_ONLY: yeah, just go and skip writing anything to the bin directory.  The
#     only thing we miss are the symlinks, so a patch in a genrule() will cause the create_symlinks
#     to still run.

INSTALL_K3S_BIN_DIR_READ_ONLY=true \
INSTALL_K3S_SKIP_DOWNLOAD=true \
INSTALL_K3S_SKIP_SELINUX_RPM=true \
INSTALL_K3S_SYMLINK=force \
exec $(dirname $0)/install.sh

