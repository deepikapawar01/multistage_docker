FROM alpine/git AS repo

WORKDIR /repo

RUN git clone https://github.com/spring-projects/spring-petclinic.git
 
FROM maven:3.9.9-eclipse-temurin-17 AS build

RUN adduser --disabled-password --gecos "" appusr

WORKDIR /home/appusr/app/spring-petclinic

COPY --from=repo /repo /home/appusr/app

RUN chown -R appusr:appusr /home/appusr/app

USER appusr

RUN mvn clean package
 
FROM eclipse-temurin:17-jdk

RUN useradd -m appusr

WORKDIR /app

COPY --from=build /home/appusr/app/spring-petclinic/target/*.jar app.jar

RUN chown -R appusr:appusr /app

USER appusr

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
