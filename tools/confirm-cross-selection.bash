#!bash

TOOLS=$(dirname $(readlink -f $0))
TMPFILE=$(mktemp -t check)
trap "rm -f ${TMPFILE}" EXIT

docker build -t test-x86 - < ${TOOLS}/dockcross-linux-x86-bazel/Dockerfile

docker run --rm -it -v $(dirname ${TOOLS}):/rules_synology -w /rules_synology/examples/cross-helloworld test-x86:latest /usr/bin/bazel build --platforms=@rules_synology//models:ds1819+  --incompatible_enable_cc_toolchain_resolution --toolchain_resolution_debug=.* //... 2>&1 | tee ${TMPFILE}/cross-stderr

grep denverton-gcc850_glibc226_x86_64-GPL//:cc_toolchain ${TMPFILE}/cross-stderr >/dev/null 2>&1 || { echo "denvertoon toolchain not considered"; exit 1; }

exit 0
