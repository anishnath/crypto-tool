package z.y.x.u;

import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.EncoderException;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.net.URLCodec;

/**
 * @since March 2014
 * @author ANish
 *
 */
public class HexUtils {
	
	public static byte[] decode(final String string) throws DecoderException
	{
		if(string!=null && !string.isEmpty())
		{
			String temp = removeDelemiter(string,null);
			return (byte[]) new Hex().decode(temp);
		}
		return null;
		
		
	}
	
	public static byte[] hexStringToByteArray(String s) {
	    int len = s.length();
	    byte[] data = new byte[len / 2];
	    for (int i = 0; i < len; i += 2) {
	        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
	                             + Character.digit(s.charAt(i+1), 16));
	    }
	    return data;
	}
	
	private static String removeDelemiter(final String value,final String delimeter)
	{
		
		if(value!=null && !value.isEmpty())
		{
			String temp = value.trim();
			if(delimeter!=null)
			{
				temp=temp.replaceAll(delimeter, "");
			}
			else if(value.contains(":"))
			{
				temp=temp.replaceAll(":", "");
			}
			else if(value.contains(" "))
			{
				temp=temp.replaceAll(" ", "");
			}
			
			return temp;
		}
		return "";
	}
	
	public static String encodeHex(byte[] by,final String deliminater)
	{
	     char[]  actual = Hex.encodeHex(by);
	      
	     return addDeliminater(new String(actual),deliminater);
	}
	
	private static String addDeliminater(final String hexValue ,final String deliminater)
	{
		StringBuilder builder = new StringBuilder();
		String tempValue = hexValue;
		if(tempValue!=null && !tempValue.isEmpty())
		{
			tempValue = tempValue.trim();
			if(tempValue.length()==2)
				{
					return tempValue;
				}
			char[] ch = tempValue.toCharArray();
			int j=2;
			for(int i=0 ;i<tempValue.length();i++)
			{
				
				if(i==j)
				{
					builder.append(deliminater);
					builder.append(ch[i]);
					j=j+2;
				}else{
					builder.append(ch[i]);
				}
			}
			
		}
		return builder.toString();
	}
	
	
	public static String enCodeURI(final String url,final String encoding) throws EncoderException, UnsupportedEncodingException
	{
		if(url!=null && !url.isEmpty())
		{
			URLCodec urlCodec = new URLCodec();
			 String encoded = urlCodec.encode(url,encoding);			
			 return encoded;
		}
		return "";
		
	}
	
	public static String deCodeURI(final String uri,final String encoding) throws DecoderException, UnsupportedEncodingException 
	{
		if(uri!=null && !uri.isEmpty())
		{
			URLCodec urlCodec = new URLCodec();
			 String decoded = urlCodec.decode(uri,encoding);
			 return decoded;
		}
		return "";
		
	}
	

	
	public static void main(String[] args) {
		try {
			System.out.println(decode("06"));
			
			System.out.println(new String(decode("61736461736461736473")));
			
			System.out.println(addDeliminater("61736461736461736473", ":"));
			System.out.println(addDeliminater("61736461736461736473", " "));
			
			//61:73:64:61:73:64:61:73:64:73
			//61 73 64 61 73 64 61 73 64 73
			
			System.out.println(removeDelemiter("61:73:64:61:73:64:61:73:64:73", ":"));
			System.out.println(removeDelemiter("61 73 64 61 73 64 61 73 64 73", " "));
			
			//System.out.println(encodeHex("asdasdasds".getBytes()));
			
		} catch (DecoderException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
