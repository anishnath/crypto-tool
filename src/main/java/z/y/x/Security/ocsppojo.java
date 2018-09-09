package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;

public class ocsppojo implements Serializable {
	
	private String ocspurl;
	private String certstatus;
	private String ocsprequest;
	private String ocspresponse;
	public String getOcspurl() {
		return ocspurl;
	}
	public void setOcspurl(String ocspurl) {
		this.ocspurl = ocspurl;
	}
	public String getCertstatus() {
		return certstatus;
	}
	public void setCertstatus(String certstatus) {
		this.certstatus = certstatus;
	}
	public String getOcsprequest() {
		return ocsprequest;
	}
	public void setOcsprequest(String ocsprequest) {
		this.ocsprequest = ocsprequest;
	}
	public String getOcspresponse() {
		return ocspresponse;
	}
	public void setOcspresponse(String ocspresponse) {
		this.ocspresponse = ocspresponse;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((certstatus == null) ? 0 : certstatus.hashCode());
		result = prime * result + ((ocsprequest == null) ? 0 : ocsprequest.hashCode());
		result = prime * result + ((ocspresponse == null) ? 0 : ocspresponse.hashCode());
		result = prime * result + ((ocspurl == null) ? 0 : ocspurl.hashCode());
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
		ocsppojo other = (ocsppojo) obj;
		if (certstatus == null) {
			if (other.certstatus != null)
				return false;
		} else if (!certstatus.equals(other.certstatus))
			return false;
		if (ocsprequest == null) {
			if (other.ocsprequest != null)
				return false;
		} else if (!ocsprequest.equals(other.ocsprequest))
			return false;
		if (ocspresponse == null) {
			if (other.ocspresponse != null)
				return false;
		} else if (!ocspresponse.equals(other.ocspresponse))
			return false;
		if (ocspurl == null) {
			if (other.ocspurl != null)
				return false;
		} else if (!ocspurl.equals(other.ocspurl))
			return false;
		return true;
	}
	
	@Override
	public String toString() {

		Gson gson = new Gson();
		String json = gson.toJson(this, ocsppojo.class);
		return json;

	}

}
