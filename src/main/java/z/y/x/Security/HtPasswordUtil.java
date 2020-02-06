package z.y.x.Security;

import org.apache.commons.codec.digest.Sha2Crypt;
import org.apache.commons.codec.digest.UnixCrypt;
import org.mindrot.jbcrypt.BCrypt;
import org.apache.commons.codec.digest.Md5Crypt;

import java.util.Arrays;

/**
 * Created by aninath on 06/02/20.
 */
public class HtPasswordUtil

{

    public static String createPassword(String password, String algo) {

        if ("bcrypt".equalsIgnoreCase(algo)) {
            return BCrypt.hashpw(password, BCrypt.gensalt());
        }

        if ("apr1".equalsIgnoreCase(algo)) {
            return Md5Crypt.apr1Crypt(password);
        }

        if ("md5".equalsIgnoreCase(algo)) {
            return Md5Crypt.md5Crypt(password.getBytes());
        }

        if ("sha256".equalsIgnoreCase(algo)) {
            return Sha2Crypt.sha256Crypt(password.getBytes());
        }

        if ("sha512".equalsIgnoreCase(algo)) {
            return Sha2Crypt.sha512Crypt(password.getBytes());
        }
        if ("crypt".equalsIgnoreCase(algo)) {
            return UnixCrypt.crypt(password.getBytes());
        }

        return Sha2Crypt.sha512Crypt(password.getBytes());

    }

    public static boolean validatePassword(String password, String hashPassword, String algo) throws Exception {

        if ("bcrypt".equalsIgnoreCase(algo)) {

            return BCrypt.checkpw(password, hashPassword);

        }


        String crypted2 = null;
        if (hashPassword == null)
            return false;
        if (hashPassword.length() < 24)
            return false;
        if (hashPassword.charAt(0) != '$')
            return false;
        final int offset2ndDolar = hashPassword.indexOf('$', 1);
        if (offset2ndDolar < 0)
            return false;
        final int offset3ndDolar = hashPassword.indexOf('$', offset2ndDolar + 1);
        if (offset3ndDolar < 0)
            return false;
        final String salt = hashPassword.substring(0, offset3ndDolar + 1);
        final byte[] keyBytes = password.getBytes("UTF-8");
        if (hashPassword.startsWith("$1$")) { // MD5
            crypted2 = Md5Crypt.md5Crypt(keyBytes.clone(), salt);
        } else if (hashPassword.startsWith("$apr1$")) { // APR1
            crypted2 = Md5Crypt.apr1Crypt(keyBytes.clone(), salt);
        } else if (hashPassword.startsWith("$5$")) { // SHA2-256
            crypted2 = Sha2Crypt.sha256Crypt(keyBytes.clone(), salt);
        } else if (hashPassword.startsWith("$6$")) { // SHA2-512
            crypted2 = Sha2Crypt.sha512Crypt(keyBytes.clone(), salt);
        }
        Arrays.fill(keyBytes, (byte) 0);
        if (crypted2 == null)
            return false;
        return hashPassword.equals(crypted2);
    }
}
