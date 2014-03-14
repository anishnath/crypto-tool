package z.y.x.Security;

public class CertInfo {
	
	private  String company;
	private  String Department;
	private  String Email;
	private  String City;
	private  String State;
	private  String Country;
	private  int expiry;
	public CertInfo(String company, String department, String email,
			String city, String state, String country,int exp) {
		super();
		this.company = company;
		Department = department;
		Email = email;
		City = city;
		State = state;
		Country = country;
		expiry = exp;
	}
}
