#!/bin/bash --norc
#
# dracut compatibility wrapper for mkosi-initrd.
#
# Copyright (c) 2024 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Some parts extracted from https://github.com/openSUSE/dracut/blob/SUSE/059/dracut.sh

DRACUT_BIN="${DRACUT_BIN:-/usr/bin/dracut}"
DRACUT_LIB_DIR="${DRACUT_LIB_DIR:-/usr/lib/dracut}"
MKOSI_INITRD_BIN="${MKOSI_INITRD_BIN:-/usr/bin/mkosi-initrd}"
MKOSI_INITRD_CONF_DIR="/run/mkosi-initrd/mkosi.conf.d"
MKOSI_INITRD_DRACUT_LIB_DIR="${MKOSI_INITRD_DRACUT_LIB_DIR:-/usr/lib/mkosi-initrd-dracut}"
TMP_DIR="${TMP_DIR:-/var/tmp}"

# check that mkosi-initrd exists
if [[ ! -x "$MKOSI_INITRD_BIN" ]]; then
    printf "dracut[F]: Cannot find %s\n" "$MKOSI_INITRD_BIN" >&2
    exit 1
fi

# source mkosi-initrd dracut lib
if [[ -f "dracut-lib.sh" ]]; then
    # shellcheck disable=SC1091
    . "dracut-lib.sh"
elif [[ -f "$MKOSI_INITRD_DRACUT_LIB_DIR/dracut-lib.sh" ]]; then
    # shellcheck disable=SC1091
    . "$MKOSI_INITRD_DRACUT_LIB_DIR/dracut-lib.sh"
else
    printf "dracut[F]: Cannot find %s/dracut-lib.sh\n" "$MKOSI_INITRD_DRACUT_LIB_DIR" >&2
    exit 1
fi

dracut_args=("$@")
# shellcheck disable=SC2155
readonly dracut_cmd=$(readlink -f "$0")

debug="no"
kernel=
outfile=
outdir=

rearrange_params "$@"
eval set -- "$TEMP"

# parse command line args to check if '--rebuild' option is present
while :; do
    if [[ "$1" == "--" ]]; then
        shift
        break
    fi
    if [[ "$1" == "--rebuild" ]]; then
        shift
        continue
    fi
    shift
done

# get output file name and kernel version from command line arguments
while (($# > 0)); do
    case ${1%%=*} in
        ++include)
            shift 2
            ;;
        *)
            if [[ -z "$outfile" ]]; then
                outfile=$1
            elif [[ -z "$kernel" ]]; then
                kernel=$1
            else
                printf "dracut[F]: Unknown arguments: %s\n" "$*" >&2
                usage
                exit 1
            fi
            ;;
    esac
    shift
done

eval set -- "$TEMP"

while :; do
    case $1 in
        --kver)
            kernel="$2"
            shift
            ;;
        -a | --add)
            error_option_not_implemented "$1"
            ;;
        --force-add)
            error_option_not_implemented "$1"
            ;;
        --add-drivers)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --force-drivers)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --omit-drivers)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -m | --modules)
            error_option_not_implemented "$1"
            ;;
        -o | --omit)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -d | --drivers)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --filesystems)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -I | --install)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --install-optional)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --fwdir)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --libdirs)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --fscks)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --add-fstab)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --mount)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --add-device | --device)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --kernel-cmdline)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --nofscks)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --ro-mnt)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -k | --kmoddir)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -c | --conf)
            conffile="$2"
            ;;
        --confdir)
            confdir="$2"
            ;;
        --tmpdir)
            #TODO: propagate to mkosi-initrd
            TMP_DIR="$2"
            shift
            ;;
        -L | --stdlog)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --compress)
            error_option_not_implemented "$1"
            ;;
        --squash-compressor)
            error_option_not_implemented "$1"
            ;;
        --prefix)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --loginstall)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --rebuild)
            error_option_not_implemented "$1"
            ;;
        -f | --force)
            # mkosi-initrd always calls mkosi with --force
            ;;
        --kernel-only)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-kernel)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --print-cmdline)
            error_option_not_implemented "$1"
            ;;
        --early-microcode)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-early-microcode)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --strip)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --aggressive-strip)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --nostrip)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --hardlink)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --nohardlink)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --noprefix)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --mdadmconf)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --nomdadmconf)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --lvmconf)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --nolvmconf)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --debug)
            debug="yes"
            ;;
        --profile)
            error_option_not_implemented "$1"
            ;;
        --sshkey)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --logfile)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -v | --verbose)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -q | --quiet)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -l | --local)
            error_option_not_implemented "$1"
            ;;
        -H | --hostonly | --host-only)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -N | --no-hostonly | --no-host-only)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --hostonly-mode)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --hostonly-cmdline)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --hostonly-i18n)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --hostonly-nics)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-hostonly-i18n)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-hostonly-cmdline)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-hostonly-default-device)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --persistent-policy)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --fstab)
            #TODO
            error_option_not_implemented "$1"
            ;;
        -h | --help)
            long_usage
            exit 0
            ;;
        --bzip2)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --lzma)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --xz)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --lzo)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --lz4)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --zstd)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-compress)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --gzip)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --enhanced-cpio)
            error_option_not_implemented "$1"
            ;;
        --list-modules)
            error_option_not_implemented "$1"
            ;;
        -M | --show-modules)
            error_option_not_implemented "$1"
            ;;
        --keep)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --printsize)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --regenerate-all)
            regenerate_all_l="yes"
            ;;
        -p | --parallel)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --noimageifnotneeded)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --check-supported)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --reproducible)
            reproducible_l="yes"
            ;;
        --no-reproducible)
            reproducible_l="no"
            ;;
        --uefi)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-uefi)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --uefi-stub)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --uefi-splash-image)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --kernel-image)
            #TODO
            error_option_not_implemented "$1"
            ;;
        --no-machineid)
            error_option_not_implemented "$1"
            ;;
        --version)
            printf "dracut[I]: compatibility wrapper for mkosi-initrd.\n" >&2
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            printf "dracut[F]: Unknown option: '%s'\n" "$1" >&2
            usage
            exit 1
            ;;
    esac
    shift
done

# getopt cannot handle multiple arguments, so just handle "-I,--include" the old
# fashioned way
while (($# > 0)); do
    if [[ "${1%%=*}" == "++include" ]]; then
        include_src+=("$2")
        include_target+=("$3")
        shift 2
    fi
    shift
done

# if we were not passed a config file, try the default one
if [[ -z $conffile ]]; then
    if [[ $allowlocal ]]; then
        conffile="$DRACUT_LIB_DIR/dracut.conf"
    else
        conffile="/etc/dracut.conf"
    fi
elif [[ ! -e $conffile ]]; then
    printf "dracut[F]: Configuration file '%s' not found.\n" "$conffile" >&2
    exit 1
fi

if [[ -z $confdir ]]; then
    if [[ $allowlocal ]]; then
        confdir="$DRACUT_LIB_DIR/dracut.conf.d"
    else
        confdir="/etc/dracut.conf.d"
    fi
elif [[ ! -d $confdir ]]; then
    printf "dracut[F]: Configuration directory '%s' not found.\n" "$confdir" >&2
    exit 1
fi

# source dracut config file
if [[ -f $conffile ]]; then
    check_conf_file "$conffile"
    # shellcheck disable=SC1090
    . "$conffile"
fi

# source dracut config dir
for f in $(dropindirs_sort ".conf" "$confdir" "$DRACUT_LIB_DIR/dracut.conf.d"); do
    check_conf_file "$f"
    # shellcheck disable=SC1090
    [[ -e $f ]] && . "$f"
done

# regenerate_all shouldn't be set in conf files
regenerate_all=$regenerate_all_l

#FIXME: mkosi-initrd does not provide anything like --regenerate-all yet
if [[ "$regenerate_all" == "yes" ]]; then
    ret=0
    if [[ "$kernel" ]]; then
        printf "dracut[F]: --regenerate-all cannot be called with a kernel version.\n" >&2
        exit 1
    fi
    if [[ "$outfile" ]]; then
        printf "dracut[F]: --regenerate-all cannot be called with an image file.\n" >&2
        exit 1
    fi

    ((len = ${#dracut_args[@]}))
    for ((i = 0; i < len; i++)); do
        case ${dracut_args[$i]} in
            --regenerate-all)
                # shellcheck disable=SC2184
                unset dracut_args["$i"]
                ;;
        esac
    done

    for i in /lib/modules/*; do
        [[ -f "$i/modules.dep" ]] || [[ -f "$i/modules.dep.bin" ]] || continue
        [[ -d "$i/kernel" ]] || continue
        "$dracut_cmd" --kver="$i" "${dracut_args[@]}"
        ((ret += $?))
    done
    exit "$ret"
fi

# Set running kernel version if not set
[[ -n "$kernel" ]] || kernel="$(uname -r)"

# split outdir from outfile
if [[ -n "$outfile" ]]; then
    abs_outfile=$(readlink -f "$outfile") && outfile="$abs_outfile"
else
    # Fixed SUSE old path, no BLS autodetection
    outfile="/boot/initrd-$kernel"
fi
outdir="${outfile%/*}"
[[ -n "$outdir" ]] || outdir="/"
outfilename="${outfile##*/}"

# these options add to the stuff in the configuration file
#TODO

# these options override the stuff in the configuration file
[[ -n "$reproducible_l" ]] && reproducible="$reproducible_l"
#TODO

# set mkosi-initrd command line options
cmd_options=()
cmd_options+=("--kernel-version" "$kernel")
cmd_options+=("--output" "$outfilename")
cmd_options+=("--output-dir" "$outdir")
[[ "$debug" == "yes" ]] && cmd_options+=("--debug")

# translate dracut options into mkosi configuration options
rm -rf "$MKOSI_INITRD_CONF_DIR"
mkdir -p "$MKOSI_INITRD_CONF_DIR"
if [[ ! -d "$MKOSI_INITRD_CONF_DIR" ]]; then
    printf "dracut[F]: Failed to create %d transient configuration directory.\n" "$MKOSI_INITRD_CONF_DIR" >&2
    exit 1
fi
if [[ "$reproducible" == "yes" ]]; then
    {
        printf "[Output]\n"
        printf "Seed=00000000-0000-0000-0000-000000000000\n"
        printf "\n"
        printf "[Content]\n"
        printf "SourceDateEpoch=0\n"
    } >> "$MKOSI_INITRD_CONF_DIR/01-reproducible.conf"
fi

# call mkosi-initrd
# shellcheck disable=SC2046 disable=SC2048 disable=SC2086
"$MKOSI_INITRD_BIN" $([[ ${#cmd_options[@]} -gt 0 ]] && echo ${cmd_options[*]})
exit $?
