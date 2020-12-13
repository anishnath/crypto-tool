package z.y.x.Security;

import com.google.gson.Gson;

/**
 * 
 * @author anishnath
 *
 */
public class fernetpojo {
	

	
	private String version;
	private String iv;
	private String timestapmp;
	private String serialize;
	private String msg;
	private String hmac;
	private String key;
	
	
	
	public String getKey() {
		return key;
	}



	public void setKey(String key) {
		this.key = key;
	}



	public String getHmac() {
		return hmac;
	}



	public void setHmac(String hmac) {
		this.hmac = hmac;
	}



	public String getVersion() {
		return version;
	}



	public void setVersion(String version) {
		this.version = version;
	}



	public String getTimestapmp() {
		return timestapmp;
	}



	public void setTimestapmp(String timestapmp) {
		this.timestapmp = timestapmp;
	}



	public String getIv() {
		return iv;
	}



	public void setIv(String iv) {
		this.iv = iv;
	}



	





	public String getSerialize() {
		return serialize;
	}



	public void setSerialize(String serialize) {
		this.serialize = serialize;
	}



	public String getMsg() {
		return msg;
	}



	public void setMsg(String msg) {
		this.msg = msg;
	}










	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((hmac == null) ? 0 : hmac.hashCode());
		result = prime * result + ((iv == null) ? 0 : iv.hashCode());
		result = prime * result + ((key == null) ? 0 : key.hashCode());
		result = prime * result + ((msg == null) ? 0 : msg.hashCode());
		result = prime * result + ((serialize == null) ? 0 : serialize.hashCode());
		result = prime * result + ((timestapmp == null) ? 0 : timestapmp.hashCode());
		result = prime * result + ((version == null) ? 0 : version.hashCode());
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
		fernetpojo other = (fernetpojo) obj;
		if (hmac == null) {
			if (other.hmac != null)
				return false;
		} else if (!hmac.equals(other.hmac))
			return false;
		if (iv == null) {
			if (other.iv != null)
				return false;
		} else if (!iv.equals(other.iv))
			return false;
		if (key == null) {
			if (other.key != null)
				return false;
		} else if (!key.equals(other.key))
			return false;
		if (msg == null) {
			if (other.msg != null)
				return false;
		} else if (!msg.equals(other.msg))
			return false;
		if (serialize == null) {
			if (other.serialize != null)
				return false;
		} else if (!serialize.equals(other.serialize))
			return false;
		if (timestapmp == null) {
			if (other.timestapmp != null)
				return false;
		} else if (!timestapmp.equals(other.timestapmp))
			return false;
		if (version == null) {
			if (other.version != null)
				return false;
		} else if (!version.equals(other.version))
			return false;
		return true;
	}



	@Override
	public String toString() {
		Gson gson = new Gson();
		String json = gson.toJson(this, fernetpojo.class);
		return json;
	}
	
	

}
