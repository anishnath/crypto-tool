package z.y.x.Security;

import com.google.gson.Gson;
public class jwspojo {

	private String sharedSecret;
	private String signature;
	private String serialize;
	private String header;
	private String payload;
	private String state;
	private String privateKey;
	private String publicKey;
	private String cipherText;
	private String authTag;
	private String encryptedKey;
	private String iv;
	private String issuer;
	private String subject;
	private String audienceSize;
	private String expirationTime;
	private String notBeforeTime;
	private String issueTime;
	private String jwtid;






	public String getSharedSecret() {
		return sharedSecret;
	}






	public void setSharedSecret(String sharedSecret) {
		this.sharedSecret = sharedSecret;
	}






	public String getSignature() {
		return signature;
	}






	public void setSignature(String signature) {
		this.signature = signature;
	}






	public String getSerialize() {
		return serialize;
	}






	public void setSerialize(String serialize) {
		this.serialize = serialize;
	}






	public String getHeader() {
		return header;
	}






	public void setHeader(String header) {
		this.header = header;
	}






	public String getPayload() {
		return payload;
	}






	public void setPayload(String payload) {
		this.payload = payload;
	}






	public String getState() {
		return state;
	}






	public void setState(String state) {
		this.state = state;
	}






	public String getPrivateKey() {
		return privateKey;
	}






	public void setPrivateKey(String privateKey) {
		this.privateKey = privateKey;
	}






	public String getPublicKey() {
		return publicKey;
	}






	public void setPublicKey(String publicKey) {
		this.publicKey = publicKey;
	}






	public String getCipherText() {
		return cipherText;
	}






	public void setCipherText(String cipherText) {
		this.cipherText = cipherText;
	}






	public String getAuthTag() {
		return authTag;
	}






	public void setAuthTag(String authTag) {
		this.authTag = authTag;
	}






	public String getEncryptedKey() {
		return encryptedKey;
	}






	public void setEncryptedKey(String encryptedKey) {
		this.encryptedKey = encryptedKey;
	}






	public String getIv() {
		return iv;
	}






	public void setIv(String iv) {
		this.iv = iv;
	}






	public String getIssuer() {
		return issuer;
	}






	public void setIssuer(String issuer) {
		this.issuer = issuer;
	}






	public String getSubject() {
		return subject;
	}






	public void setSubject(String subject) {
		this.subject = subject;
	}






	public String getAudienceSize() {
		return audienceSize;
	}






	public void setAudienceSize(String audienceSize) {
		this.audienceSize = audienceSize;
	}






	public String getExpirationTime() {
		return expirationTime;
	}






	public void setExpirationTime(String expirationTime) {
		this.expirationTime = expirationTime;
	}






	public String getNotBeforeTime() {
		return notBeforeTime;
	}






	public void setNotBeforeTime(String notBeforeTime) {
		this.notBeforeTime = notBeforeTime;
	}






	public String getIssueTime() {
		return issueTime;
	}






	public void setIssueTime(String issueTime) {
		this.issueTime = issueTime;
	}






	public String getJwtid() {
		return jwtid;
	}






	public void setJwtid(String jwtid) {
		this.jwtid = jwtid;
	}






	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((audienceSize == null) ? 0 : audienceSize.hashCode());
		result = prime * result + ((authTag == null) ? 0 : authTag.hashCode());
		result = prime * result + ((cipherText == null) ? 0 : cipherText.hashCode());
		result = prime * result + ((encryptedKey == null) ? 0 : encryptedKey.hashCode());
		result = prime * result + ((expirationTime == null) ? 0 : expirationTime.hashCode());
		result = prime * result + ((header == null) ? 0 : header.hashCode());
		result = prime * result + ((issueTime == null) ? 0 : issueTime.hashCode());
		result = prime * result + ((issuer == null) ? 0 : issuer.hashCode());
		result = prime * result + ((iv == null) ? 0 : iv.hashCode());
		result = prime * result + ((jwtid == null) ? 0 : jwtid.hashCode());
		result = prime * result + ((notBeforeTime == null) ? 0 : notBeforeTime.hashCode());
		result = prime * result + ((payload == null) ? 0 : payload.hashCode());
		result = prime * result + ((privateKey == null) ? 0 : privateKey.hashCode());
		result = prime * result + ((publicKey == null) ? 0 : publicKey.hashCode());
		result = prime * result + ((serialize == null) ? 0 : serialize.hashCode());
		result = prime * result + ((sharedSecret == null) ? 0 : sharedSecret.hashCode());
		result = prime * result + ((signature == null) ? 0 : signature.hashCode());
		result = prime * result + ((state == null) ? 0 : state.hashCode());
		result = prime * result + ((subject == null) ? 0 : subject.hashCode());
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
		jwspojo other = (jwspojo) obj;
		if (audienceSize == null) {
			if (other.audienceSize != null)
				return false;
		} else if (!audienceSize.equals(other.audienceSize))
			return false;
		if (authTag == null) {
			if (other.authTag != null)
				return false;
		} else if (!authTag.equals(other.authTag))
			return false;
		if (cipherText == null) {
			if (other.cipherText != null)
				return false;
		} else if (!cipherText.equals(other.cipherText))
			return false;
		if (encryptedKey == null) {
			if (other.encryptedKey != null)
				return false;
		} else if (!encryptedKey.equals(other.encryptedKey))
			return false;
		if (expirationTime == null) {
			if (other.expirationTime != null)
				return false;
		} else if (!expirationTime.equals(other.expirationTime))
			return false;
		if (header == null) {
			if (other.header != null)
				return false;
		} else if (!header.equals(other.header))
			return false;
		if (issueTime == null) {
			if (other.issueTime != null)
				return false;
		} else if (!issueTime.equals(other.issueTime))
			return false;
		if (issuer == null) {
			if (other.issuer != null)
				return false;
		} else if (!issuer.equals(other.issuer))
			return false;
		if (iv == null) {
			if (other.iv != null)
				return false;
		} else if (!iv.equals(other.iv))
			return false;
		if (jwtid == null) {
			if (other.jwtid != null)
				return false;
		} else if (!jwtid.equals(other.jwtid))
			return false;
		if (notBeforeTime == null) {
			if (other.notBeforeTime != null)
				return false;
		} else if (!notBeforeTime.equals(other.notBeforeTime))
			return false;
		if (payload == null) {
			if (other.payload != null)
				return false;
		} else if (!payload.equals(other.payload))
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
		if (serialize == null) {
			if (other.serialize != null)
				return false;
		} else if (!serialize.equals(other.serialize))
			return false;
		if (sharedSecret == null) {
			if (other.sharedSecret != null)
				return false;
		} else if (!sharedSecret.equals(other.sharedSecret))
			return false;
		if (signature == null) {
			if (other.signature != null)
				return false;
		} else if (!signature.equals(other.signature))
			return false;
		if (state == null) {
			if (other.state != null)
				return false;
		} else if (!state.equals(other.state))
			return false;
		if (subject == null) {
			if (other.subject != null)
				return false;
		} else if (!subject.equals(other.subject))
			return false;
		return true;
	}






	@Override
	public String toString() {
		Gson gson = new Gson();
		String json = gson.toJson(this, jwspojo.class);
		return json;
	}



}
