package z.y.x.Security;

import com.google.gson.Gson;

public class rsapojo {
	
	private String keySize;
	private String fingerprint;
	private String format;
	private String algo;
	private String type;
	private String CrtCoefficient;
	private String Modulus;
	private String PrimeExponentP;
	private String PrimeExponentQ;
	private String PrimeP;
	private String PrimeQ;
	private String md5;
	private String sha256;
	private String sha1;
	private String encoded;
	private String privateexponent;
	private String publicexponent;
	
	
	


	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((CrtCoefficient == null) ? 0 : CrtCoefficient.hashCode());
		result = prime * result + ((Modulus == null) ? 0 : Modulus.hashCode());
		result = prime * result + ((PrimeExponentP == null) ? 0 : PrimeExponentP.hashCode());
		result = prime * result + ((PrimeExponentQ == null) ? 0 : PrimeExponentQ.hashCode());
		result = prime * result + ((PrimeP == null) ? 0 : PrimeP.hashCode());
		result = prime * result + ((PrimeQ == null) ? 0 : PrimeQ.hashCode());
		result = prime * result + ((algo == null) ? 0 : algo.hashCode());
		result = prime * result + ((encoded == null) ? 0 : encoded.hashCode());
		result = prime * result + ((fingerprint == null) ? 0 : fingerprint.hashCode());
		result = prime * result + ((format == null) ? 0 : format.hashCode());
		result = prime * result + ((keySize == null) ? 0 : keySize.hashCode());
		result = prime * result + ((md5 == null) ? 0 : md5.hashCode());
		result = prime * result + ((privateexponent == null) ? 0 : privateexponent.hashCode());
		result = prime * result + ((publicexponent == null) ? 0 : publicexponent.hashCode());
		result = prime * result + ((sha1 == null) ? 0 : sha1.hashCode());
		result = prime * result + ((sha256 == null) ? 0 : sha256.hashCode());
		result = prime * result + ((type == null) ? 0 : type.hashCode());
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
		rsapojo other = (rsapojo) obj;
		if (CrtCoefficient == null) {
			if (other.CrtCoefficient != null)
				return false;
		} else if (!CrtCoefficient.equals(other.CrtCoefficient))
			return false;
		if (Modulus == null) {
			if (other.Modulus != null)
				return false;
		} else if (!Modulus.equals(other.Modulus))
			return false;
		if (PrimeExponentP == null) {
			if (other.PrimeExponentP != null)
				return false;
		} else if (!PrimeExponentP.equals(other.PrimeExponentP))
			return false;
		if (PrimeExponentQ == null) {
			if (other.PrimeExponentQ != null)
				return false;
		} else if (!PrimeExponentQ.equals(other.PrimeExponentQ))
			return false;
		if (PrimeP == null) {
			if (other.PrimeP != null)
				return false;
		} else if (!PrimeP.equals(other.PrimeP))
			return false;
		if (PrimeQ == null) {
			if (other.PrimeQ != null)
				return false;
		} else if (!PrimeQ.equals(other.PrimeQ))
			return false;
		if (algo == null) {
			if (other.algo != null)
				return false;
		} else if (!algo.equals(other.algo))
			return false;
		if (encoded == null) {
			if (other.encoded != null)
				return false;
		} else if (!encoded.equals(other.encoded))
			return false;
		if (fingerprint == null) {
			if (other.fingerprint != null)
				return false;
		} else if (!fingerprint.equals(other.fingerprint))
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
		if (privateexponent == null) {
			if (other.privateexponent != null)
				return false;
		} else if (!privateexponent.equals(other.privateexponent))
			return false;
		if (publicexponent == null) {
			if (other.publicexponent != null)
				return false;
		} else if (!publicexponent.equals(other.publicexponent))
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
		if (type == null) {
			if (other.type != null)
				return false;
		} else if (!type.equals(other.type))
			return false;
		return true;
	}





	public String getKeySize() {
		return keySize;
	}





	public void setKeySize(String keySize) {
		this.keySize = keySize;
	}





	public String getFingerprint() {
		return fingerprint;
	}





	public void setFingerprint(String fingerprint) {
		this.fingerprint = fingerprint;
	}





	public String getFormat() {
		return format;
	}





	public void setFormat(String format) {
		this.format = format;
	}





	public String getAlgo() {
		return algo;
	}





	public void setAlgo(String algo) {
		this.algo = algo;
	}





	public String getType() {
		return type;
	}





	public void setType(String type) {
		this.type = type;
	}





	public String getCrtCoefficient() {
		return CrtCoefficient;
	}





	public void setCrtCoefficient(String crtCoefficient) {
		CrtCoefficient = crtCoefficient;
	}





	public String getModulus() {
		return Modulus;
	}





	public void setModulus(String modulus) {
		Modulus = modulus;
	}





	public String getPrimeExponentP() {
		return PrimeExponentP;
	}





	public void setPrimeExponentP(String primeExponentP) {
		PrimeExponentP = primeExponentP;
	}





	public String getPrimeExponentQ() {
		return PrimeExponentQ;
	}





	public void setPrimeExponentQ(String primeExponentQ) {
		PrimeExponentQ = primeExponentQ;
	}





	public String getPrimeP() {
		return PrimeP;
	}





	public void setPrimeP(String primeP) {
		PrimeP = primeP;
	}





	public String getPrimeQ() {
		return PrimeQ;
	}





	public void setPrimeQ(String primeQ) {
		PrimeQ = primeQ;
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





	public String getEncoded() {
		return encoded;
	}





	public void setEncoded(String encoded) {
		this.encoded = encoded;
	}





	public String getPrivateexponent() {
		return privateexponent;
	}





	public void setPrivateexponent(String privateexponent) {
		this.privateexponent = privateexponent;
	}





	public String getPublicexponent() {
		return publicexponent;
	}





	public void setPublicexponent(String publicexponent) {
		this.publicexponent = publicexponent;
	}





	@Override
	public String toString() {
		Gson gson = new Gson();
        String json = gson.toJson(this, rsapojo.class);
		return json;
	}
	

}
