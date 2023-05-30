# ostree-zfs-kmods

<Build badge here>

## What is this?

A fork of [bsherman/ucore-kmods](https://github.com/bsherman/ucore-kmods); to provide zfs kernel modules for use in [Fedora-ostree-desktops](https://quay.io/organization/fedora-ostree-desktops) images.

## Features

This image currently contains:

- ZFS (including debug packages)

### NOTE: the ZFS kmods are not yet signed to enable secure boot


## Usage

Add this to your Containerfile to install all the typically intalled RPMs:

    COPY --from=ghcr.io/mitchejj/ostree-zfs-kmods:latest /*.rpm /rpms
    RUN rpm-ostree install /rpms/*.rpm

Note: this install command filters out packages likely not needed unless doing development or debugging. But they are available in their respective sub-directories.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/mitchejj/ostree-zfs-kmods

### Reading

* [kernel - Fedora Packages](https://packages.fedoraproject.org/pkgs/kernel/kernel/)
* [OpenZFS on Linux](https://zfsonlinux.org/)
* [Custom Packages — OpenZFS documentation](https://openzfs.github.io/openzfs-docs/Developer%20Resources/Custom%20Packages.html)

