# Reference Documentation

rules_synology is still early-days; a lot of this can still change.  In many ways, I'm still
putting together SPKs that I can check and verify.

- Toolchains are not all there
- Some of the targets are a bit fine-grained yet until I can see some usage-patterns that could be
    optimized by lumping behind some macros.
- Am I using `platforms` completely incorrectly?
- Wondering how a Transition, Aspect, or similar can build for multiple target platforms at once

I do appreciate more eyes here.

Please submit ideas, gaps, things I have missed, could document, could clarify (broken example
repos are helpful).  Do connect: my contact info is in the .bcr subdir.

## Specific Actions

- [docker_project()](docs.md#docker_project): Create services using `docker-compose` files
- [usr_local_linker()](docs.md#usr_local_linker): link SPK components to bin, lib, or etc

## Common Rules

- [images() : define icon](docs.md#images)
- [info_file() : metadata about the SPK](docs.md#info_file)
- [maintainer() : identify the maintainer](docs.md#maintainer)
- [privilege_config() : SPK privileges](docs.md#privilege_config)
- [protocol_file() : SPK entrypoints / open ports](docs.md#protocol_file)
- [resource_config()](docs.md#resource_config)
- [service_config() : Services run by the SPK](docs.md#service_config)

## Validation

- [confirm_binary_matches_platform()](docs.md#confirm_binary_matches_platform)
