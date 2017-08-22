FROM jazzdd/alpine-flask

#RUN pip install yaml
COPY app.py /app
ADD templates.tar.gz /app
ADD PyYAML-3.12.tar.gz /app
WORKDIR /app/PyYAML-3.12
RUN python setup.py install
RUN rm -f /app/PyYAML-3.12
WORKDIR /app
