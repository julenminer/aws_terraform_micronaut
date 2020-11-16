package controller;

import configuration.S3Configuration;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import service.S3Service;

import javax.inject.Inject;

@Controller("/s3")
public class S3Controller {

    @Inject
    S3Service client;

    @Inject
    S3Configuration configuration;

    @Get("/download/{name}")
    String download(String name) {
        client.getObject(name,configuration);
        return "File downloaded --> " + name;
    }

    @Get("/upload/{name}")
    String upload(String name) {
        client.putObject(name, configuration);
        return "File uploadaded --> " + name;
    }
}
