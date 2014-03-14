package z.y.x.Security;

public class CertInfo {
	
	private String hostName;
	private  String company;
	private  String Department;
	private  String Email;
	private  String City;
	private  String State;
	private  String Country;
	private  int expiry;
	public CertInfo(String hostname,String company, String department, String email,
			String city, String state, String country,int exp) {
		super();
		this.hostName=hostname;
		this.company = company;
		Department = department;
		Email = email;
		City = city;
		State = state;
		Country = country;
		expiry = exp;
	}
	public String getCompany() {
		return company;
	}
	public String getDepartment() {
		return Department;
	}
	public String getEmail() {
		return Email;
	}
	public String getCity() {
		return City;
	}
	public String getState() {
		return State;
	}
	public String getCountry() {
		return Country;
	}
	public int getExpiry() {
		return expiry;
	}
	
	
	
	public String getHostName() {
		return hostName;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return " CN=" + hostName + ", O=" + company
				+ ", OU=" + Department + ", UID=" + Email + ", L="
				+ City + ", ST=" + State + ", C=" + Country
				+ "";
	}
	
	public static void main(String[] args) {
		CertInfo certInfo = new CertInfo("XY", "A", "DD", "xyz", "Cyit", "state", "country", 12);
		
		System.out.println(certInfo);
	}
	
	
}
