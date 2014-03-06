package z.y.x.u;

import java.io.UnsupportedEncodingException;

import org.springframework.util.StringUtils;

public class ConversionUtils {
	
	public static String stringToBinary(final String string,String encoding) throws UnsupportedEncodingException
	{
		 StringBuilder binary = new StringBuilder();
		if(string!=null && !string.isEmpty())
		{
			String temp =  string;
			byte[] bytes = temp.getBytes(encoding);
			 
			  for (byte b : bytes)
			  {
				  binary.append(Integer.toBinaryString(b));
			     //binary.append(' ');
			  }
		}
		return binary.toString();
	}
	
	public static String binaryToString(final String binary) {
		StringBuilder bin = new StringBuilder();
		if (binary != null && !binary.isEmpty()) {
			String temp = StringUtils.trimAllWhitespace(binary);
			for(int i = 0; i <= temp.length() - 8; i+=8)
			{
			    try {
					int k = Integer.parseInt(temp.substring(i, i+8), 2);
					bin.append( (char) k);
				} catch (NumberFormatException e) {
					//IGNORE
				}
			}  
		}
		return bin.toString();
	}
	
	public static void main(String[] args) throws UnsupportedEncodingException {
		System.out.println(stringToBinary("stringToBinary","UTF-8"));
		System.out.println(stringToBinary("1","UTF-8"));
		
		System.out.println(binaryToString(stringToBinary("口水雞 hello Ä","UTF-8")));
		System.out.println(binaryToString(stringToBinary("1","UTF-8")));
		
		
	}

}
