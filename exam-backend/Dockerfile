# -------- Stage 1: Build --------
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy entire repo
COPY . .

# Go inside exam-backend folder
WORKDIR /app/exam-backend

RUN mvn clean package -DskipTests


# -------- Stage 2: Run --------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

COPY --from=build /app/exam-backend/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
