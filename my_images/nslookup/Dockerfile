FROM busybox
COPY nslookup.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/sh -c", "/usr/local/bin/docker-entrypoint.sh"]
