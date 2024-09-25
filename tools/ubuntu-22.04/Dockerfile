# https://raw.githubusercontent.com/sun-asterisk-research/actions-runner/refs/heads/main/Dockerfile
FROM ghcr.io/actions/actions-runner:latest
ENV RUNNER_VERSION=2.316.1

RUN sudo apt update -y \
  && sudo apt install build-essential file git curl pkg-config libssl-dev vim -y \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y

ENV HELPER_SCRIPTS=/scripts/helpers
ENV HOME=/home/runner

RUN sudo chmod 777 /root/
RUN echo "set -o vi" | sudo tee /home/runner/.bash_aliases

RUN sudo mkdir -p /usr/local/bin && sudo curl -Lo /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 && sudo chmod +x /usr/local/bin/bazel
RUN sudo mkdir -p /usr/local/bin && sudo curl -Lo /usr/local/bin/ibazel https://github.com/bazelbuild/bazel-watcher/releases/download/v0.23.7/ibazel_linux_amd64 && sudo chmod +x /usr/local/bin/ibazel
RUN echo 'build --incompatible_enable_cc_toolchain_resolution --toolchain_resolution_debug=.*' | sudo tee ~root/.bazelrc
#RUN echo 'build --platforms=@rules_synology//models:ds1819+'  >> ~root/.bazelrc
RUN echo 'build --platforms=@rules_synology//models:ds224+' | sudo tee -a ~root/.bazelrc
# --experimental_enable_docker_sandbox --spawn_strategy=docker,sandboxed
