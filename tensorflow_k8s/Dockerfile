FROM tensorflow/tensorflow:latest

RUN apt update
RUN apt install shellinabox -y
COPY entrypoint.sh /
COPY ipcheck /
RUN chmod 777 /ipcheck
RUN chmod 777 /entrypoint.sh

CMD ["/entrypoint.sh"]
