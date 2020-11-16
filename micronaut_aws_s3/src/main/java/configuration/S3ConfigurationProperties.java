package configuration;

import io.micronaut.context.annotation.Property;

import javax.annotation.Nonnull;
import javax.inject.Singleton;

@Singleton
public class S3ConfigurationProperties implements S3Configuration {

    @Property(name="aws.s3.accessKey")
    private String accessKey;

    @Property(name="aws.s3.secretKey")
    private String secretKey;

    @Property(name="aws.s3.region")
    private String region;

    @Property(name="aws.s3.bucket")
    private String bucket;

    @Nonnull
    @Override
    public String getAccessKey() {
        return accessKey;
    }

    @Nonnull
    @Override
    public String getSecretKey() {
        return secretKey;
    }

    @Nonnull
    @Override
    public String getRegion() {
        return region;
    }

    @Nonnull
    @Override
    public String getBucket() {
        return bucket;
    }
}
