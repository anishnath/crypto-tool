package z.y.x.blockchain;

import java.io.Serializable;
import java.util.List;
import java.util.Objects;

import com.google.gson.Gson;


public class WalletPojo implements Serializable {

	private static final long serialVersionUID = 4061370738670969484L;
	private final String RootKey = null;
	private final String Seed = null;
	private final String Mnemonic = null;
	private final String DerivationPath = null;
	private final String AccountPublicKey = null;
	private final String AccountPrivateKey = null;
	private final String BIP32PublicKey = null;
	private final String BIP32PrivateKey = null;
	private final String BIP44AccountPublicKey = null;
	private final String ETHAddress = null;
	private final String BTCAddress = null;
	private final String WIF = null;
	private final String ECDSAAddress = null;
	private final String Sr25519Address = null;
	private final String Ed25519Address = null;
	private final String ECDSAAddressSS58 = null;
	private final String Sr25519AddressSS58 = null;
	private final String Ed25519AddressSS58 = null;
	private final String HexPrivateKey= null;
	private final String HexPublicKey= null;
	private final String HexAddress= null;
	private List<Addresses> Addresses;
	private BLS BLS;
	private  String extraMessage = null;





	@Override
	public int hashCode() {
		return Objects.hash(AccountPrivateKey, AccountPublicKey, Addresses, BIP32PrivateKey, BIP32PublicKey,
				BIP44AccountPublicKey, BLS, BTCAddress, DerivationPath, ECDSAAddress, ECDSAAddressSS58, ETHAddress,
				Ed25519Address, Ed25519AddressSS58, HexAddress, HexPrivateKey, HexPublicKey, Mnemonic, RootKey, Seed,
				Sr25519Address, Sr25519AddressSS58, WIF, extraMessage);
	}





	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		WalletPojo other = (WalletPojo) obj;
		return Objects.equals(AccountPrivateKey, other.AccountPrivateKey)
				&& Objects.equals(AccountPublicKey, other.AccountPublicKey)
				&& Objects.equals(Addresses, other.Addresses) && Objects.equals(BIP32PrivateKey, other.BIP32PrivateKey)
				&& Objects.equals(BIP32PublicKey, other.BIP32PublicKey)
				&& Objects.equals(BIP44AccountPublicKey, other.BIP44AccountPublicKey) && Objects.equals(BLS, other.BLS)
				&& Objects.equals(BTCAddress, other.BTCAddress) && Objects.equals(DerivationPath, other.DerivationPath)
				&& Objects.equals(ECDSAAddress, other.ECDSAAddress)
				&& Objects.equals(ECDSAAddressSS58, other.ECDSAAddressSS58)
				&& Objects.equals(ETHAddress, other.ETHAddress) && Objects.equals(Ed25519Address, other.Ed25519Address)
				&& Objects.equals(Ed25519AddressSS58, other.Ed25519AddressSS58)
				&& Objects.equals(HexAddress, other.HexAddress) && Objects.equals(HexPrivateKey, other.HexPrivateKey)
				&& Objects.equals(HexPublicKey, other.HexPublicKey) && Objects.equals(Mnemonic, other.Mnemonic)
				&& Objects.equals(RootKey, other.RootKey) && Objects.equals(Seed, other.Seed)
				&& Objects.equals(Sr25519Address, other.Sr25519Address)
				&& Objects.equals(Sr25519AddressSS58, other.Sr25519AddressSS58) && Objects.equals(WIF, other.WIF)
				&& Objects.equals(extraMessage, other.extraMessage);
	}





	public List<Addresses> getAddresses() {
		return Addresses;
	}





	public void setAddresses(List<Addresses> addresses) {
		Addresses = addresses;
	}





	public BLS getBLS() {
		return BLS;
	}





	public void setBLS(BLS bLS) {
		BLS = bLS;
	}





	public String getExtraMessage() {
		return extraMessage;
	}





	public void setExtraMessage(String extraMessage) {
		this.extraMessage = extraMessage;
	}





	public static long getSerialversionuid() {
		return serialVersionUID;
	}





	public String getRootKey() {
		return RootKey;
	}





	public String getSeed() {
		return Seed;
	}





	public String getMnemonic() {
		return Mnemonic;
	}





	public String getDerivationPath() {
		return DerivationPath;
	}





	public String getAccountPublicKey() {
		return AccountPublicKey;
	}





	public String getAccountPrivateKey() {
		return AccountPrivateKey;
	}





	public String getBIP32PublicKey() {
		return BIP32PublicKey;
	}





	public String getBIP32PrivateKey() {
		return BIP32PrivateKey;
	}





	public String getBIP44AccountPublicKey() {
		return BIP44AccountPublicKey;
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





	public String getECDSAAddress() {
		return ECDSAAddress;
	}





	public String getSr25519Address() {
		return Sr25519Address;
	}





	public String getEd25519Address() {
		return Ed25519Address;
	}





	public String getECDSAAddressSS58() {
		return ECDSAAddressSS58;
	}





	public String getSr25519AddressSS58() {
		return Sr25519AddressSS58;
	}





	public String getEd25519AddressSS58() {
		return Ed25519AddressSS58;
	}





	public String getHexPrivateKey() {
		return HexPrivateKey;
	}





	public String getHexPublicKey() {
		return HexPublicKey;
	}





	public String getHexAddress() {
		return HexAddress;
	}





	@Override
	public String toString() {
		Gson gson = new Gson();
		String json = gson.toJson(this, WalletPojo.class);
		return json;
	}

}
