package z.y.x.Security;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.StringTokenizer;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import z.y.x.u.StringUtils;

public class CipherFunctionality  {


	public void enCryptDecrypt(String inputText, String cipherparameter,
			String encryptOrDecrypt, Key key) {
		
		try {
			System.out.println("Recieved Text = " + inputText
					+ " cipherparameter =" + cipherparameter
					+ " encryptOrDecrypt = " + encryptOrDecrypt
					+ "Key = " + key.getAlgorithm());
			final String getAlgo = getAlgo(cipherparameter);
			System.out.println("The Algo " + getAlgo);
			
			  
			byte []iv;
			
			/*
			 * The input to the encryption processes of the CBC, CFB, and OFB modes includes, in addition to 
			   the plaintext, a data block called the initialization vector (IV), denoted IV
			 */
			//java.security.InvalidAlgorithmParameterException: Parameters missing
			if("DESede/CBC/PKCS5Padding".equals(cipherparameter))
			{
				// The INitialVector Must Be 8 bit
				iv = new byte[]{0, 0, 0, 0, 0, 0, 0, 0};
			}
			else {
				 //The InitialVector Must Be 16 bit
				 iv = new byte[]{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
			}
			//The InitialVector It's Not Valid for all
		    IvParameterSpec ivspec = new IvParameterSpec(iv);
			byte b[] = enCrypt(inputText, cipherparameter, key,ivspec);

			deCrypt(b, cipherparameter, key,ivspec);


			System.out.println("==============================");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private byte[] enCrypt(String inputText, String cipherparameter, Key key, IvParameterSpec ivspec)
			throws NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, UnsupportedEncodingException,
			IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
		
		/**Returns a Cipher object that implements the specified transformation.*/
		Cipher cipher = Cipher.getInstance(cipherparameter);
		byte b1[] ;
		
		 if("AES/CBC/NoPadding".equals(cipherparameter))
		    {
			 	//javax.crypto.IllegalBlockSizeException: Input length not multiple of 16 bytes
		    		b1 =inputText.getBytes();
		    		System.out.println(inputText.getBytes().length);
		    }	 
		 else {
			 b1 = inputText.getBytes();
		 }
		 
		if(cipherparameter.contains("CBC"))
		{
			/**Initializes this cipher with a key.*/
			cipher.init(Cipher.ENCRYPT_MODE, key,ivspec);
		}
		else{
			/**Initializes this cipher with a key.*/
			cipher.init(Cipher.ENCRYPT_MODE, key);
		}
		
		/** Encrypts or decrypts data in a single-part operation, or finishes a multiple-part operation. */
		byte[] b = cipher.doFinal(b1);
		System.out.println("Encrpted ==" + StringUtils.byteToHex(b));
		return b;

	}

	private void deCrypt(byte inputText[], String cipherparameter, Key key, IvParameterSpec ivspec)
			throws NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, UnsupportedEncodingException,
			IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
		
		System.out.println("Decrypting " +  StringUtils.byteToHex(inputText));
		
		/**Returns a Cipher object that implements the specified transformation.*/
		Cipher cipher = Cipher.getInstance(cipherparameter);
		
		if(cipherparameter.contains("CBC"))
		{
			cipher.init(Cipher.DECRYPT_MODE, key,ivspec);
		}
		else{
			cipher.init(Cipher.DECRYPT_MODE, key);
		}

		byte[] b = cipher.doFinal(inputText);
		System.out.println("Decrypted   " + new String(b));

	}

	private static String getAlgo(final String transformation) {
		String algo = "DES";
		if (transformation == null || transformation.isEmpty()) {
			// Default
			return algo;
		}
		StringTokenizer stringTokenizer = new StringTokenizer(transformation,
				"/");
		while (stringTokenizer.hasMoreTokens()) {
			algo = stringTokenizer.nextToken();
			break;
		}
		return algo;

	}

	public static void main(String[] args) throws Exception {
		
		//The Electronic Codebook Mode (ECB) -->PADDING (the total 
											//	(number of bits in the plaintext must be a positive 
											//   multiple of the block ) 
		//The Cipher Block Chaining Mode (CBC) -->PADDING
		//The Cipher Feedback Mode (CFB) -->>PADDING 
		//The Output Feedback Mode (OFB)
		//The Counter Mode (CT)
		
		//A transformation is of the form:
		//	"algorithm/mode/padding" or
		//	"algorithm"
		//e.g  Cipher c = Cipher.getInstance("DES/CBC/PKCS5Padding");
		//e.g  Cipher c = Cipher.getInstance("AES");
		
		/*
		 * For the ECB and CBC modes, the total number of bits in the plaintext must be a multiple of the block size
		 */
		
		/*
		 * For the CFB mode, the total number of bits in the plaintext must be a multiple of a parameter, denoted s
		 */
		
		/*
		 * For the OFB and CTR modes, the plaintext need not be a multiple of the block size
		 */
		
		//Random Generated SharedSecret
		Key k=null;
		KeyGenerator generator;
		generator = KeyGenerator.getInstance(getAlgo("DES/ECB/PKCS5Padding"));
		generator.init(new SecureRandom());
		k = generator.generateKey();
		new CipherFunctionality().enCryptDecrypt("SomeText","DES/ECB/PKCS5Padding", "Encrypt",k);
		
		//User Defined Key
		//Note length Play Important Role Here
		//2b7e151628aed2a6abf7158809cf4f3c
		byte[] keyBytes = "2b7e151628aed2a6abf71588".getBytes("UTF-8");
		System.out.println(keyBytes.length);
		
		/*There is no AESKeySpec Sun Only Provide DESKeySpec, DESedeKeySpec, PBEKeySpec*/
		//Using DESKeySpec
        DESKeySpec keySpec = new DESKeySpec(keyBytes);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("DES");
        SecretKey key = factory.generateSecret(keySpec);
        new CipherFunctionality().enCryptDecrypt("SomeText","DES/ECB/PKCS5Padding", "Encrypt",key);
        
		//Using DESedeKeySpec
        DESedeKeySpec deSedeKeySpec  = new  DESedeKeySpec(keyBytes);
        factory = SecretKeyFactory.getInstance("DESede");
        key = factory.generateSecret(deSedeKeySpec);
        new CipherFunctionality().enCryptDecrypt("SomeText","DESede/CBC/PKCS5Padding", "Encrypt",key);
        
			
		 //The AES/CBC/PKCS5Padding
		 SecretKey skey = new SecretKeySpec(keyBytes, "AES");
		 new CipherFunctionality().enCryptDecrypt("SomeText","AES/CBC/PKCS5Padding", "Encrypt",skey);
		 
		 //
		 //The AES
		 skey = new SecretKeySpec(keyBytes, "AES");
		 new CipherFunctionality().enCryptDecrypt("SomeText","AES", "Encrypt",skey);
		 
		 //The DESede/CBC/PKCS5Padding
		 skey = new SecretKeySpec(keyBytes, "DESede");
		 new CipherFunctionality().enCryptDecrypt("SomeText","DESede/CBC/PKCS5Padding", "Encrypt",skey);
		 
		 //The DESede/ECB/NoPadding
		 skey = new SecretKeySpec(keyBytes, "DESede");
		 new CipherFunctionality().enCryptDecrypt("SomeText","DESede/ECB/NoPadding", "Encrypt",skey);
		 
		//AES/CBC/NoPadding
		 skey = new SecretKeySpec(keyBytes, "AES");
		 new CipherFunctionality().enCryptDecrypt("SomeTextISNOTGREATWHYNOTALLCALLM","AES/CBC/NoPadding", "Encrypt",skey);
		 
	}

}
