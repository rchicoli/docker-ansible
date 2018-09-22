FROM centos:centos7

ARG ANSIBLE_VERSION=2.6.4

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools python-pip \
           git vim curl && \
    yum clean all && rm -rf /var/cache/yum

RUN pip install ansible==$ANSIBLE_VERSION
