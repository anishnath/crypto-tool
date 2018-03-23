package z.y.x.Security;

import java.io.Serializable;
import java.util.Arrays;

import com.google.gson.Gson;

/**
 * 
 * @author Anish Nath
 *
 */
public class samlpojo implements Serializable{
	
	private String node;
	private String signature;
	private String[] message;
	public String getNode() {
		return node;
	}
	public void setNode(String node) {
		this.node = node;
	}
	public String getSignature() {
		return signature;
	}
	public void setSignature(String signature) {
		this.signature = signature;
	}
	public String[] getMessage() {
		return message;
	}
	public void setMessage(String[] message) {
		this.message = message;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(message);
		result = prime * result + ((node == null) ? 0 : node.hashCode());
		result = prime * result + ((signature == null) ? 0 : signature.hashCode());
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
		samlpojo other = (samlpojo) obj;
		if (!Arrays.equals(message, other.message))
			return false;
		if (node == null) {
			if (other.node != null)
				return false;
		} else if (!node.equals(other.node))
			return false;
		if (signature == null) {
			if (other.signature != null)
				return false;
		} else if (!signature.equals(other.signature))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		Gson gson = new Gson();
        String json = gson.toJson(this, samlpojo.class);
		return json;
	}


}
