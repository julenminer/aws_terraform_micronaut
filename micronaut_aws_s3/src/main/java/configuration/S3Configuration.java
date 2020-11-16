package configuration;

import javax.annotation.Nonnull;

public interface S3Configuration {

    @Nonnull
    String getBucket();

    @Nonnull
    String getRegion();

    @Nonnull
    String getAccessKey();

    @Nonnull
    String getSecretKey();
}
