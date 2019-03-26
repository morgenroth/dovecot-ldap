FROM ubuntu:bionic
MAINTAINER Johannes Morgenroth <jm@m-network.de>

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# IMAPs port
EXPOSE 993
# IMAP port
EXPOSE 143
# POPs port
EXPOSE 995
# POP port
EXPOSE 110
# LMTP port
EXPOSE 24

VOLUME /var/mail
VOLUME /etc/ssl/localcerts
VOLUME /etc/dovecot

# Install dovecot
RUN apt-get update && apt-get install -y \
	openssl \
	dovecot-imapd \
	dovecot-lmtpd \
	dovecot-ldap \
	dovecot-sieve \
	dovecot-managesieved \
	dovecot-antispam \
	curl \
&& rm -rf /var/lib/apt/lists/*

# Add default conf
ADD default_conf /etc/dovecot

# add rspamd-pipe script
ADD rspamd-pipe /usr/local/bin/rspamd-pipe
RUN chmod +x /usr/local/bin/rspamd-pipe

# add to external group: ssl-cert (115)
RUN groupadd -g 115 ssl-cert-ex; usermod -a -G ssl-cert-ex dovecot

# Setup startup script
ADD entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
