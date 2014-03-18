package z.y.x.Security;

import java.math.BigInteger;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.SecureRandom;

import javax.crypto.KeyAgreement;
import javax.crypto.spec.DHParameterSpec;

import sun.misc.BASE64Encoder;
import z.y.x.u.HexUtils;


public class DH {
	
	static String generateTwoWayDump(BigInteger G, BigInteger P) throws Exception
	{
		StringBuilder builder = new StringBuilder();
		
		
		
		
		
		
		 
		// builder.append("DHParameterSpec  dhParams = new DHParameterSpec("+G+","+ P+");\n" );
		// builder.append("KeyPairGenerator keyGen = KeyPairGenerator.getInstance(\"DH\", \"BC\");\n");
		// builder.append("keyGen.initialize(dhParams,new SecureRandom());\n");
		// builder.append("KeyAgreement aKeyAgree = KeyAgreement.getInstance(\"DH\", \"BC\")\n");
		// builder.append("KeyPair      aPair = keyGen.generateKeyPair();\n");
		 
		// builder.append("DH Parameter");
		 //builder.append("\n");
		// builder.append("G="+G + " P=" + P);
		 //builder.append("\n");
		 
		 DHParameterSpec             dhParams = new DHParameterSpec(G, P);
		 KeyPairGenerator keyGen = KeyPairGenerator.getInstance("DH", "BC");
		 keyGen.initialize(dhParams,new SecureRandom());
		 
		 	// set up
	        KeyAgreement aKeyAgree = KeyAgreement.getInstance("DH", "BC");
	        KeyPair      aPair = keyGen.generateKeyPair();
		 
	        builder.append("--------BEGIN keyPairA---------\n");
	        toStringKeyPair(builder, aPair);
	        
	        builder.append("--------END keyPairA---------\n");
		 //new BASE64Encoder().encode(encodedprivkey)
	        
	        //builder.append("KeyAgreement bKeyAgree = KeyAgreement.getInstance(\"DH\", \"BC\")\n");
			//builder.append("KeyPair      bPair = keyGen.generateKeyPair();\n");
	        builder.append("\n");
	        builder.append("\n");
	        builder.append("--------BEGIN keyPairB---------\n");
	        KeyAgreement bKeyAgree = KeyAgreement.getInstance("DH", "BC");
	        KeyPair      bPair = keyGen.generateKeyPair();
	        toStringKeyPair(builder, bPair);
	        builder.append("--------End keyPairB---------\n");
	        
	        // two party agreement
	       // builder.append("Two party Agreement Starts\n");
	       // builder.append("aPair.getPrivate()\n");
	       // builder.append("bPair.getPrivate()\n");
	        aKeyAgree.init(aPair.getPrivate());
	        bKeyAgree.init(bPair.getPrivate());
	        
	      //  builder.append(" Key aKey =  aKeyAgree.doPhase(bPair.getPublic(), true);\n");
	       // builder.append(" Key bKey = aKeyAgree.doPhase(bPair.getPublic(), true);\n");
	       
	        Key aKey =   aKeyAgree.doPhase(bPair.getPublic(), true);
	        Key bKey = bKeyAgree.doPhase(aPair.getPublic(), true);
	        
	        
	      //  builder.append("Generating the KeyBytes\n");
	       // builder.append("  MessageDigest	hash = MessageDigest.getInstance(\"SHA1\", \"BC\");\n");
	       // builder.append("   byte[] aShared = hash.digest(aKeyAgree.generateSecret());\n");
	       // builder.append("    byte[] bShared = hash.digest(bKeyAgree.generateSecret());\n");
//	      generate the key bytes
	        MessageDigest	hash = MessageDigest.getInstance("SHA1", "BC");
	        byte[] aShared = hash.digest(aKeyAgree.generateSecret());
	        byte[] bShared = hash.digest(bKeyAgree.generateSecret());
	        
	        builder.append("\n");
	        builder.append("\n");
	        
	        //String encodeHex = HexUtils.encodeHex(aShared, ":");
	       // String encodeHex1 = HexUtils.encodeHex(bShared, ":");
	        builder.append("aSharedSecret  " + new BASE64Encoder().encode(aShared) +"\n");
	        builder.append("bSharedSecret  " +  new BASE64Encoder().encode(bShared) + "\n");
	        
	        return builder.toString();
		 
	}

	/**
	 * @param builder
	 * @param aPair
	 */
	private static void toStringKeyPair(StringBuilder builder, KeyPair aPair) {
		builder.append("----Public Key Information");
		builder.append("\n");
		builder.append("Algo = " +aPair.getPublic().getAlgorithm() + "\n");
		builder.append("Format = " + aPair.getPublic().getFormat()+"\n");
		builder.append("Encoded = " + new BASE64Encoder().encode(aPair.getPublic().getEncoded()) + "\n");
		

		builder.append("----Private Key Information");
		builder.append("\n");
		builder.append("Algo = " +aPair.getPrivate().getAlgorithm() + "\n");
		builder.append("Format = "+aPair.getPrivate().getFormat()+"\n");
		builder.append("Encoded = " +new BASE64Encoder().encode(aPair.getPrivate().getEncoded()) + "\n");
	}
	
	public static void main(String[] args) throws Exception {
		//System.out.println(new DH().generateTwoWayDump("2001", "3232"));
	}

}
