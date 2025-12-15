# Build stage
FROM public.ecr.aws/docker/library/maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml ./
# Go offline to cache dependencies
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM public.ecr.aws/docker/library/eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/ironlog-backend-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
