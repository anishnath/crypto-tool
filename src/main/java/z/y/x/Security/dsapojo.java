package z.y.x.Security;

import com.google.gson.Gson;

public class dsapojo {
	
	private String keySize;
	private String fingerprint;
	private String format;
	private String algo;
	private String type;
	private String encoded;
	private String pub;
	
	private String p;
	private String g;
	private String q;
	private String x;
	private String y;
	
	private String md5;
	private String sha256;
	private String sha1;
	
	

	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((algo == null) ? 0 : algo.hashCode());
		result = prime * result + ((encoded == null) ? 0 : encoded.hashCode());
		result = prime * result + ((fingerprint == null) ? 0 : fingerprint.hashCode());
		result = prime * result + ((format == null) ? 0 : format.hashCode());
		result = prime * result + ((g == null) ? 0 : g.hashCode());
		result = prime * result + ((keySize == null) ? 0 : keySize.hashCode());
		result = prime * result + ((md5 == null) ? 0 : md5.hashCode());
		result = prime * result + ((p == null) ? 0 : p.hashCode());
		result = prime * result + ((pub == null) ? 0 : pub.hashCode());
		result = prime * result + ((q == null) ? 0 : q.hashCode());
		result = prime * result + ((sha1 == null) ? 0 : sha1.hashCode());
		result = prime * result + ((sha256 == null) ? 0 : sha256.hashCode());
		result = prime * result + ((type == null) ? 0 : type.hashCode());
		result = prime * result + ((x == null) ? 0 : x.hashCode());
		result = prime * result + ((y == null) ? 0 : y.hashCode());
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
		dsapojo other = (dsapojo) obj;
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
		if (g == null) {
			if (other.g != null)
				return false;
		} else if (!g.equals(other.g))
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
		if (p == null) {
			if (other.p != null)
				return false;
		} else if (!p.equals(other.p))
			return false;
		if (pub == null) {
			if (other.pub != null)
				return false;
		} else if (!pub.equals(other.pub))
			return false;
		if (q == null) {
			if (other.q != null)
				return false;
		} else if (!q.equals(other.q))
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
		if (x == null) {
			if (other.x != null)
				return false;
		} else if (!x.equals(other.x))
			return false;
		if (y == null) {
			if (other.y != null)
				return false;
		} else if (!y.equals(other.y))
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




	public String getEncoded() {
		return encoded;
	}




	public void setEncoded(String encoded) {
		this.encoded = encoded;
	}




	public String getPub() {
		return pub;
	}




	public void setPub(String pub) {
		this.pub = pub;
	}




	public String getP() {
		return p;
	}




	public void setP(String p) {
		this.p = p;
	}




	public String getG() {
		return g;
	}




	public void setG(String g) {
		this.g = g;
	}




	public String getQ() {
		return q;
	}




	public void setQ(String q) {
		this.q = q;
	}




	public String getX() {
		return x;
	}




	public void setX(String x) {
		this.x = x;
	}




	public String getY() {
		return y;
	}




	public void setY(String y) {
		this.y = y;
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
	public String toString() {
		Gson gson = new Gson();
        String json = gson.toJson(this, dsapojo.class);
		return json;
	}
	
	
	

}
