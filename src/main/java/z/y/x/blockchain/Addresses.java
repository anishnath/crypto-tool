package z.y.x.blockchain;

import java.io.Serializable;
import java.util.Objects;

import com.google.gson.Gson;

public class Addresses implements Serializable {
    private static final long serialVersionUID = 1994966057944031909L;
	private final String Path = null;
    private final String HexPublicKey = null;
    private final String HexPrivateKey = null;
    private final String ETHAddress = null;
    private final String BTCAddress = null;
    private final String WIF = null;

    
    
	@Override
	public int hashCode() {
		return Objects.hash(BTCAddress, ETHAddress, HexPrivateKey, HexPublicKey, Path, WIF);
	}



	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Addresses other = (Addresses) obj;
		return Objects.equals(BTCAddress, other.BTCAddress) && Objects.equals(ETHAddress, other.ETHAddress)
				&& Objects.equals(HexPrivateKey, other.HexPrivateKey)
				&& Objects.equals(HexPublicKey, other.HexPublicKey) && Objects.equals(Path, other.Path)
				&& Objects.equals(WIF, other.WIF);
	}



	public String getPath() {
		return Path;
	}



	public String getHexPublicKey() {
		return HexPublicKey;
	}



	public String getHexPrivateKey() {
		return HexPrivateKey;
	}



	public String getETHAddress() {
		return ETHAddress;
	}



	public String getBTCAddress() {
		return BTCAddress;
	}



	public String getWIF() {
		return WIF;
	}



	@Override
	public String toString() {
		Gson gson = new Gson();
		String json = gson.toJson(this, Addresses.class);
		return json;
	}
    
    

}
