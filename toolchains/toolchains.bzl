# URL from https://archive.synology.com/download/ToolChain/toolchain/7.1-42661
TOOLCHAINS = {
    # https://global.synologydownload.com/download/ToolChain/toolchain/7.2-72746/Marvell%20Armada%2037xx%20Linux%204.4.302/armada37xx-gcc1220_glibc236_armv8-GPL.txz
    # https://global.synologydownload.com/download/ToolChain/toolchain/7.1-42661/Marvell%20Armada%2037xx%20Linux%204.4.180/armada37xx-gcc850_glibc226_armv8-GPL.txz
    "armada37xx-gcc850_glibc226_armv8-GPL": {
        "arch_desc": "Marvell Armada 37cc SoC (64bit)",  # Marvell 88F3710, 88F3720
        "buildcpu": "x86_64",
        "buildos": "linux",
        "common_name": "Armada37xx",
        "cpu": "arm64",  # aarch64", armv8
        "dsm_version": "7.1-42661",
        "kernel_version": "4.4.180",
        "prefix": "aarch64-unknown-linux-gnu",
        "sha256": "8188ffc98675e9185900e54550ea21962fa690974eb66cea3e5209591c000ff3",
        "subdir": "Marvell%20Armada%2037xx%20Linux%204.4.180",
        "package_arch": "armada37xx",  # TODO: can we replace with a v["common_name"].lower() ?
    },
    # https://global.synologydownload.com/download/ToolChain/toolchain/7.2-72746/Intel%20x86%20Linux%204.4.302%20%28Denverton%29/denverton-gcc1220_glibc236_x86_64-GPL.txz
    # https://global.synologydownload.com/download/ToolChain/toolchain/7.1-42661/Intel%20x86%20Linux%204.4.180%20%28Denverton%29/denverton-gcc850_glibc226_x86_64-GPL.txz
    "denverton-gcc850_glibc226_x86_64-GPL": {
        "arch_desc": "Intel Atom C3538 (x86 64bit)",
        "buildcpu": "x86_64",
        "buildos": "linux",
        "common_name": "Denverton",
        "cpu": "x86_64",  # "x86_64",
        "dsm_version": "7.1-42661",
        "kernel_version": "4.4.180",
        "prefix": "x86_64-pc-linux-gnu",
        "sha256": "06e77a4fc703d5dd593f1ca7580ef65eca7335329dfeed44ff80789394d8f23c",
        "subdir": "Intel%20x86%20Linux%204.4.180%20%28Denverton%29",
        "package_arch": "denverton",
    },
    "geminilake-gcc850_glibc226_x86_64-GPL": {
        "alias": "GLK",
        "arch_desc": "Intel Celeron J4125 (x86 64bit)",
        "buildcpu": "x86_64",
        "buildos": "linux",
        "common_name": "GeminiLake",
        "cpu": "x86_64",  # "x86_64",
        "dsm_version": "7.1-42661",
        "kernel_version": "4.4.180",
        "prefix": "x86_64-pc-linux-gnu",
        "sha256": "653789339d20262c31546371ab457d99faff88729e16cf91f3f7cced5606daf6",
        "subdir": "Intel%20x86%20Linux%204.4.180%20%28GeminiLake%29",
        "package_arch": "geminilake",
    },
}

#    "r1000": {
#        "cpu": "x86",
#        "desc": "AMD Ryzen R1xxx (x86-64)",
#    },
#    "rtd1619b": {
#        "cpu": "arm64",
#        "desc": "Realtek RTD1619B (armv8-A)",
#    },
#    "v1000": {
#        "cpu": "x86",
#        "desc": "AMD Ryzen V1xxxB (x86-64)",
#    },
