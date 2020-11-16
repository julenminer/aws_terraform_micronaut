package service;

import configuration.S3Configuration;

public interface S3Service {
    void getObject(String fileNamePath, S3Configuration configuration);

    void putObject(String filePath, S3Configuration configuration);
}
