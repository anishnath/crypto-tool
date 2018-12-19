package z.y.x.Security;

import org.apache.commons.codec.binary.Hex;

import java.security.SecureRandom;

/**
 * Created by aninath on 12/19/18.
 */
public class Utils {

    public static byte[] hexToBytes(String string) {
        int length = string.length();
        byte[] data = new byte[length / 2];
        for (int i = 0; i < length; i += 2) {
            data[i / 2] = (byte) ((Character.digit(string.charAt(i), 16) << 4)
                    + Character.digit(string.charAt(i + 1), 16));
        }
        return data;
    }

    public static boolean isHexNumber(String cadena) {
        try {
            Long.parseLong(cadena, 16);
            return true;
        } catch (NumberFormatException ex) {
            // Error handling code...
            return false;
        }
    }

    public static byte[] getIV(int size)
    {
        SecureRandom randomSecureRandom = new SecureRandom();
        byte[] iv = new byte[size];
        randomSecureRandom.nextBytes(iv);
        return iv;
    }

    public static String toHexEncoded(byte[] b) {
        return new String (Hex.encodeHex(b));
    }

}
