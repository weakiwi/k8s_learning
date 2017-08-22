FROM jazzdd/alpine-flask

#RUN pip install yaml
RUN mkdir -p /app
COPY convert_template.py /app
COPY templates/ /app

WORKDIR /app

CMD ["python", "/app/convert_template.py"]
