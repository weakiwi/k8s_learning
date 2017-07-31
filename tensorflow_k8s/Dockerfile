FROM tensorflow/tensorflow:latest

COPY entrypoint.sh /
COPY ipcheck /
RUN chmod 777 /ipcheck
RUN chmod 777 /entrypoint.sh

CMD ["/entrypoint.sh"]
