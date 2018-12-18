package z.y.x.Security;

import java.math.BigInteger;
import java.security.*;

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
		 
		 KeyPairGenerator alicekeyGen = KeyPairGenerator.getInstance("DH");
		 alicekeyGen.initialize(dhParams,new SecureRandom());
		 
		 KeyPairGenerator bobkeyGen = KeyPairGenerator.getInstance("DH");
		 bobkeyGen.initialize(dhParams,new SecureRandom());
		 
		 	// set up
	        KeyAgreement aliceKeyAgree = KeyAgreement.getInstance("DH");
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
	        KeyAgreement bobKeyAgree = KeyAgreement.getInstance("DH");
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
	        
	        MessageDigest	hash = MessageDigest.getInstance("SHA1");
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
		System.out.println(new DH().generateTwoWayDump(new BigInteger("93445990947cef561f52de0fa07a232b07ba78c6d1b3a09d1b838de4d3c51f843c307427b963b2060fb30d8088e5bc8459cf4201987e5d83c2a9c2b72cee53f7905c92c6425f9f97df71b8c09ea97e8435c30b57d6e84bb134af3aeaacf4047da02716c0b85c1b403dba306569aaaa6fb7b01861c4f692af24ad89f02408762380dbdd7186e36d59edf9d2abd93bfe8f04e4e20a214df66dabd02d1b15e6b943ad73a5695110286d6e3b4d35f8f08ece05728645bfb85d29ec561d6db16ac4bb5f58805eea1298b29161f74bac3ff9003dabfcc5fdc7604fb7bfdbf96e9c6c8ca7b357a74a94f62752a780a451bed793400b56a1a9414fa38458ed797896ca8c",16), new BigInteger("ab0eab856a13bdc2c35ae735b04b6424f7c8d33beae9f7d28ff58f84a845e727a2cb3d3fcf716ff839e65fbeaa4f9b38eddd3b87c03b1bf4e5dd86f211a7845d67d2a44a64b5126776fc5a210196020e6552930fbb5f98f5f23589d51dee3fbdb9e714989ad966465ee56e3551b216f0e15c257c0aeddbc1e6b394341a4c07a5412e22cda2c052d232ea68c9709d4e1fe359780a9842f7b30130a7bea563c31897e95cc7cff834ac46aa4d56a1f75b5437dd444d7be4e33c069c340020250c713d6219c5b62d252ad348220254ff77cd6ba54cdd0f37ec6d6cc9bd22ea6794b6237f6fb056edfd7132d4a1be3ddc7cfe6fe57b974d5a9d67ac7059cab02b2a7b",16)));
	}

}
