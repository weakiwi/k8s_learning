FROM tensorflow/tensorflow:latest

COPY entrypoint.sh /
COPY ping.py /
RUN chmod 777 /ping.py
RUN chmod 777 /entrypoint.sh
RUN apt update
RUN apt install iputils-ping -y

CMD ["/entrypoint.sh"]
