mkosi-initrd-dracut
====

dracut compatibility wrapper for mkosi-initrd

> [!WARNING]
> This is a PoC in its early stage for testing purposes only.

OBS PoC repo for openSUSE Tumbleweed:

```
$ zypper ar https://download.opensuse.org/repositories/home:/afeijoo:/poc/openSUSE_Tumbleweed/?ssl_verify=no mkosi-initrd-poc
$ zypper ref mkosi-initrd-poc
$ zypper in --from mkosi-initrd-poc mkosi-initrd-dracut
```

Licensed under the GPLv2
