import pika

credentials = pika.PlainCredentials('admin', 'password')

connection = pika.BlockingConnection(pika.ConnectionParameters('192.168.2.216',30002,'/',credentials))
channel = connection.channel()

channel.queue_declare(queue='wzg')

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)


channel.basic_consume(callback,
                      queue='hello',
                      no_ack=True)


print(' [*] Waiting for messages. To exit press CTRL+C')

channel.start_consuming()
