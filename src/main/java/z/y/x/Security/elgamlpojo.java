package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;

public class elgamlpojo implements Serializable {

	private String publicKey;
	private String privateKey;
	private int keySize;
	private String message1;
	private String message2;

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

	public int getKeySize() {
		return keySize;
	}

	public void setKeySize(int keySize) {
		this.keySize = keySize;
	}

	public String getMessage1() {
		return message1;
	}

	public void setMessage1(String message1) {
		this.message1 = message1;
	}

	public String getMessage2() {
		return message2;
	}

	public void setMessage2(String message2) {
		this.message2 = message2;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + keySize;
		result = prime * result + ((message1 == null) ? 0 : message1.hashCode());
		result = prime * result + ((message2 == null) ? 0 : message2.hashCode());
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
		elgamlpojo other = (elgamlpojo) obj;
		if (keySize != other.keySize)
			return false;
		if (message1 == null) {
			if (other.message1 != null)
				return false;
		} else if (!message1.equals(other.message1))
			return false;
		if (message2 == null) {
			if (other.message2 != null)
				return false;
		} else if (!message2.equals(other.message2))
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
		String json = gson.toJson(this, elgamlpojo.class);
		return json;

	}

}
