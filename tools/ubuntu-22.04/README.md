# What is this image?

I find that this image closely approximates the build images on GitHub (at least for ubuntu-22.04-20240922)

## Usage

1. docker build -t ubuntu-x86 - \< ~/src/rules_synology/tools/ubuntu-22.04/Dockerfile
1. docker run --rm -it -v ~/src/rules_synology:/rules_synology -w /rules_synology/examples/cross-helloworld ubuntu-x86:latest bazel test //...
