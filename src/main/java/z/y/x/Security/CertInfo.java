package z.y.x.Security;

import com.google.gson.Gson;

import java.util.Arrays;

public class CertInfo {


	private String hostName;

	private String company;
	private String Department;
	private String Email;
	private String City;
	private String State;
	private String Country;
	private int expiry;
	private String[] alt_name;

	public CertInfo()
	{

	}
	public CertInfo(String hostName) {
		super();
		this.hostName = hostName;
	}


	public CertInfo(String hostName, String company, String department, String email, String city, String state,
					String country, int expiry) {
		super();
		this.hostName = hostName;
		this.company = company;
		Department = department;
		Email = email;
		City = city;
		State = state;
		Country = country;
		this.expiry = expiry;
	}


	public CertInfo(String hostname, String company, String department, String email, String city, String state,
					String country, String[]  lt_name,int exp) {
		super();
		this.hostName = hostname;
		this.company = company;
		Department = department;
		Email = email;
		City = city;
		State = state;
		Country = country;
		expiry = exp;
		alt_name=lt_name;
	}





	public String getHostName() {
		return hostName;
	}





	public void setHostName(String hostName) {
		this.hostName = hostName;
	}





	public String getCompany() {
		return company;
	}





	public void setCompany(String company) {
		this.company = company;
	}





	public String getDepartment() {
		return Department;
	}





	public void setDepartment(String department) {
		Department = department;
	}





	public String getEmail() {
		return Email;
	}





	public void setEmail(String email) {
		Email = email;
	}





	public String getCity() {
		return City;
	}





	public void setCity(String city) {
		City = city;
	}





	public String getState() {
		return State;
	}





	public void setState(String state) {
		State = state;
	}





	public String getCountry() {
		return Country;
	}





	public void setCountry(String country) {
		Country = country;
	}





	public int getExpiry() {
		return expiry;
	}





	public void setExpiry(int expiry) {
		this.expiry = expiry;
	}





	public String[] getAlt_name() {
		return alt_name;
	}





	public void setAlt_name(String[] alt_name) {
		this.alt_name = alt_name;
	}



	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((City == null) ? 0 : City.hashCode());
		result = prime * result + ((Country == null) ? 0 : Country.hashCode());
		result = prime * result + ((Department == null) ? 0 : Department.hashCode());
		result = prime * result + ((Email == null) ? 0 : Email.hashCode());
		result = prime * result + ((State == null) ? 0 : State.hashCode());
		result = prime * result + Arrays.hashCode(alt_name);
		result = prime * result + ((company == null) ? 0 : company.hashCode());
		result = prime * result + expiry;
		result = prime * result + ((hostName == null) ? 0 : hostName.hashCode());
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
		CertInfo other = (CertInfo) obj;
		if (City == null) {
			if (other.City != null)
				return false;
		} else if (!City.equals(other.City))
			return false;
		if (Country == null) {
			if (other.Country != null)
				return false;
		} else if (!Country.equals(other.Country))
			return false;
		if (Department == null) {
			if (other.Department != null)
				return false;
		} else if (!Department.equals(other.Department))
			return false;
		if (Email == null) {
			if (other.Email != null)
				return false;
		} else if (!Email.equals(other.Email))
			return false;
		if (State == null) {
			if (other.State != null)
				return false;
		} else if (!State.equals(other.State))
			return false;
		if (!Arrays.equals(alt_name, other.alt_name))
			return false;
		if (company == null) {
			if (other.company != null)
				return false;
		} else if (!company.equals(other.company))
			return false;
		if (expiry != other.expiry)
			return false;
		if (hostName == null) {
			if (other.hostName != null)
				return false;
		} else if (!hostName.equals(other.hostName))
			return false;
		return true;
	}



	@Override
	public String toString() {
		Gson gson = new Gson();
		String json = gson.toJson(this, CertInfo.class);
		return json;
	}





	public static void main(String[] args) {
		CertInfo certInfo = new CertInfo("XY", "A", "DD", "xyz", "Cyit", "state", "country", 12);

		System.out.println(certInfo);

		String[] altname = {"Anish","Nath","8gwifi.org"};

		certInfo = new CertInfo("XY", "A", "DD", "xyz", "Cyit", "state", "country", altname,12);

		System.out.println(certInfo);

	}



}
