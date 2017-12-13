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
		 
		 builder.append("Suppose we have two people wishing to  communicate: Alice and Bob");
		 builder.append("\n");
		 builder.append("They do not want Eve :to know their message.");
		 builder.append("\n");
		 
		
		 DHParameterSpec             dhParams = new DHParameterSpec(G, P);
		 
		 KeyPairGenerator alicekeyGen = KeyPairGenerator.getInstance("DH", "BC");
		 alicekeyGen.initialize(dhParams,new SecureRandom());
		 
		 KeyPairGenerator bobkeyGen = KeyPairGenerator.getInstance("DH", "BC");
		 bobkeyGen.initialize(dhParams,new SecureRandom());
		 
		 	// set up
	        KeyAgreement aliceKeyAgree = KeyAgreement.getInstance("DH", "BC");
	        KeyPair      alicePair = alicekeyGen.generateKeyPair();

		    builder.append("\n");
	        builder.append("--------BEGIN ALICE KEYPAIR INFORMATION---------\n");
	        
	        toStringKeyPair(builder, alicePair);
	        
	        builder.append("--------END ALICE KEYPAIR INFORMATION---------\n");
		 //new BASE64Encoder().encode(encodedprivkey)
	        
	        //builder.append("KeyAgreement bKeyAgree = KeyAgreement.getInstance(\"DH\", \"BC\")\n");
			//builder.append("KeyPair      bPair = keyGen.generateKeyPair();\n");
	        builder.append("\n");
	        builder.append("\n");
	        builder.append("--------BEGIN BOB KEYPAIR INFORMATION---------\n");
	        KeyAgreement bobKeyAgree = KeyAgreement.getInstance("DH", "BC");
	        KeyPair      bobPair = bobkeyGen.generateKeyPair();
	        toStringKeyPair(builder, bobPair);
	        builder.append("--------End BOB KEYPAIR INFORMATION---------\n");
	        
	        // two party agreement
	       // builder.append("Two party Agreement Starts\n");
	       // builder.append("aPair.getPrivate()\n");
	       // builder.append("bPair.getPrivate()\n");
	        
	        aliceKeyAgree.init(alicePair.getPrivate());
	        Key aliceKey =   aliceKeyAgree.doPhase(bobPair.getPublic(), true);
	        
	        
	       
	        
	      //  builder.append(" Key aKey =  aKeyAgree.doPhase(bPair.getPublic(), true);\n");
	       // builder.append(" Key bKey = aKeyAgree.doPhase(bPair.getPublic(), true);\n");
	       
	       // Key aKey =   aliceKeyAgree.doPhase(bPair.getPublic(), true);
	        
	        bobKeyAgree.init(bobPair.getPrivate());
	        Key bKey = bobKeyAgree.doPhase(alicePair.getPublic(), true);
	        
	        
	      //  builder.append("Generating the KeyBytes\n");
	       // builder.append("  MessageDigest	hash = MessageDigest.getInstance(\"SHA1\", \"BC\");\n");
	       // builder.append("   byte[] aShared = hash.digest(aKeyAgree.generateSecret());\n");
	       // builder.append("    byte[] bShared = hash.digest(bKeyAgree.generateSecret());\n");
//	      generate the key bytes
	        
	        MessageDigest	hash = MessageDigest.getInstance("SHA1", "BC");
	        byte[] aliceSharedSecret = hash.digest(aliceKeyAgree.generateSecret());
	        byte[] bobSharedSecret = hash.digest(bobKeyAgree.generateSecret());
	        
	        builder.append("\n");
	        builder.append("\n");
	        
	        //String encodeHex = HexUtils.encodeHex(aShared, ":");
	       // String encodeHex1 = HexUtils.encodeHex(bShared, ":");
	        builder.append("aSharedSecret  " + new BASE64Encoder().encode(aliceSharedSecret) +"\n");
	        builder.append("bSharedSecret  " +  new BASE64Encoder().encode(bobSharedSecret) + "\n");
	        
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
		System.out.println(new DH().generateTwoWayDump(new BigInteger("1234",16), new BigInteger("43243",16)));
	}

}
