# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged jar file into the container
COPY target/*.jar app.jar

# Specify the command to run your application
CMD ["java", "-jar", "app.jar"]
