FROM tensorflow/tensorflow:latest

COPY entrypoint.sh /
COPY ping.py /
RUN chmod 777 /ping.py
RUN chmod 777 /entrypoint.sh

CMD ["/entrypoint.sh"]
