package service;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import configuration.S3Configuration;
import org.apache.commons.io.FileUtils;

import javax.inject.Singleton;
import java.io.File;
import java.io.IOException;

@Singleton
public class S3ServiceImpl implements S3Service{

    private AmazonS3 s3client;

    public static final String UPLOAD_FOLDER = "uploads/";

    private void authentication(S3Configuration configuration) {
        AWSCredentials credentials = new BasicAWSCredentials(
                configuration.getAccessKey(),
                configuration.getSecretKey()
        );
        s3client = AmazonS3ClientBuilder
                .standard()
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .withRegion(configuration.getRegion())
                .build();
    }

    @Override
    public void getObject(String fileNamePath, S3Configuration configuration){
        authentication(configuration);
        S3Object s3object = s3client.getObject(
                configuration.getBucket(),
                fileNamePath);
        S3ObjectInputStream inputStream = s3object.getObjectContent();
        try {
            FileUtils.copyInputStreamToFile(inputStream, new File(fileNamePath));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void putObject(String filePath, S3Configuration configuration) {
        authentication(configuration);
        try {
            s3client.putObject(
                    configuration.getBucket(),
                    UPLOAD_FOLDER + filePath,
                    new File(filePath)
            );
            System.out.println("The file " + filePath +  " has been uploaded");
        } catch (AmazonServiceException e) {
            System.err.println(e.getErrorMessage());
            return;
        }
    }
}
