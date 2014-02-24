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

}
