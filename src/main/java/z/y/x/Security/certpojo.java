package z.y.x.Security;

/**
 * Created by aninath on 12/24/17.
 */
import com.google.gson.Gson;

import java.io.Serializable;

public class certpojo implements Serializable {

    private String message;
    private String message2;
    private String privatekey;



    public String getMessage() {
        return message;
    }



    public void setMessage(String message) {
        this.message = message;
    }



    public String getMessage2() {
        return message2;
    }



    public void setMessage2(String message2) {
        this.message2 = message2;
    }



    public String getPrivatekey() {
        return privatekey;
    }



    public void setPrivatekey(String privatekey) {
        this.privatekey = privatekey;
    }




    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((message == null) ? 0 : message.hashCode());
        result = prime * result + ((message2 == null) ? 0 : message2.hashCode());
        result = prime * result + ((privatekey == null) ? 0 : privatekey.hashCode());
        return result;
    }



    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        certpojo other = (certpojo) obj;
        if (message == null) {
            if (other.message != null)
                return false;
        } else if (!message.equals(other.message))
            return false;
        if (message2 == null) {
            if (other.message2 != null)
                return false;
        } else if (!message2.equals(other.message2))
            return false;
        if (privatekey == null) {
            if (other.privatekey != null)
                return false;
        } else if (!privatekey.equals(other.privatekey))
            return false;
        return true;
    }



    @Override
    public String toString() {
        Gson gson = new Gson();
        String json = gson.toJson(this, certpojo.class);
        return json;
    }



}