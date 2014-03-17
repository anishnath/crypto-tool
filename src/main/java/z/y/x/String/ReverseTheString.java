package z.y.x.String;

public class ReverseTheString {

	private static String reverseTheLine(final String line) {
		if (line == null || line.trim().length() == 0) {
			return "";
		}

		StringBuilder strb = new StringBuilder();
		String[] strArray = line.split(" ");
		//System.out.println(strArray.length);
		for (int i = strArray.length - 1; i >= 0; i--) {
			strb.append(strArray[i]).append(" ");
		}
		
		return strb.toString();

	}
	
	static String reverseTheString(final String line)
	{
		if (line == null || line.trim().length() == 0) {
			return "";
		}
		
		StringBuilder strb = new StringBuilder();
		
		String[] strArray = line.split(" ");
		if(strArray!=null && strArray.length>1)
		{
			return reverseTheLine(line);
		}
		
		char ch[] = line.toCharArray();
		
		StringBuffer buffer = new StringBuffer(line);
		;
		
		return buffer.reverse().toString();
		
	}
	
	
	public static void main(String[] args) {
		System.out.println(reverseTheString("my name   is anish"));
		System.out.println(reverseTheString("my"));
		System.out.println("my");
	}

}
