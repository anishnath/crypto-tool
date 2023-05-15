package z.y.x.blockchain;

import java.io.Serializable;
import java.util.Objects;

import com.google.gson.Gson;

/**
 * 
 * @author anish
 *
 */

public class BLS implements Serializable {
    private static final long serialVersionUID = 8054870079348336532L;
	private final String HexPublicKey = null;
    private final String HexPrivateKey = null;
	public String getHexPublicKey() {
		return HexPublicKey;
	}
	public String getHexPrivateKey() {
		return HexPrivateKey;
	}
	@Override
	public int hashCode() {
		return Objects.hash(HexPrivateKey, HexPublicKey);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BLS other = (BLS) obj;
		return Objects.equals(HexPrivateKey, other.HexPrivateKey) && Objects.equals(HexPublicKey, other.HexPublicKey);
	}
	@Override
	public String toString() {
		
		Gson gson = new Gson();
		String json = gson.toJson(this, BLS.class);
		return json;
		
	}
}
