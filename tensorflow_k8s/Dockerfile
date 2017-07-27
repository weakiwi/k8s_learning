FROM tensorflow/tensorflow:latest

COPY entrypoint.sh /
COPY ipcheck /
RUN chmod 777 /ipcheck
RUN chmod 777 /entrypoint.sh
RUN apt update
RUN apt install iputils-ping -y

CMD ["/entrypoint.sh"]
