import pika
import time

credentials = pika.PlainCredentials('admin', 'password')

connection=pika.BlockingConnection(pika.ConnectionParameters('192.168.2.216',30002,'/',credentials))

channel = connection.channel()
channel.queue_declare(queue='hello')
a=1
while(1):
	channel.basic_publish(exchange='',
                  routing_key='hello',
                  body='Hello World!'+str(a))
	time.sleep(1)
	a=a+1

print("begin")
