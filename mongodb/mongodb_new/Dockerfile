FROM daocloud.io/library/mongo:3.2
COPY entrypoint.sh portcheck /
RUN chmod +x /portcheck
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
