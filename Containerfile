ARG BASE_VERSION="${BASE_VERSION:-38}"
ARG ZFS_VERSION="${ZFS_VERSION:-2.1.13}"
ARG ZFS_VERSION=2.1.13

FROM quay.io/fedora-ostree-desktops/base:${BASE_VERSION} as builder


ARG BASE_VERSION="${BASE_VERSION}"
ARG ZFS_VERSION="${ZFS_VERSION}"
# ARG ZFS_VERSION=2.1.13
WORKDIR /tmp

#We can't use the `uname -r` as it will pick up the host kernel version
RUN rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}' > /kernel-version.txt

# # Using https://openzfs.github.io/openzfs-docs/Developer%20Resources/Custom%20Packages.html
# FROM registry.fedoraproject.org/fedora:${BASE_VERSION} as builder
# ARG ZFS_VERSION

RUN mkdir -p /var/lib/alternatives


# COPY --from=kernel-query /kernel-version.txt /kernel-version.txt

# WORKDIR /etc/yum.repos.d
# RUN BUILDER_VERSION=$(grep VERSION_ID /etc/os-release | cut -f2 -d=) \
#     && curl -L -O https://src.fedoraproject.org/rpms/fedora-repos/raw/f${BUILDER_VERSION}/f/fedora-updates-archive.repo \
#     && sed -i 's/enabled=AUTO_VALUE/enabled=true/' fedora-updates-archive.repo
RUN rpm-ostree install -y jq dkms gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel \
    libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel \
    kernel-$(cat /kernel-version.txt) kernel-modules-$(cat /kernel-version.txt) kernel-devel-$(cat /kernel-version.txt) \
    python3 python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel

RUN echo "getting zfs-${ZFS_VERSION}.tar.gz" && \ 
    # curl -L -O https://github.com/openzfs/zfs/releases/download/zfs-${ZFS_VERSION}/zfs-${ZFS_VERSION}.tar.gz \
    # && tar xzf zfs-${ZFS_VERSION}.tar.gz
      curl -L -O https://github.com/openzfs/zfs/releases/download/zfs-2.1.13/zfs-2.1.13.tar.gz \
      && tar xzf zfs-2.1.13.tar.gz

WORKDIR /tmp/zfs-${ZFS_VERSION}

RUN ./configure \
        -with-linux=/usr/src/kernels/$(cat /kernel-version.txt)/ \
        -with-linux-obj=/usr/src/kernels/$(cat /kernel-version.txt)/ \
    && make -j 1 rpm-utils rpm-kmod \
    || (cat config.log && exit 1)

# sort into directories for easier install later
RUN mkdir -p /tmp/rpms/{debug,devel,other,src} \
    && mv *src.rpm /tmp/rpms/src/ \
    && mv *devel*.rpm /tmp/rpms/devel/ \
    && mv *debug*.rpm /tmp/rpms/debug/ \
    && mv zfs-dracut*.rpm /tmp/rpms/other/ \
    && mv zfs-test*.rpm /tmp/rpms/other/ \
    && mv *.rpm /tmp/rpms/
RUN find /tmp/rpms | sort


FROM scratch

# Copy build RPMs
COPY --from=builder /tmp/rpms/ /
