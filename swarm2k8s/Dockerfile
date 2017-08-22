FROM jazzdd/alpine-flask

#RUN pip install yaml
COPY app.py /app
ADD templates/ /app
ADD PyYAML-3.12.tar.gz /app
RUN /usr/bin/python /app/PyYAML-3.12/setup.py install
