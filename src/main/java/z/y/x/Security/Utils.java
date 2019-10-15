package z.y.x.Security;


import z.y.x.r.LoadPropertyFileFunctionality;

import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Created by aninath on 10/30/18.
 */
public class Utils {

//    public static String KEY = "10/2018";
//    public static String INSTALLED = "10/2018";

    private final static char[] hexArray = "0123456789ABCDEF".toCharArray();

    public static boolean vaildate()
    {
        String KEY =  LoadPropertyFileFunctionality.getConfigProperty().get("KEY");
        String INSTALLED =  LoadPropertyFileFunctionality.getConfigProperty().get("INSTALLED");

        return validate(KEY,INSTALLED);
    }


    private static boolean validate(String keys, String expiry) {

        try {



//            System.out.println("expiry--" +  expiry);
//            System.out.println("keys--" +  keys);



            SecretKeySpec key = new SecretKeySpec(keys.getBytes(), "AES");
            IvParameterSpec ivSpec = new IvParameterSpec(new byte[]{0, 0, 0, 0, 0});
            Cipher c = Cipher.getInstance("AES");
            c.init(Cipher.DECRYPT_MODE, key);
            byte[] decrypted = c.doFinal(hexStringToByteArray(expiry));

//            System.out.println(new String("decrypted--" + new String(decrypted)));

            String date = new String(decrypted);

            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            byte[] digest = messageDigest.digest(decrypted);

            messageDigest = MessageDigest.getInstance("MD5");
            digest = messageDigest.digest(digest);

            char[] hexChars = toHex(digest);

            String compare = new String(hexChars);

//            System.out.println(new String("compare--" + compare));


            if (compare.equalsIgnoreCase(keys)) {

                System.out.println("Is Before " + new SimpleDateFormat("MM/yyyy").parse(date).before(new Date()));

                try {
                    if (new SimpleDateFormat("MM/yyyy").parse(date).before(new Date())) {

                        //System.out.println("Expired License--");
                       return true;
                    }
                    return  false;
                } catch (ParseException e) {
                    return  false;
                }
            }
            {
                return false;
            }
        }
        catch (Exception ex)
        {
            return false;
        }
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

    private static char[] toHex(byte[] digest) {
        char[] hexChars = new char[digest.length * 2];
        for (int j = 0; j < digest.length; j++) {
            int v = digest[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return hexChars;
    }

}
