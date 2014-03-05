/**
 * 
 */
package z.y.x.u;

/**
 * @author aninath
 *
 */
public final class StringUtils {
	
	private StringUtils()
	{
		
	}
	
	 public static final String replaceAllWhiteSpace(final String input)
	{
		if(input==null)
		{
			return "";
		}
		
		return input.replaceAll("\\s","");
		
	}
	 
	 public static final String byteToHex(byte[] mdbytes)
	 {
		 final StringBuffer sb = new StringBuffer();
		 for (int i = 0; i < mdbytes.length; i++) {
				sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16)
						.substring(1));
			}
		 return sb.toString();
	 }

}
