# vim:set ft=dockerfile:
FROM gliderlabs/alpine:edge

MAINTAINER Andrius Kairiukstis <andrius@kairiukstis.com>

RUN apk --update add bash openssh \
&&  apk add autossh --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
&&  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# generate ssh keys
RUN ssh-keygen -f   /etc/ssh/ssh_host_rsa_key     -N '' -t rsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_dsa_key     -N '' -t dsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa   \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
&&  cp -a /etc/ssh  /etc/ssh.default

COPY ssh_config     /etc/ssh/ssh_config
COPY sshd_config    /etc/ssh/sshd_config

RUN chown root:root /etc/ssh/ssh_config  \
&&  chmod 0600      /etc/ssh/ssh_config  \
&&  chown root:root /etc/ssh/sshd_config \
&&  chmod 0600      /etc/ssh/sshd_config


# create restricred user 'sshuser'
RUN ln -s /bin/bash /bin/rbash         \
&&  adduser -D -s   /bin/rbash sshuser \
\
&&  mkdir -p        /root/.ssh /home/sshuser/.ssh \
&&  chmod 0700      /root/.ssh /home/sshuser/.ssh

COPY .bash_profile  /home/sshuser/

RUN chown -R sshuser:sshuser /home/sshuser \
\
&&  chown root:root /home/sshuser/.bash_profile \
&&  chmod 0444      /home/sshuser/.bash_profile
# or chattr from e2fsprogs-extra: https://pkgs.alpinelinux.org/contents?branch=edge&name=e2fsprogs-extra&arch=armhf&repo=main)
# chattr +i      /home/sshuser/.bash_profile


SHELL ["/bin/bash"]

EXPOSE 22

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]

