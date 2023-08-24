FROM dockcross/linux-x86

RUN mkdir -p /usr/bin && curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 && chmod +x /usr/bin/bazel
RUN echo 'build --platforms=@rules_synology//models:ds1819+  --incompatible_enable_cc_toolchain_resolution --toolchain_resolution_debug=.*' > ~root/.bazelrc
# --experimental_enable_docker_sandbox --spawn_strategy=docker,sandboxed
