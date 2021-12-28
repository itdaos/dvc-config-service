FROM openjdk:18-jdk-alpine
ENV APP_FILE config-1.0-SNAPSHOT.jar
ENV APP_HOME /app
ENV CONFIG_PATH src/main/resources/config
EXPOSE 8888
COPY target/$APP_FILE $APP_HOME/
COPY $CONFIG_PATH/* $APP_HOME/config/
WORKDIR $APP_HOME
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar $APP_FILE"]