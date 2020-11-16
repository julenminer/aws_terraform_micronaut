FROM openjdk:14-alpine
COPY target/micronaut-s3-*.jar micronaut-s3.jar
EXPOSE 8080
CMD ["java", "-Dcom.sun.management.jmxremote", "-Xmx128m", "-jar", "micronaut-s3.jar"]