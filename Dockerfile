# vim:set ft=dockerfile:
FROM andrius/alpine-lshell:latest

MAINTAINER Andrius Kairiukstis <andrius@kairiukstis.com>

RUN apk --update add \
      bash \
      openssh \
      autossh \
&&  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# cleanup motd
RUN echo "" > /etc/motd

# generate ssh keys
RUN ssh-keygen -f   /etc/ssh/ssh_host_rsa_key     -N '' -t rsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_dsa_key     -N '' -t dsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa   \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
&&  cp -a /etc/ssh  /etc/ssh.default

COPY ssh_config     /etc/ssh/ssh_config
COPY sshd_config    /etc/ssh/sshd_config

RUN chown root:root /etc/ssh  \
&&  chmod 0600      /etc/ssh/* \
&&  mkdir -p        /root/.ssh \
&&  chmod 0700      /root/.ssh

COPY lshell.conf    /etc/lshell.conf

EXPOSE 22

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ln -s /docker-entrypoint.sh /create-users

SHELL ["bash"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
