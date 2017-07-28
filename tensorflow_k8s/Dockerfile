FROM daocloud.io/daocloud/tensorflow-cluster

COPY entrypoint.sh /
COPY ipcheck /
RUN chmod 777 /ipcheck
RUN chmod 777 /entrypoint.sh

CMD ["/entrypoint.sh"]
