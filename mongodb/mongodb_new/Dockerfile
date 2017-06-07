FROM daocloud.io/daocloud/mongo-ha
RUN sed -i 's#mongop0:27017#${MONGOP0_WITH_PORT}#g' /entrypoint.sh
RUN sed -i 's#mongos0:27017#${MONGOS0_WITH_PORT}#g' /entrypoint.sh
RUN sed -i 's#mongos1:27017#${MONGOS1_WITH_PORT}#g' /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
