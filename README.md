# ucore-kmods

[![build-ucore](https://github.com/bsherman/ucore-kmods/actions/workflows/build.yml/badge.svg)](https://github.com/bsherman/ucore-kmods/actions/workflows/build.yml)

## What is this?

A WIP layer to provide kernel modules for use in other [Fedora CoreOS](https://getfedora.org/coreos/) images.

## Features

This image currently contains:

- ZFS (including debug packages)

### NOTE: the ZFS kmods are not yet signed to enable secure boot

A list of all RPMs is generated with each build, a snapshot of this list looks like this:

```
/tmp/rpms
/tmp/rpms/debug
/tmp/rpms/debug/kmod-zfs-6.1.11-200.fc37.x86_64-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/libnvpair3-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/libuutil3-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/libzfs5-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/libzpool5-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/zfs-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/zfs-debugsource-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/zfs-kmod-debugsource-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/debug/zfs-test-debuginfo-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/devel
/tmp/rpms/devel/kmod-zfs-devel-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/devel/kmod-zfs-devel-6.1.11-200.fc37.x86_64-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/devel/libzfs5-devel-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/kmod-zfs-6.1.11-200.fc37.x86_64-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/libnvpair3-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/libuutil3-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/libzfs5-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/libzpool5-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/other
/tmp/rpms/other/zfs-dracut-2.1.9-1.fc37.noarch.rpm
/tmp/rpms/other/zfs-test-2.1.9-1.fc37.x86_64.rpm
/tmp/rpms/python3-pyzfs-2.1.9-1.fc37.noarch.rpm
/tmp/rpms/src
/tmp/rpms/src/zfs-2.1.9-1.fc37.src.rpm
/tmp/rpms/src/zfs-kmod-2.1.9-1.fc37.src.rpm
/tmp/rpms/zfs-2.1.9-1.fc37.x86_64.rpm
```

## Usage


Add this to your Containerfile to install all the typically intalled RPMs:

    COPY --from=ghcr.io/bsherman/ucore-kmods:latest /*.rpm /rpms
    RUN rpm-ostree install /rpms/*.rpm

Note: this install command filters out packages likely not needed unless doing development or debugging. But they are available in their respective sub-directories.

  
## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/bsherman/ucore-kmods