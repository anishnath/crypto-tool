package z.y.x.Security;

import java.security.Security;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class GenKeyStore extends GenKeyPair{

	static {
		Security.addProvider(new BouncyCastleProvider());
	}
	
	public GenKeyStore(String algo, int bits) throws Exception {
		super(algo, bits);
		// TODO Auto-generated constructor stub
	}
	
	

}
