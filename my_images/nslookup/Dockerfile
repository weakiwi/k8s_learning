FROM busybox
COPY nslookup.sh ~/docker-entrypoint.sh
RUN chmod +x ~/docker-entrypoint.sh
ENTRYPOINT ["~/entrypoint.sh"]

EXPOSE 32637:30004
