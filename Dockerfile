# Build the application with Maven and keep only the runnable JAR in the final image.
FROM eclipse-temurin:17-jdk AS build
WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw -B dependency:go-offline

COPY src/ src/
RUN ./mvnw -B -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
RUN useradd --system --uid 10001 petclinic
COPY --from=build /workspace/target/spring-petclinic-*.jar /app/petclinic.jar
USER 10001
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/petclinic.jar"]
