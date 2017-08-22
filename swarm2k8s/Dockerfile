FROM jazzdd/alpine-flask

#RUN pip install yaml
COPY app.py /app
COPY templates/ /app
COPY PyYAML-3.12/ /app
RUN /usr/bin/python /app/PyYAML-3.12/setup.py install
