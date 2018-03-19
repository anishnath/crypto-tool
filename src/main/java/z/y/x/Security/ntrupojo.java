package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;

public class ntrupojo implements Serializable{
	
	private String message;
	private String message2;
	private String ntruparam;
	private String privatekey;
	private String publickey;
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getMessage2() {
		return message2;
	}
	public void setMessage2(String message2) {
		this.message2 = message2;
	}
	public String getNtruparam() {
		return ntruparam;
	}
	public void setNtruparam(String ntruparam) {
		this.ntruparam = ntruparam;
	}
	public String getPrivatekey() {
		return privatekey;
	}
	public void setPrivatekey(String privatekey) {
		this.privatekey = privatekey;
	}
	public String getPublickey() {
		return publickey;
	}
	public void setPublickey(String publickey) {
		this.publickey = publickey;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((message == null) ? 0 : message.hashCode());
		result = prime * result + ((message2 == null) ? 0 : message2.hashCode());
		result = prime * result + ((ntruparam == null) ? 0 : ntruparam.hashCode());
		result = prime * result + ((privatekey == null) ? 0 : privatekey.hashCode());
		result = prime * result + ((publickey == null) ? 0 : publickey.hashCode());
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
		ntrupojo other = (ntrupojo) obj;
		if (message == null) {
			if (other.message != null)
				return false;
		} else if (!message.equals(other.message))
			return false;
		if (message2 == null) {
			if (other.message2 != null)
				return false;
		} else if (!message2.equals(other.message2))
			return false;
		if (ntruparam == null) {
			if (other.ntruparam != null)
				return false;
		} else if (!ntruparam.equals(other.ntruparam))
			return false;
		if (privatekey == null) {
			if (other.privatekey != null)
				return false;
		} else if (!privatekey.equals(other.privatekey))
			return false;
		if (publickey == null) {
			if (other.publickey != null)
				return false;
		} else if (!publickey.equals(other.publickey))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		Gson gson = new Gson();
        String json = gson.toJson(this, ntrupojo.class);
		return json;
	}

}
