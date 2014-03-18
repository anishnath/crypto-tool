package z.y.x.Security;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.Provider;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.X509Certificate;
import java.util.Iterator;
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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class CipherFunctionality extends HttpServlet  {
	
	private static final String METHOD_ENCRYPRDECRYPT = "CIPHERBLOCK";
	private static final String METHOD_CIPHERCIPHERCAPABLITY = "CIPHERCAPABLITY";
	private static final String METHOD_PEM_DECODER="PEM_DECODER";
	private static final String METHOD_X509_CERTIFICATECREATOR="X509_CERTIFICATECREATOR";
	private static final String METHOD_DH="METHOD_DH";
	static{
		Security.addProvider(new BouncyCastleProvider());	
	}
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// TODO Auto-generated method stub

		// Set response content type
		response.setContentType("text/html");

		// Actual logic goes here.
		PrintWriter out = response.getWriter();
		out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

	}

	
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		final String methodName = request.getParameter("methodName");
		PrintWriter out = response.getWriter();
		if (METHOD_ENCRYPRDECRYPT.equalsIgnoreCase(methodName)) {
			//secretkey
			//encryptorDecrypt
			 String secretkey = request.getParameter("secretkey");
			final String encryptorDecrypt = request.getParameter("encryptorDecrypt");
			final String plaintext = request.getParameter("plaintext");
			//plaintext
			//cipherparameter
			final String cipherparameter = request.getParameter("cipherparameter");
			String algo = getAlgo(cipherparameter);
			if(secretkey!=null && !secretkey.isEmpty())
			{
				if(secretkey.trim().length()<24)
				{
					if(  "DES".equals(algo)  && secretkey.length()<8)
					{
						out.println("<font size=\"2\" color=\"red\"> "+ algo +" key size must be length greater then 8 </font>");
						return;
					}
					if("DES".equals(algo)  && secretkey.length()>=8)
					{
						//DO Nthing
					}
					else{
						out.println("<font size=\"2\" color=\"red\">" + algo +" key size must be length greater then 24 </font>");
						return;
					}
					
				}
				if(plaintext!=null && !plaintext.isEmpty())
				{
					
					 SecretKey skey =null;
					if("DES".equals(algo))
					{
						 DESKeySpec keySpec;
						try {
							keySpec = new DESKeySpec(secretkey.getBytes());
							 SecretKeyFactory factory = SecretKeyFactory.getInstance("DES");
						        SecretKey key = factory.generateSecret(keySpec);
						        addHorizontalLine(out);	
								out.println("<font size=\"4\" color=\"blue\">["+ encryptorDecrypt + "] ["+ plaintext +"] using Algo [" +cipherparameter + "] </font><font size=\"5\" color=\"green\">" +enCryptDecrypt(plaintext, cipherparameter, encryptorDecrypt, key) +"</font>");
						} catch (Exception e) {
							out.println("<font size=\"2\" color=\"red\"> "+ e.getLocalizedMessage() +" </font>");
							return; 
						}
					       
					}
					else
					{
						secretkey = secretkey.trim();
						skey = new SecretKeySpec(secretkey.getBytes(), getAlgo(cipherparameter));
						addHorizontalLine(out);	
						out.println("<font size=\"4\" color=\"blue\">["+ encryptorDecrypt + "] ["+ plaintext +"] using Algo [" +cipherparameter + "] </font><font size=\"5\" color=\"green\">" +enCryptDecrypt(plaintext, cipherparameter, encryptorDecrypt, skey) +"</font>");
					}
					
				}
				
				
			}
			else{
				out.println("<font size=\"2\" color=\"red\"> Secret key is null or empty  </font>");
						
			}
		}
		
		//PROVIDER CAPABLITY
		if (METHOD_CIPHERCIPHERCAPABLITY.equalsIgnoreCase(methodName)) {
			
			final String provider = request.getParameter("cipherparameter");
			if(provider!=null && !provider.isEmpty())
			{
				if(!"NONE".equals(provider))
				{
					addHorizontalLine(out);
					out.print("<font size=\"3\" color=\"blue\">Capabilities of the provider  </font>" + addProviderCapablities(provider) );
				}
				else{
					addHorizontalLine(out);
				}
				
			}
			
			final String listalgo = request.getParameter("listalgo");
			if(listalgo!=null && !listalgo.isEmpty())
			{
				if(!"NONE".equals(listalgo))
				{
				addHorizontalLine(out);
				out.println("<font size=\"3\" color=\"blue\">List of Algorithms  </font>" + ListAlgorithms.addToListAlgoSet(listalgo));
				}
				else
				{
					addHorizontalLine(out);
				}
			}
		}
		
		//METHOD_PEM_DECODER
		if (METHOD_PEM_DECODER.equalsIgnoreCase(methodName)) {
			final String pem = request.getParameter("pem");
			 String certpassword = request.getParameter("certpassword");
			 
			 //Had a Default Password
			 if(certpassword==null)
			 {
				 certpassword="";
			 }
			 addHorizontalLine(out);
			 PemParser parser = new PemParser();
			 try {
				String message = parser.parsePemFile(pem, certpassword);
				out.println(message);
			} catch (Exception e) {
				out.println(e.getMessage());
			}
		}
		
		//X509_CERTIFICATECREATOR
		if (METHOD_X509_CERTIFICATECREATOR.equalsIgnoreCase(methodName)) {
			final String hostname =  request.getParameter("hostname");
			final String company =  request.getParameter("company");
			final String department =  request.getParameter("department");
			final String email =  request.getParameter("email");
			final String city =  request.getParameter("city");
			final String state =  request.getParameter("state");
			final String country =  request.getParameter("country");
			final int expiry = Integer.valueOf(request.getParameter("expiry"));
			
			final String format = request.getParameter("format");
			
			if(hostname==null || hostname.isEmpty())
			{
				//addHorizontalLine(out);
				out.println("Compnay Name is Required");
				return;
			}
			CertInfo certInfo = new CertInfo(hostname,company, department, email, city, state, country,expiry);
			//System.out.println(certInfo);
			final int bits =  Integer.valueOf(request.getParameter("bits")); 
			final int  version =  Integer.valueOf(request.getParameter("version")); 
			
			try {
				X509CertificateCreator certificateCreator = new X509CertificateCreator("RSA", version, bits, certInfo);
				X509Certificate x509Certificate = 	certificateCreator.generateCertificate();
				if("NONE".equals(format))
				{
					out.println(new BASE64Encoder().encode(x509Certificate.getEncoded()));
				}
				else{
					StringBuilder builder = new StringBuilder();
					builder.append("-----BEGIN CERTIFICATE-----");
					builder.append("\n");
					builder.append(new BASE64Encoder().encode(x509Certificate.getEncoded()));
					builder.append("\n");
					builder.append("-----END CERTIFICATE-----");
					out.println(builder.toString());
				}
			//	System.out.println(new BASE64Encoder().encode(x509Certificate.getEncoded()));
				
			} catch (SecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			//final String version = 
			//Department
			//Email
			//City
			//State
			//Country
			
		}
		
		//METHOD_DH
		if (METHOD_DH.equalsIgnoreCase(methodName)) {
			final String dhparamp =  request.getParameter("dhparamp");
			final String dhparamq =  request.getParameter("dhparamq");
			
			if(dhparamq ==null || dhparamq.trim().length()==0)
			{
				addHorizontalLine(out);
				out.println("DH Paramter cannot be null or empty " );
				return;
			}
			
			if(dhparamp ==null || dhparamp.trim().length()==0)
			{
				addHorizontalLine(out);
				out.println("DH Paramter cannot be null or empty " );
				return;
			}
			
			try
			{
				BigInteger G = 	new BigInteger(dhparamp,16);
				BigInteger P =new BigInteger(dhparamq,16);
				out.print( DH.generateTwoWayDump(G, P) );
			}catch(Exception ex )
			{
				addHorizontalLine(out);
				out.println(ex.getMessage() );
				return;
			}
			
			
		}
		
	}
	
	private static String addProviderCapablities(final String provide) {
		Provider	 provider = Security.getProvider(provide);
        StringBuilder builder = new StringBuilder();
       
        Iterator  it = provider.keySet().iterator();
       
        builder.append("<center><table  border=\"10\">"); 
        builder.append("<b>"+ provider.getName() + "</b>");
        while (it.hasNext())
        {
            String	entry = (String)it.next();
            
            // this indicates the entry refers to another entry
            
            if (entry.startsWith("Alg.Alias."))
            {
                entry = entry.substring("Alg.Alias.".length());
            }
            builder.append("<tr>");
            String  factoryClass = entry.substring(0, entry.indexOf('.'));
            String  name = entry.substring(factoryClass.length() + 1);
            builder.append("<td>");
            builder.append(factoryClass+" : ");
            builder.append("</td");
            
            builder.append("<td><font color=\"green\">");
            builder.append(name);
            builder.append("</font></td>");
            builder.append("</tr>");
           // System.out.println(factoryClass + ": " + name);
        }
        builder.append("</table>");
       return builder.toString();
	}
	
	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}


	public static String enCryptDecrypt(String inputText, String cipherparameter,
			String encryptOrDecrypt, Key key) {
		
		try {
			
		  
			byte []iv;
			
			/*
			 * The input to the encryption processes of the CBC, CFB, and OFB modes includes, in addition to 
			   the plaintext, a data block called the initialization vector (IV), denoted IV
			 */
			//java.security.InvalidAlgorithmParameterException: Parameters missing
			if("DESede/CBC/PKCS5Padding".equals(cipherparameter)
					|| "DES/CBC/NoPadding".equals(cipherparameter)
					|| "DES/CBC/PKCS5Padding".equals(cipherparameter)
					|| "DESede/CBC/NoPadding".equalsIgnoreCase(cipherparameter))
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
		    if("encrypt".equals(encryptOrDecrypt))
		    {
		    	byte b[] = enCrypt(inputText, cipherparameter, key,ivspec);
		    	return new BASE64Encoder().encode(b);
		    }
			
		    if("decrypt".equals(encryptOrDecrypt))
		    {
		    		
		      	byte[] data = new BASE64Decoder().decodeBuffer(inputText);
		     	return  deCrypt(data, cipherparameter, key,ivspec);
		    }
		    
		    if("Encrypt".equals(encryptOrDecrypt))
		    {
		     	byte b[] = enCrypt(inputText, cipherparameter, key,ivspec);
		     	deCrypt(inputText.getBytes(), cipherparameter, key,ivspec);
		    }
	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
		return "PROBLEM CANNOT PERFORM";
	}

	private static byte[] enCrypt(String inputText, String cipherparameter, Key key, IvParameterSpec ivspec)
			throws NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, UnsupportedEncodingException,
			IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
		
		//System.out.println("Encryting   " + inputText);
		
		/**Returns a Cipher object that implements the specified transformation.*/
		Cipher cipher = Cipher.getInstance(cipherparameter);
		byte b1[] ;
		
		 if("AES/CBC/NoPadding".equals(cipherparameter))
		    {
			 	//javax.crypto.IllegalBlockSizeException: Input length not multiple of 16 bytes
		    		b1 =inputText.getBytes();
		    		//System.out.println(inputText.getBytes().length);
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
		//System.out.println("Encrpted ==" + StringUtils.byteToHex(b));
		return b;

	}

	private static String deCrypt(byte inputText[], String cipherparameter, Key key, IvParameterSpec ivspec)
			throws NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, UnsupportedEncodingException,
			IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
		
		//System.out.println("Decrypting " +  StringUtils.byteToHex(inputText));
		
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
		return  new String(b);

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
		
		/*
		 * five confidentiality modes of operation for symmetric key block 
		   cipher algorithms
		 */
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
		//new CipherFunctionality().enCryptDecrypt("SomeText","DES/ECB/PKCS5Padding", "Encrypt",k);
		
		//User Defined Key
		//Note length Play Important Role Here
		//2b7e151628aed2a6abf7158809cf4f3c
		byte[] keyBytes = "2b7e151628aed2a6abf71589".getBytes();
		//System.out.println("2b7e151628aed2a6abf71589".length());
		
		/*There is no AESKeySpec Sun Only Provide DESKeySpec, DESedeKeySpec, PBEKeySpec*/
		//Using DESKeySpec
        DESKeySpec keySpec = new DESKeySpec(keyBytes);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("DES");
        SecretKey key = factory.generateSecret(keySpec);
      //  new CipherFunctionality().enCryptDecrypt("SomeText","DES/ECB/PKCS5Padding", "Encrypt",key);
        
		//Using DESedeKeySpec
        DESedeKeySpec deSedeKeySpec  = new  DESedeKeySpec(keyBytes);
        factory = SecretKeyFactory.getInstance("DESede");
        key = factory.generateSecret(deSedeKeySpec);
       // new CipherFunctionality().enCryptDecrypt("SomeText","DESede/CBC/PKCS5Padding", "Encrypt",key);
        
			
		 //The AES/CBC/PKCS5Padding
		 SecretKey skey = new SecretKeySpec(keyBytes, "AES");
		 String s =  new CipherFunctionality().enCryptDecrypt("SomeText","AES/CBC/PKCS5Padding", "encrypt",skey);
		 System.out.println(s);
		 //= new Hex().decode(s.getBytes());
		 s =  new CipherFunctionality().enCryptDecrypt(s,"AES/CBC/PKCS5Padding", "decrypt",skey);
		 System.out.println(s);
		 
		 
		 //
		 //The AES
		 skey = new SecretKeySpec(keyBytes, "AES");
		// new CipherFunctionality().enCryptDecrypt("SomeText","AES", "Encrypt",skey);
		 
		 //The DESede/CBC/PKCS5Padding
		 skey = new SecretKeySpec(keyBytes, "DESede");
		 //new CipherFunctionality().enCryptDecrypt("SomeText","DESede/CBC/PKCS5Padding", "Encrypt",skey);
		 
		 //The DESede/ECB/NoPadding
		 skey = new SecretKeySpec(keyBytes, "DESede");
		 //new CipherFunctionality().enCryptDecrypt("SomeText","DESede/ECB/NoPadding", "Encrypt",skey);
		 
		//AES/CBC/NoPadding
		 skey = new SecretKeySpec(keyBytes, "AES");
		 //new CipherFunctionality().enCryptDecrypt("SomeTextISNOTGREATWHYNOTALLCALLL","AES/CBC/NoPadding", "Encrypt",skey);
		 
	}

}
