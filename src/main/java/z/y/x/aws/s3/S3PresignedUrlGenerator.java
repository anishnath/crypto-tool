package z.y.x.aws.s3;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;
import software.amazon.awssdk.services.s3.presigner.model.PresignedGetObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;

/**
 * 
 * @author anish
 *
 */

public class S3PresignedUrlGenerator {

	public static void main(String[] args) {
		if (args.length != 2) {
			System.err.println("Usage: java S3PresignedUrlGenerator <bucketName> <objectKey>");
			System.exit(1);
		}

		S3PresignedUrlGenerator generator = new S3PresignedUrlGenerator();

		String bucketName = args[0];
		String objectKey = "asd";

		generator.isObjectExist(bucketName, objectKey);

		// Set your AWS credentials and region
		S3Client s3Client = S3Client.builder().region(Region.US_EAST_1) // Change to your desired region
				.credentialsProvider(DefaultCredentialsProvider.create()).build();

		// Set the expiration time for the pre-signed URL
		Duration expiration = Duration.ofMinutes(5); // Adjust as needed

		try {
			Map<String, String> metaMap = new HashMap<>();
//			metaMap.put("Name", "anish");
			// metaMap.put("x-amz-meta-2", "3");
			URL preSignedUrl = generator.createPresignedUrl("f81821f2",
					"PDF340131535339926916620112023172437723189.pdf", "application/pdf", metaMap);
			System.out.println("Generated Pre-signed URL: " + preSignedUrl);
			generator.useHttpUrlConnectionToPutString(preSignedUrl);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void useHttpUrlConnectionToPutString(URL presignedUrl) {
		try {
			// Create the connection and use it to upload the new object by using the
			// presigned URL.
			HttpURLConnection connection = (HttpURLConnection) presignedUrl.openConnection();
			connection.setDoOutput(true);
			connection.setRequestProperty("Content-Type", "application/pdf");
			connection.setRequestMethod("PUT");
			OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
			out.write("This text was uploaded as an object by using a presigned URL.");
			out.close();

			connection.getResponseCode();

		} catch (S3Exception | IOException e) {
			e.getStackTrace();
		}
	}

	public URL createPresignedUrl(String bucketName, String keyName, String contentType, Map<String, String> metadata) {
		try (S3Presigner presigner = S3Presigner.create()) {

			PutObjectRequest objectRequest = PutObjectRequest.builder().bucket(bucketName).key(keyName)
					.contentType(contentType).metadata(metadata).build();

			PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
					.signatureDuration(Duration.ofMinutes(5)) // The URL will expire in 10 minutes.
					.putObjectRequest(objectRequest).build();

			PresignedPutObjectRequest presignedRequest = presigner.presignPutObject(presignRequest);
			return presignedRequest.url();
		}
	}

	public String getPresignedUrl(String bucketName, String keyName) {

		try (S3Presigner presigner = S3Presigner.create()) {
			GetObjectRequest getObjectRequest = GetObjectRequest.builder().bucket(bucketName).key(keyName).build();

			GetObjectPresignRequest getObjectPresignRequest = GetObjectPresignRequest.builder()
					.signatureDuration(Duration.ofMinutes(5)).getObjectRequest(getObjectRequest).build();

			PresignedGetObjectRequest presignedGetObjectRequest = presigner.presignGetObject(getObjectPresignRequest);
			String theUrl = presignedGetObjectRequest.url().toString();
			return theUrl;

		}
	}

	public boolean isObjectExist(String bucketName, String keyName) {

		try {
			S3Client s3Client = S3Client.builder().region(Region.US_EAST_1) // Change to your desired region
					.credentialsProvider(DefaultCredentialsProvider.create()).build();
			HeadObjectRequest objectRequest = HeadObjectRequest.builder().key(keyName).bucket(bucketName).build();

			HeadObjectResponse objectHead = s3Client.headObject(objectRequest);
			String type = objectHead.contentType();
			s3Client.close();
			return true;

		} catch (Exception e) {
			return false;
		}

	}
}
