FROM alpine:3.12
MAINTAINER dduyphuc@gmail.com

ENV ANSIBLE_VERSION 2.9.0

# alpine 3.12 only support python2 or python3
# install python libs check here https://pkgs.alpinelinux.org/packages?name=py3*&branch=v3.12
# or using `pip3 install <package name>`
ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  sshpass \
  git \
  ca-certificates \
  python3 \
  py3-boto \
  py3-boto3 \
  py3-botocore \
  py3-dateutil \
  py3-httplib2 \
  py3-jinja2 \
  py3-paramiko \
  py3-pip \
  py3-yaml

# If installing ansible@testing
#RUN \
#	echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> #/etc/apk/repositories

RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python3-dev && \
    \
    echo "==> Upgrading apk and system..."  && \
    apk update && apk upgrade && \
    \
    echo "==> Adding Python runtime..."  && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    pip install --upgrade pip && \
    pip install python-keyczar docker-py && \
    \
    echo "==> Installing Ansible..."  && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    \
    echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

# ENV ANSIBLE_GATHERING smart
# ENV ANSIBLE_HOST_KEY_CHECKING false
# ENV ANSIBLE_RETRY_FILES_ENABLED false
# ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
# ENV ANSIBLE_SSH_PIPELINING True
# ENV PYTHONPATH /ansible/lib
# ENV PATH /ansible/bin:$PATH
# ENV ANSIBLE_LIBRARY /ansible/library

## ssh key filename to look for in /root/.ssh/
# ENV SSH_KEY_FILE_NAME rsa

# WORKDIR /ansible/playbooks

WORKDIR /ansible

COPY ansible.cfg /etc/ansible/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["bash"]
