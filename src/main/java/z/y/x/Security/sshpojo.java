package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;

/**
 * Author Anish
 * Demo @8gwifi.org
 */
public class sshpojo implements Serializable {
	
	private String publicKey;
	private String privateKey;
	private String algo;
	private String fingerprint;
	private int keySize;
	
	
	
	public String getPublicKey() {
		return publicKey;
	}



	public void setPublicKey(String publicKey) {
		this.publicKey = publicKey;
	}



	public String getPrivateKey() {
		return privateKey;
	}



	public void setPrivateKey(String privateKey) {
		this.privateKey = privateKey;
	}



	public String getAlgo() {
		return algo;
	}



	public void setAlgo(String algo) {
		this.algo = algo;
	}



	public String getFingerprint() {
		return fingerprint;
	}



	public void setFingerprint(String fingerprint) {
		this.fingerprint = fingerprint;
	}



	public int getKeySize() {
		return keySize;
	}



	public void setKeySize(int keySize) {
		this.keySize = keySize;
	}

	


	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((algo == null) ? 0 : algo.hashCode());
		result = prime * result + ((fingerprint == null) ? 0 : fingerprint.hashCode());
		result = prime * result + keySize;
		result = prime * result + ((privateKey == null) ? 0 : privateKey.hashCode());
		result = prime * result + ((publicKey == null) ? 0 : publicKey.hashCode());
		return result;
	}



	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		sshpojo other = (sshpojo) obj;
		if (algo == null) {
			if (other.algo != null)
				return false;
		} else if (!algo.equals(other.algo))
			return false;
		if (fingerprint == null) {
			if (other.fingerprint != null)
				return false;
		} else if (!fingerprint.equals(other.fingerprint))
			return false;
		if (keySize != other.keySize)
			return false;
		if (privateKey == null) {
			if (other.privateKey != null)
				return false;
		} else if (!privateKey.equals(other.privateKey))
			return false;
		if (publicKey == null) {
			if (other.publicKey != null)
				return false;
		} else if (!publicKey.equals(other.publicKey))
			return false;
		return true;
	}



	@Override
	public String toString() {
		Gson gson = new Gson();
        String json = gson.toJson(this, sshpojo.class);
		return json;
	}
	

}
