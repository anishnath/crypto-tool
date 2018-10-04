package z.y.x.Security;

import java.security.AlgorithmParameters;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Security;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.EncryptedPrivateKeyInfo;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;



import sun.misc.BASE64Encoder;

public class GenKeyPair {
	
	private String algo="RSA";
	private int bits=2048;
	private KeyPair keyPair;

	public GenKeyPair(String algo, int bits) throws Exception {
		super();
		this.algo = algo;
		this.bits = bits;
		generateRSAKeyPair();
		
	}





	public void generateRSAKeyPair()
			throws Exception {
		KeyPairGenerator kpGen = KeyPairGenerator.getInstance(algo, "BC");

		kpGen.initialize(bits, new SecureRandom());

		this.keyPair= kpGen.generateKeyPair();
	}

	public PublicKey getPublicKey() throws Exception {
		if (keyPair != null) {
			return keyPair.getPublic();
		}
		throw new Exception("Public Key is Null or Empty");
	}
	
	public PrivateKey getPrivateKey() throws Exception {
		if (keyPair != null) {
			return keyPair.getPrivate();
		}
		throw new Exception("PrivateKey  is Null or Empty");
	}
	
	public KeyPair getKeyPair()
	{
		return this.keyPair;
	}
	
	

	public static void main(String[] args) {
		try {
			GenKeyPair keyPair=	 new GenKeyPair("RSA", 2048);
			keyPair.generateRSAKeyPair();

			//keyPair.get;
			// We must use a PasswordBasedEncryption algorithm in order to encrypt the private key, you may use any common algorithm supported by openssl, you can check them in the openssl documentation http://www.openssl.org/docs/apps/pkcs8.html
			String MYPBEALG = "PBEWithSHA1AndDESede";
			String password = "pleaseChangeit!";
			
			byte[] encodedprivkey = keyPair.getPrivateKey().getEncoded();
			
			//System.out.println(new BASE64Encoder().encode(encodedprivkey));
			
			int count = 20;// hash iteration count
			Random random = new Random();
			byte[] salt = new byte[8];
			random.nextBytes(salt);
			
			PBEParameterSpec parameterSpec = new PBEParameterSpec(salt, count);
			PBEKeySpec pbeKeySpec = new PBEKeySpec(password.toCharArray());
			SecretKeyFactory keyFac = SecretKeyFactory.getInstance(MYPBEALG);
			SecretKey pbeKey = keyFac.generateSecret(pbeKeySpec);
			
			Cipher pbeCipher = Cipher.getInstance(MYPBEALG);
			pbeCipher.init(Cipher.ENCRYPT_MODE, pbeKey, parameterSpec);
			
			// Encrypt the encoded Private Key with the PBE key
			byte[] ciphertext = pbeCipher.doFinal(encodedprivkey);
			
			// Now construct  PKCS #8 EncryptedPrivateKeyInfo object
			AlgorithmParameters algparms = AlgorithmParameters.getInstance(MYPBEALG);
			algparms.init(parameterSpec);
			EncryptedPrivateKeyInfo encinfo = new EncryptedPrivateKeyInfo(algparms, ciphertext);

			// and here we have it! a DER encoded PKCS#8 encrypted key!
			byte[] encryptedPkcs8 = encinfo.getEncoded();
			System.out.println(encinfo.getAlgName());
		 //	System.out.println(new BASE64Encoder().encode(encryptedPkcs8));
			

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
