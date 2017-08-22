FROM jazzdd/alpine-flask

#RUN pip install yaml
COPY app.py /app
ADD templates/ /app
ADD PyYAML-3.12.tar.gz /app
RUN cd /app/PyYAML-3.12
RUN python setup.py install
