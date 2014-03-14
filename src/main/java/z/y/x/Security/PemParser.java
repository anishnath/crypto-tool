package z.y.x.Security;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.KeyPair;
import java.security.PublicKey;
import java.security.Security;
import java.security.cert.X509Certificate;
import java.util.Enumeration;

import org.bouncycastle.asn1.cms.ContentInfo;
import org.bouncycastle.asn1.util.ASN1Dump;
import org.bouncycastle.jce.PKCS10CertificationRequest;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.jce.provider.JCERSAPrivateCrtKey;
import org.bouncycastle.jce.provider.JCERSAPublicKey;
import org.bouncycastle.jce.provider.JDKDSAPrivateKey;
import org.bouncycastle.jce.provider.X509CRLObject;
import org.bouncycastle.jce.provider.X509CertificateObject;
import org.bouncycastle.openssl.PEMReader;
import org.bouncycastle.openssl.PasswordFinder;

final public class PemParser {
	

	static {
		Security.addProvider(new BouncyCastleProvider());
	}
	
	


	public static void main(String[] args) throws Exception {
		
		
	}

	/**
	 * @return 
	 * @throws Exception 
	 */
	public  String parsePemFile(final String data,final String password) throws Exception {
		final StringBuilder builder = new StringBuilder();
		
		try {
			if(data==null || data.isEmpty())
			{
				throw new Exception("Input PEM Data is Missing");
			}
			byte[] content = data.getBytes();
			
			InputStream is = null;
			InputStreamReader isr = null;
			BufferedReader br = null;

			is = new ByteArrayInputStream(content);

			// create new input stream reader
			isr = new InputStreamReader(is);

			// create new buffered reader
			br = new BufferedReader(isr);

			PasswordFinder finder = new PasswordFinder() {
				@Override
				public char[] getPassword() {
					if(password==null || password.isEmpty())
					{
						return "".toCharArray();
					}
					return password.toCharArray();
				}
			};

			PEMReader pemReader = new PEMReader(br, finder);

			Object obj = pemReader.readObject();

			if(obj ==null)
			{
				throw new Exception("Invalid Input file");
			}

			System.out.println(obj.getClass());
			if (obj instanceof JDKDSAPrivateKey) {
				JDKDSAPrivateKey jdkdsaPrivateKey = (JDKDSAPrivateKey) obj;
				builder.append("The DSA" + jdkdsaPrivateKey);
			}
			if (obj instanceof org.bouncycastle.jce.provider.X509CertificateObject) {
				//System.out.println(obj);
				builder.append(obj);
				
			} 
			else if (obj instanceof org.bouncycastle.jce.PKCS10CertificationRequest) {
				builder.append(obj);
				PKCS10CertificationRequest pkcs10CertificationRequest = (PKCS10CertificationRequest) obj;
				builder.append(ASN1Dump.dumpAsString(pkcs10CertificationRequest
						.getCertificationRequestInfo()));
			} else if (obj instanceof org.bouncycastle.jce.provider.JCERSAPublicKey) {
				JCERSAPublicKey jcersaPublicKey = (JCERSAPublicKey) obj;
				builder.append("Algo " + jcersaPublicKey.getAlgorithm());
				builder.append("Format " + jcersaPublicKey.getFormat());
				builder.append(jcersaPublicKey);
			} else if (obj instanceof org.bouncycastle.asn1.cms.ContentInfo) {
				ContentInfo contentInfo = (ContentInfo) obj;
				builder.append(ASN1Dump.dumpAsString(contentInfo));
			}
			

			else if (obj instanceof org.bouncycastle.jce.provider.X509CRLObject) {
				X509CRLObject object = (X509CRLObject) obj;
				builder.append(object);
			} else {
				java.security.KeyPair kp = (KeyPair) obj;
				// builder.append(ASN1Dump.dumpAsString(kp));
				// kp.getPrivate().getEncoded();
				if (kp != null) {

					if (kp.getPrivate() instanceof org.bouncycastle.jce.provider.JCERSAPrivateCrtKey) {
						builder.append("-------BEGINS Private Key Information-----------");
						builder.append("\n");
						JCERSAPrivateCrtKey jcersaPrivateCrtKey = (JCERSAPrivateCrtKey) kp
								.getPrivate();
						builder.append("Algo "
								+ jcersaPrivateCrtKey.getAlgorithm());
						builder.append("Format "
								+ jcersaPrivateCrtKey.getFormat());

						builder.append(jcersaPrivateCrtKey.toString());
						builder.append("\n");
						builder.append("-------ENDS Private Key Information-----------");
						// return;
					} else {
						builder.append("-------BEGINS Private Key Information-----------");
						builder.append("\n");
						JDKDSAPrivateKey jdkdsaPrivateKey = (JDKDSAPrivateKey) kp
								.getPrivate();
						// builder.append(jdkdsaPrivateKey.getBagAttributeKeys());
						Enumeration e = jdkdsaPrivateKey.getBagAttributeKeys();
						while (e.hasMoreElements()) {
							String param = (String) e.nextElement();
							builder.append("Param " + param);
						}
						builder.append("Algo "
								+ jdkdsaPrivateKey.getAlgorithm());
						builder.append("Format " + jdkdsaPrivateKey.getFormat());
						builder.append("G "
								+ jdkdsaPrivateKey.getParams().getG());
						builder.append("P "
								+ jdkdsaPrivateKey.getParams().getP());
						builder.append("Q "
								+ jdkdsaPrivateKey.getParams().getQ());
						builder.append("X " + jdkdsaPrivateKey.getX());
						builder.append("\n");
						builder.append("-------ENDS Private Key Information-----------");
					}
				}

				builder.append("\n");
				builder.append("\n");

				if (kp != null) {
					if (kp.getPublic() instanceof PublicKey) {
						builder.append("\n");
						builder.append("-------BEGINS Public Key Information-----------");
						builder.append("\n");
						PublicKey publicKey = kp.getPublic();
						builder.append("Algo " + publicKey.getAlgorithm());
						builder.append("Format " + publicKey.getFormat());
						builder.append(publicKey);
						// builder.append("Format " + publicKey.getFormat());
						builder.append("\n");
						builder.append("-------ENDS Public Key Information-----------");
					}
				}
			}
		} catch (Exception e) {
			
			throw new Exception("Problem  " + e.getMessage()  + " Do check the Supplied Password or check the Supplied Input" );
		}
		
		return builder.toString();
	}

}