FROM openjdk:11

RUN mkdir /apps

COPY ./target/*.jar /apps/spring.jar

EXPOSE 8080

CMD ["java", "-jar", "/apps/spring.jar"]
