# I find myself writing this basic SSS script over and over; this should be templated, with some
# basic flexibility, split to other perhaps if this stretches the single function too far.

load("//synology:info-file.bzl", "InfoFile")
load("//synology:docker-project.bzl", "DockerProject")


SSSInfo = provider(
    fields = {
        "bogus": "no fields yet..."
    },
)

def _simple_start_stop_script_impl(ctx):
    outfile = ctx.outputs.outscript or ctx.actions.declare_file("start-stop-status")
    docker_projects = []
    package_name = ""  # set by giving an "info_file" as deps

    for d in ctx.attr.deps or []:
        #typeswitch on provider
        if DockerProject in d:
            for name,path in d[DockerProject].projects.items():
                docker_projects.append(path)
        elif InfoFile in d:
            package_name = d[InfoFile].package
        else:
            print("Dependency {} skipped: no recognized providers".format(d.label))


    compose_up_command = ""
    compose_down_command = ""
    compose_status_command = ""

    # this needs to have both package name and docker_projects defined
    if len(docker_projects) and not package_name:
        print("DockerProject dependency needs an info_file() dep to provide package_name")
    elif len(docker_projects):
        # example:  docker-compose -f /var/packages/<package>/target/<path>/compose.yaml up
        compose_down_command = "for p in {}; do docker-compose -f /var/packages/{package_name}/target/${{p}}/compose.yaml down; done".format(" ".join(docker_projects), package_name = package_name)
        compose_up_command = "for p in {}; do docker-compose -p {package_name} -f /var/packages/{package_name}/target/${{p}}/compose.yaml up --detach; done".format(" ".join(docker_projects), package_name = package_name)

        # example: docker-compose ls --format json | jq -c --arg PN "talospxe" '.[]|select(.Name==$PN)|{Name, Status}'
        print("package_name is", package_name)
        compose_status_command = "docker-compose ls --format json | jq -c --arg PN {} '.[]|select(.Name==$PN)|{{Name, Status}}'".format(package_name)

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = outfile,
        substitutions = {
            "COMPOSE_DOWN": compose_down_command,
            "COMPOSE_STATUS": compose_status_command,
            "COMPOSE_UP": compose_up_command,
        },
        is_executable = True,
    )

    return [
        DefaultInfo(files = depset([outfile])),
        SSSInfo(bogus = "bogus"),
    ]

simple_start_stop_script = rule(
    doc = "This function provides a method of programmatically creatng the start/stop service script.  It may become much more as the ruleset evolves.",
    implementation = _simple_start_stop_script_impl,
    attrs = {
        "_template": attr.label(allow_single_file = True, default = "start_stop_template_simple.tpl"),
        "deps": attr.label_list(mandatory = False),   # providers = [InfoFile, DockerProject]
        "outscript": attr.output(),
    },
)

