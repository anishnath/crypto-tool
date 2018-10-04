package z.y.x.Security;

import java.math.BigInteger;
import java.security.cert.X509Certificate;
import java.util.Date;

import javax.security.auth.x500.X500Principal;



// Obsoleted Class
public class X509CertificateCreator { //extends GenKeyPair {

//	private int version = 3; // Default
//	private CertInfo certInfo;
//
//	public X509CertificateCreator(final String alg,int version, int bi,CertInfo certIn) throws Exception {
//		super(alg,bi);
//		this.version = version;
//		this.certInfo=certIn;
//
//	}
//
//	public X509Certificate generateCertificate() throws SecurityException, Exception
//	{
//
//		if(this.version==3)
//		{
//			return generateV3Certificate();
//		}
//
//		return generateV1Certificate();
//
//	}
//
//	private  X509Certificate generateV3Certificate()
//			throws SecurityException, Exception {
//
//
//		// generate the certificate
//		X509V3CertificateGenerator certGen = new X509V3CertificateGenerator();
//
//		certGen.setSerialNumber(BigInteger.valueOf(System.currentTimeMillis()));
//		certGen.setIssuerDN(new X500Principal(this.certInfo.toString()));
//
//		certGen.setNotBefore(new Date(System.currentTimeMillis() - 50000));
//		certGen.setNotAfter(new Date(System.currentTimeMillis() + certInfo.getExpiry()));
//		certGen.setSubjectDN(new X500Principal(this.certInfo.toString()));
//		certGen.setPublicKey(getPublicKey());
//		certGen.setSignatureAlgorithm("SHA256WithRSAEncryption");
//
//		certGen.addExtension(X509Extensions.BasicConstraints, true,
//				new BasicConstraints(false));
//
//		certGen.addExtension(X509Extensions.KeyUsage, true, new KeyUsage(
//				KeyUsage.digitalSignature | KeyUsage.keyEncipherment));
//
//		certGen.addExtension(X509Extensions.ExtendedKeyUsage, true,
//				new ExtendedKeyUsage(KeyPurposeId.id_kp_serverAuth));
//
//		certGen.addExtension(X509Extensions.SubjectAlternativeName, false,
//				new GeneralNames(new GeneralName(GeneralName.rfc822Name,
//						"test@test.test")));
//
//		return certGen.generateX509Certificate(getPrivateKey(), "BC");
//	}
//
//	private  X509Certificate generateV1Certificate()
//			throws SecurityException, Exception {
//		// generate the certificate
//		X509V1CertificateGenerator certGen = new X509V1CertificateGenerator();
//
//		certGen.setSerialNumber(BigInteger.valueOf(System.currentTimeMillis()));
//		certGen.setIssuerDN(new X500Principal(this.certInfo.toString()));
//		certGen.setNotBefore(new Date(System.currentTimeMillis() - 50000));
//		certGen.setNotAfter(new Date(System.currentTimeMillis() + certInfo.getExpiry()));
//		certGen.setSubjectDN(new X500Principal(this.certInfo.toString()));
//		certGen.setPublicKey(getPublicKey());
//		certGen.setSignatureAlgorithm("SHA256WithRSAEncryption");
//
//		return certGen.generateX509Certificate(getPrivateKey(), "BC");
//	}

}


