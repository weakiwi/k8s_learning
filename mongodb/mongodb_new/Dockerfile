FROM daocloud.io/daocloud/mongo-ha
RUN sed -i "s#mongos0:27017#192.168.1.181:30088#g" /entrypoint.sh
RUN sed -i "s#mongos1:27017#192.168.1.73:30099#g" /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
