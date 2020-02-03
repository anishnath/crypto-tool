package z.y.x.Security;

import com.google.gson.Gson;

public class eckeypojo {
	
	private String algo;
	private String format;
	private String keySize;
	private String curveName;
	
	private String order;
	private String affineX;
	private String affineY;
	private String cofactor;
	
	private String privateKey;
	private String publicKey;
	
	private String md5;
	private String sha256;
	private String sha1;
	public String getAlgo() {
		return algo;
	}
	public void setAlgo(String algo) {
		this.algo = algo;
	}
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	public String getKeySize() {
		return keySize;
	}
	public void setKeySize(String keySize) {
		this.keySize = keySize;
	}
	public String getCurveName() {
		return curveName;
	}
	public void setCurveName(String curveName) {
		this.curveName = curveName;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public String getAffineX() {
		return affineX;
	}
	public void setAffineX(String affineX) {
		this.affineX = affineX;
	}
	public String getAffineY() {
		return affineY;
	}
	public void setAffineY(String affineY) {
		this.affineY = affineY;
	}
	public String getCofactor() {
		return cofactor;
	}
	public void setCofactor(String cofactor) {
		this.cofactor = cofactor;
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
	public String getMd5() {
		return md5;
	}
	public void setMd5(String md5) {
		this.md5 = md5;
	}
	public String getSha256() {
		return sha256;
	}
	public void setSha256(String sha256) {
		this.sha256 = sha256;
	}
	public String getSha1() {
		return sha1;
	}
	public void setSha1(String sha1) {
		this.sha1 = sha1;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((affineX == null) ? 0 : affineX.hashCode());
		result = prime * result + ((affineY == null) ? 0 : affineY.hashCode());
		result = prime * result + ((algo == null) ? 0 : algo.hashCode());
		result = prime * result + ((cofactor == null) ? 0 : cofactor.hashCode());
		result = prime * result + ((curveName == null) ? 0 : curveName.hashCode());
		result = prime * result + ((format == null) ? 0 : format.hashCode());
		result = prime * result + ((keySize == null) ? 0 : keySize.hashCode());
		result = prime * result + ((md5 == null) ? 0 : md5.hashCode());
		result = prime * result + ((order == null) ? 0 : order.hashCode());
		result = prime * result + ((privateKey == null) ? 0 : privateKey.hashCode());
		result = prime * result + ((publicKey == null) ? 0 : publicKey.hashCode());
		result = prime * result + ((sha1 == null) ? 0 : sha1.hashCode());
		result = prime * result + ((sha256 == null) ? 0 : sha256.hashCode());
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
		eckeypojo other = (eckeypojo) obj;
		if (affineX == null) {
			if (other.affineX != null)
				return false;
		} else if (!affineX.equals(other.affineX))
			return false;
		if (affineY == null) {
			if (other.affineY != null)
				return false;
		} else if (!affineY.equals(other.affineY))
			return false;
		if (algo == null) {
			if (other.algo != null)
				return false;
		} else if (!algo.equals(other.algo))
			return false;
		if (cofactor == null) {
			if (other.cofactor != null)
				return false;
		} else if (!cofactor.equals(other.cofactor))
			return false;
		if (curveName == null) {
			if (other.curveName != null)
				return false;
		} else if (!curveName.equals(other.curveName))
			return false;
		if (format == null) {
			if (other.format != null)
				return false;
		} else if (!format.equals(other.format))
			return false;
		if (keySize == null) {
			if (other.keySize != null)
				return false;
		} else if (!keySize.equals(other.keySize))
			return false;
		if (md5 == null) {
			if (other.md5 != null)
				return false;
		} else if (!md5.equals(other.md5))
			return false;
		if (order == null) {
			if (other.order != null)
				return false;
		} else if (!order.equals(other.order))
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
		if (sha1 == null) {
			if (other.sha1 != null)
				return false;
		} else if (!sha1.equals(other.sha1))
			return false;
		if (sha256 == null) {
			if (other.sha256 != null)
				return false;
		} else if (!sha256.equals(other.sha256))
			return false;
		return true;
	}
	
	

	@Override
	public String toString() {
		Gson gson = new Gson();
        String json = gson.toJson(this, eckeypojo.class);
		return json;
	}

}
