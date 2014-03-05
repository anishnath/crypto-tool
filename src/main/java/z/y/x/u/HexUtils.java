package z.y.x.u;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;

/**
 * 
 * @author ANish
 *
 */
public class HexUtils {
	
	public static Object decode(final String string) throws DecoderException
	{
		return (Object)new Hex().decode(string);
		
	}
	
	public static String encodeHex(byte[] by)
	{
	      char[]  actual = Hex.encodeHex(by);
	     return new String(actual);
	}
	
	public static void main(String[] args) {
		try {
			System.out.println(decode("06"));
			
			System.out.println(encodeHex("asdasdasds".getBytes()));
			
		} catch (DecoderException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
