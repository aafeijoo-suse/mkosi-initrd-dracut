#!/bin/bash
# Copyright (c) 2024 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later

# Extracted from https://github.com/openSUSE/dracut/blob/SUSE/059/dracut.sh
usage() {
    cat << EOF
Usage: dracut [OPTION]... [<initramfs> [<kernel-version>]]

Version: $DRACUT_VERSION

Creates initial ramdisk images for preloading modules

  -h, --help  Display all options

EOF
}

# Extracted from https://github.com/openSUSE/dracut/blob/SUSE/059/dracut.sh
long_usage() {
    cat << EOF
Usage: dracut [OPTION]... [<initramfs> [<kernel-version>]]

Creates initial ramdisk images for preloading modules

NOTE: these are all the options originally available with dracut, but some of
      them are not implemented in this wrapper.

  --kver [VERSION]      Set kernel version to [VERSION].
  -f, --force           Overwrite existing initramfs file.
  [OUTPUT_FILE] --rebuild
                        Append the current arguments to those with which the
                         input initramfs image was built. This option helps in
                         incrementally building the initramfs for testing.
                         If optional [OUTPUT_FILE] is not provided, the input
                         initramfs provided to rebuild will be used as output
                         file.
  -a, --add [LIST]      Add a space-separated list of dracut modules.
  --force-add [LIST]    Force to add a space-separated list of dracut modules
                         to the default set of modules, when -H is specified.
  -o, --omit [LIST]     Omit a space-separated list of dracut modules.
  -m, --modules [LIST]  Specify a space-separated list of dracut modules to
                         call when building the initramfs. Modules are located
                         in /usr/lib/dracut/modules.d.
                         This option forces dracut to only include the specified
                         dracut modules.
                         In most cases the --add option is what you want to use.
  --add-drivers [LIST]  Specify a space-separated list of kernel
                         modules to add to the initramfs.
  --force-drivers [LIST]
                        Specify a space-separated list of kernel
                         modules to add to the initramfs and make sure they
                         are tried to be loaded via modprobe same as passing
                         rd.driver.pre=DRIVER kernel parameter.
  --omit-drivers [LIST] Specify a space-separated list of kernel
                         modules not to add to the initramfs.
  -d, --drivers [LIST]  Specify a space-separated list of kernel modules to
                         exclusively include in the initramfs.
  --filesystems [LIST]  Specify a space-separated list of kernel filesystem
                         modules to exclusively include in the generic
                         initramfs.
  -k, --kmoddir [DIR]   Specify the directory where to look for kernel
                         modules.
  --fwdir [DIR]         Specify additional colon-separated list of directories
                         where to look for firmware files.
  --libdirs [LIST]      Specify a space-separated list of directories
                         where to look for libraries.
  --kernel-only         Only install kernel drivers and firmware files.
  --no-kernel           Do not install kernel drivers and firmware files.
  --print-cmdline       Print the kernel command line for the given disk layout.
  --early-microcode     Combine early microcode with ramdisk.
  --no-early-microcode  Do not combine early microcode with ramdisk.
  --kernel-cmdline [PARAMETERS]
                        Specify default kernel command line parameters.
  --strip               Strip binaries in the initramfs.
  --aggressive-strip     Strip more than just debug symbol and sections,
                         for a smaller initramfs build. The --strip option must
                         also be specified.
  --nostrip             Do not strip binaries in the initramfs.
  --hardlink            Hardlink files in the initramfs.
  --nohardlink          Do not hardlink files in the initramfs.
  --prefix [DIR]        Prefix initramfs files with [DIR].
  --noprefix            Do not prefix initramfs files.
  --mdadmconf           Include local /etc/mdadm.conf file.
  --nomdadmconf         Do not include local /etc/mdadm.conf file.
  --lvmconf             Include local /etc/lvm/lvm.conf file.
  --nolvmconf           Do not include local /etc/lvm/lvm.conf file.
  --fscks [LIST]        Add a space-separated list of fsck helpers.
  --nofscks             Inhibit installation of any fsck helpers.
  --ro-mnt              Mount / and /usr read-only by default.
  -h, --help            This message.
  --debug               Output debug information of the build process.
  --profile             Output profile information of the build process.
  -L, --stdlog [0-6]    Specify logging level (to standard error)
                         0 - suppress any messages
                         1 - only fatal errors
                         2 - all errors
                         3 - warnings
                         4 - info
                         5 - debug info (here starts lots of output)
                         6 - trace info (and even more)
  -v, --verbose         Increase verbosity level.
  -q, --quiet           Decrease verbosity level.
  -c, --conf [FILE]     Specify configuration file to use.
                         Default: /etc/dracut.conf
  --confdir [DIR]       Specify configuration directory to use *.conf files
                         from. Default: /etc/dracut.conf.d
  --tmpdir [DIR]        Temporary directory to be used instead of default
                         ${TMPDIR:-/var/tmp}.
  -r, --sysroot [DIR]   Specify sysroot directory to collect files from.
  -l, --local           Local mode. Use modules from the current working
                         directory instead of the system-wide installed in
                         /usr/lib/dracut/modules.d.
                         Useful when running dracut from a git checkout.
  -H, --hostonly        Host-only mode: Install only what is needed for
                         booting the local host instead of a generic host.
  -N, --no-hostonly     Disables host-only mode.
  --hostonly-mode [MODE]
                        Specify the host-only mode to use. [MODE] could be
                         one of "sloppy" or "strict". "sloppy" mode is used
                         by default.
                         In "sloppy" host-only mode, extra drivers and modules
                         will be installed, so minor hardware change won't make
                         the image unbootable (e.g. changed keyboard), and the
                         image is still portable among similar hosts.
                         With "strict" mode enabled, anything not necessary
                         for booting the local host in its current state will
                         not be included, and modules may do some extra job
                         to save more space. Minor change of hardware or
                         environment could make the image unbootable.
                         DO NOT use "strict" mode unless you know what you
                         are doing.
  --hostonly-cmdline    Store kernel command line arguments needed
                         in the initramfs.
  --no-hostonly-cmdline Do not store kernel command line arguments needed
                         in the initramfs.
  --no-hostonly-default-device
                        Do not generate implicit host devices like root,
                         swap, fstab, etc. Use "--mount" or "--add-device"
                         to explicitly add devices as needed.
  --hostonly-i18n       Install only needed keyboard and font files according
                         to the host configuration (default).
  --no-hostonly-i18n    Install all keyboard and font files available.
  --hostonly-nics [LIST]
                        Only enable listed NICs in the initramfs. The list can
                         be empty, so other modules can install only the
                         necessary network drivers.
  --persistent-policy [POLICY]
                        Use [POLICY] to address disks and partitions.
                         POLICY can be any directory name found in /dev/disk
                         (e.g. "by-uuid", "by-label"), or "mapper" to use
                         /dev/mapper device names (default).
  --fstab               Use /etc/fstab to determine the root device.
  --add-fstab [FILE]    Add file to the initramfs fstab.
  --mount "[DEV] [MP] [FSTYPE] [FSOPTS]"
                        Mount device [DEV] on mountpoint [MP] with filesystem
                         [FSTYPE] and options [FSOPTS] in the initramfs.
  --mount "[MP]"        Same as above, but [DEV], [FSTYPE] and [FSOPTS] are
                         determined by looking at the current mounts.
  --add-device "[DEV]"  Bring up [DEV] in initramfs.
  -i, --include [SOURCE] [TARGET]
                        Include the files in the SOURCE directory into the
                         Target directory in the final initramfs.
                        If SOURCE is a file, it will be installed to TARGET
                         in the final initramfs.
  -I, --install [LIST]  Install the space separated list of files into the
                         initramfs.
  --install-optional [LIST]
                        Install the space separated list of files into the
                         initramfs, if they exist.
  --gzip                Compress the generated initramfs using gzip.
                         This will be done by default, unless another
                         compression option or --no-compress is passed.
  --bzip2               Compress the generated initramfs using bzip2.
                         Make sure your kernel has bzip2 decompression support
                         compiled in, otherwise you will not be able to boot.
  --lzma                Compress the generated initramfs using lzma.
                         Make sure your kernel has lzma support compiled in,
                         otherwise you will not be able to boot.
  --xz                  Compress the generated initramfs using xz.
                         Make sure that your kernel has xz support compiled
                         in, otherwise you will not be able to boot.
  --lzo                 Compress the generated initramfs using lzop.
                         Make sure that your kernel has lzo support compiled
                         in, otherwise you will not be able to boot.
  --lz4                 Compress the generated initramfs using lz4.
                         Make sure that your kernel has lz4 support compiled
                         in, otherwise you will not be able to boot.
  --zstd                Compress the generated initramfs using Zstandard.
                         Make sure that your kernel has zstd support compiled
                         in, otherwise you will not be able to boot.
  --compress [COMPRESSION]
                        Compress the generated initramfs with the
                         passed compression program.  Make sure your kernel
                         knows how to decompress the generated initramfs,
                         otherwise you will not be able to boot.
  --no-compress         Do not compress the generated initramfs. This will
                         override any other compression options.
  --squash-compressor [COMPRESSION]
                        Specify the compressor and compressor specific options
                         used by mksquashfs if squash module is called when
                         building the initramfs.
  --enhanced-cpio       Attempt to reflink cpio file data using dracut-cpio.
  --list-modules        List all available dracut modules.
  -M, --show-modules    Print included module's name to standard output during
                         build.
  --keep                Keep the temporary initramfs for debugging purposes.
  --printsize           Print out the module install size.
  --sshkey [SSHKEY]     Add SSH key to initramfs (use with ssh-client module)
  --logfile [FILE]      Logfile to use (overrides configuration setting)
  --check-supported     Check to ensure that modules are marked supported when
                         using a kernel that is configured to check the
                         support status of a module before loading.
  --reproducible        Create reproducible images.
  --no-reproducible     Do not create reproducible images.
  --loginstall [DIR]    Log all files installed from the host to [DIR].
  --uefi                Create an UEFI executable with the kernel cmdline and
                         kernel combined.
  --no-uefi             Disables UEFI mode.
  --no-machineid        Affects the default output filename of the UEFI
                         executable, discarding the <MACHINE_ID> part.
  --uefi-stub [FILE]    Use the UEFI stub [FILE] to create an UEFI executable.
  --uefi-splash-image [FILE]
                        Use [FILE] as a splash image when creating an UEFI
                         executable. Requires bitmap (.bmp) image format.
  --kernel-image [FILE] Location of the kernel image.
  --regenerate-all      Regenerate all initramfs images at the default location
                         for the kernel versions found on the system.
  -p, --parallel        Use parallel processing if possible (currently only
                        supported --regenerate-all)
                        images simultaneously.
  --version             Display version.

If [LIST] has multiple arguments, then you have to put these in quotes.

For example:

    # dracut --add-drivers "module1 module2"  ...

EOF
}

# Extracted from https://github.com/openSUSE/dracut/blob/SUSE/059/dracut.sh
check_conf_file() {
    if grep -H -e '^[^#]*[+]=\("[^ ]\|.*[^ ]"\)' "$@"; then
        printf '\ndracut[W]: <key>+=" <values> ": <values> should have surrounding white spaces!\n' >&2
        printf 'dracut[W]: This will lead to unwanted side effects! Please fix the configuration file.\n\n' >&2
    fi
}

# Extracted from https://github.com/openSUSE/dracut/blob/SUSE/059/dracut.sh
dropindirs_sort() {
    local suffix=$1
    shift
    local -a files
    local f d

    for d in "$@"; do
        for i in "$d/"*"$suffix"; do
            if [[ -e $i ]]; then
                printf "%s\n" "${i##*/}"
            fi
        done
    done | sort -Vu | {
        readarray -t files

        for f in "${files[@]}"; do
            for d in "$@"; do
                if [[ -e "$d/$f" ]]; then
                    printf "%s\n" "$d/$f"
                    continue 2
                fi
            done
        done
    }
}

# Extracted from https://github.com/openSUSE/dracut/blob/SUSE/059/dracut.sh
rearrange_params() {
    # Workaround -i, --include taking 2 arguments
    newat=()
    for i in "$@"; do
        if [[ $i == "-i" ]] || [[ $i == "--include" ]]; then
            newat+=("++include") # Replace --include by ++include
        else
            newat+=("$i")
        fi
    done
    set -- "${newat[@]}" # Set new $@

    # shellcheck disable=SC2034
    TEMP=$(
        unset POSIXLY_CORRECT
        getopt \
            -o "a:m:o:d:I:k:c:r:L:fvqlHhMNp" \
            --long kver: \
            --long add: \
            --long force-add: \
            --long add-drivers: \
            --long force-drivers: \
            --long omit-drivers: \
            --long modules: \
            --long omit: \
            --long drivers: \
            --long filesystems: \
            --long install: \
            --long install-optional: \
            --long fwdir: \
            --long libdirs: \
            --long fscks: \
            --long add-fstab: \
            --long mount: \
            --long device: \
            --long add-device: \
            --long nofscks \
            --long ro-mnt \
            --long kmoddir: \
            --long conf: \
            --long confdir: \
            --long tmpdir: \
            --long sysroot: \
            --long stdlog: \
            --long compress: \
            --long squash-compressor: \
            --long prefix: \
            --long rebuild: \
            --long force \
            --long kernel-only \
            --long no-kernel \
            --long print-cmdline \
            --long kernel-cmdline: \
            --long strip \
            --long aggressive-strip \
            --long nostrip \
            --long hardlink \
            --long nohardlink \
            --long noprefix \
            --long mdadmconf \
            --long nomdadmconf \
            --long lvmconf \
            --long nolvmconf \
            --long debug \
            --long profile \
            --long sshkey: \
            --long logfile: \
            --long verbose \
            --long quiet \
            --long local \
            --long hostonly \
            --long host-only \
            --long no-hostonly \
            --long no-host-only \
            --long hostonly-mode: \
            --long hostonly-cmdline \
            --long no-hostonly-cmdline \
            --long no-hostonly-default-device \
            --long persistent-policy: \
            --long fstab \
            --long help \
            --long bzip2 \
            --long lzma \
            --long xz \
            --long lzo \
            --long lz4 \
            --long zstd \
            --long no-compress \
            --long gzip \
            --long enhanced-cpio \
            --long list-modules \
            --long show-modules \
            --long keep \
            --long printsize \
            --long regenerate-all \
            --long parallel \
            --long noimageifnotneeded \
            --long early-microcode \
            --long no-early-microcode \
            --long check-supported \
            --long reproducible \
            --long no-reproducible \
            --long loginstall: \
            --long uefi \
            --long no-uefi \
            --long uefi-stub: \
            --long uefi-splash-image: \
            --long kernel-image: \
            --long no-hostonly-i18n \
            --long hostonly-i18n \
            --long hostonly-nics: \
            --long no-machineid \
            --long version \
            -- "$@"
    )

    # shellcheck disable=SC2181
    if (($? != 0)); then
        usage
        exit 1
    fi
}

error_option_not_implemented() {
    printf "dracut[F]: option '%s' not implemented on the dracut compatibility wrapper.\n" "$1" >&2
    exit 1
}

