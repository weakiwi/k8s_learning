FROM daocloud.io/java:7
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac -cp .:mongo-java-driver-3.4.2.jar test1.java 
CMD ["java", "-cp", ".:mongo-java-driver-3.4.2.jar", "test1"]
