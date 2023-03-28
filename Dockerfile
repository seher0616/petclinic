FROM openjdk:17.0.1-jdk
ENV spring_profiles_active mysql
ADD https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz dockerize.tar.gz
RUN tar -xzf dockerize.tar.gz
RUN chmod +x dockerize
RUN mkdir /app
COPY ./target/spring-petclinic-3.0.0-SNAPSHOT.jar /app/app.jar
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.jar"]