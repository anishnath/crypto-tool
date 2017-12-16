package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;


/**
 * 
 * @author Anish Nath For Demo Visit https://8gwifi.org
 *
 */
public class ecpojo implements Serializable {
	private static final long serialVersionUID = 1L;

	private String ecprivateKeyA;
	private String ecpubliceKeyA;
	private String ecprivateKeyB;
	private String ecpubliceKeyB;
	private String shareSecretA;
	private String shareSecretB;
	private String intialVector;
	private String errorMessage;
	
  
	public String getEcprivateKeyA() {
		return ecprivateKeyA;
	}


	public void setEcprivateKeyA(String ecprivateKeyA) {
		this.ecprivateKeyA = ecprivateKeyA;
	}


	public String getEcpubliceKeyA() {
		return ecpubliceKeyA;
	}


	public void setEcpubliceKeyA(String ecpubliceKeyA) {
		this.ecpubliceKeyA = ecpubliceKeyA;
	}


	public String getEcprivateKeyB() {
		return ecprivateKeyB;
	}


	public void setEcprivateKeyB(String ecprivateKeyB) {
		this.ecprivateKeyB = ecprivateKeyB;
	}


	public String getEcpubliceKeyB() {
		return ecpubliceKeyB;
	}


	public void setEcpubliceKeyB(String ecpubliceKeyB) {
		this.ecpubliceKeyB = ecpubliceKeyB;
	}


	public String getShareSecretA() {
		return shareSecretA;
	}


	public void setShareSecretA(String shareSecretA) {
		this.shareSecretA = shareSecretA;
	}


	public String getShareSecretB() {
		return shareSecretB;
	}


	public void setShareSecretB(String shareSecretB) {
		this.shareSecretB = shareSecretB;
	}


	public String getIntialVector() {
		return intialVector;
	}


	public void setIntialVector(String intialVector) {
		this.intialVector = intialVector;
	}


	public String getErrorMessage() {
		return errorMessage;
	}


	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}


	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	


	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((ecprivateKeyA == null) ? 0 : ecprivateKeyA.hashCode());
		result = prime * result + ((ecprivateKeyB == null) ? 0 : ecprivateKeyB.hashCode());
		result = prime * result + ((ecpubliceKeyA == null) ? 0 : ecpubliceKeyA.hashCode());
		result = prime * result + ((ecpubliceKeyB == null) ? 0 : ecpubliceKeyB.hashCode());
		result = prime * result + ((errorMessage == null) ? 0 : errorMessage.hashCode());
		result = prime * result + ((intialVector == null) ? 0 : intialVector.hashCode());
		result = prime * result + ((shareSecretA == null) ? 0 : shareSecretA.hashCode());
		result = prime * result + ((shareSecretB == null) ? 0 : shareSecretB.hashCode());
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
		ecpojo other = (ecpojo) obj;
		if (ecprivateKeyA == null) {
			if (other.ecprivateKeyA != null)
				return false;
		} else if (!ecprivateKeyA.equals(other.ecprivateKeyA))
			return false;
		if (ecprivateKeyB == null) {
			if (other.ecprivateKeyB != null)
				return false;
		} else if (!ecprivateKeyB.equals(other.ecprivateKeyB))
			return false;
		if (ecpubliceKeyA == null) {
			if (other.ecpubliceKeyA != null)
				return false;
		} else if (!ecpubliceKeyA.equals(other.ecpubliceKeyA))
			return false;
		if (ecpubliceKeyB == null) {
			if (other.ecpubliceKeyB != null)
				return false;
		} else if (!ecpubliceKeyB.equals(other.ecpubliceKeyB))
			return false;
		if (errorMessage == null) {
			if (other.errorMessage != null)
				return false;
		} else if (!errorMessage.equals(other.errorMessage))
			return false;
		if (intialVector == null) {
			if (other.intialVector != null)
				return false;
		} else if (!intialVector.equals(other.intialVector))
			return false;
		if (shareSecretA == null) {
			if (other.shareSecretA != null)
				return false;
		} else if (!shareSecretA.equals(other.shareSecretA))
			return false;
		if (shareSecretB == null) {
			if (other.shareSecretB != null)
				return false;
		} else if (!shareSecretB.equals(other.shareSecretB))
			return false;
		return true;
	}


	@Override
	public String toString() {
		Gson gson = new Gson();
		String json = gson.toJson(this, ecpojo.class);
		return json;
	}
	
	

}
