FROM tensorflow/tensorflow:latest

COPY entrypoint.sh /
COPY portcheck /
RUN chmod 777 /portcheck
RUN chmod 777 /entrypoint.sh

CMD ["/entrypoint.sh"]
