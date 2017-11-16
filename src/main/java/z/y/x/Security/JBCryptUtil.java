package z.y.x.Security;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Created by Anish Nath on 11/16/17.
 * Demo at 8gwifi.org
 */
public class JBCryptUtil {


    public static String hashPassword(String password_plaintext, int workload) {
        String salt = BCrypt.gensalt(workload);
        String hashed_password = BCrypt.hashpw(password_plaintext, salt);

        return(hashed_password);
    }


    public static boolean checkPassword(String password_plaintext, String stored_hash) {
        boolean password_verified = false;

        if(null == stored_hash || !stored_hash.startsWith("$2a$"))
            throw new java.lang.IllegalArgumentException("Invalid hash provided for comparison");

        password_verified = BCrypt.checkpw(password_plaintext, stored_hash);

        return(password_verified);
    }


}
