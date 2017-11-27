package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;

/**
 *
 * @author Anish Nath For Demo Visit https://8gwifi.org
 *
 */

public class pgppojo implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    private String privateKey;
    private String publiceKey;
    private String errorMessage;

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    public String getPubliceKey() {
        return publiceKey;
    }

    public void setPubliceKey(String publiceKey) {
        this.publiceKey = publiceKey;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((errorMessage == null) ? 0 : errorMessage.hashCode());
        result = prime * result + ((privateKey == null) ? 0 : privateKey.hashCode());
        result = prime * result + ((publiceKey == null) ? 0 : publiceKey.hashCode());
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
        pgppojo other = (pgppojo) obj;
        if (errorMessage == null) {
            if (other.errorMessage != null)
                return false;
        } else if (!errorMessage.equals(other.errorMessage))
            return false;
        if (privateKey == null) {
            if (other.privateKey != null)
                return false;
        } else if (!privateKey.equals(other.privateKey))
            return false;
        if (publiceKey == null) {
            if (other.publiceKey != null)
                return false;
        } else if (!publiceKey.equals(other.publiceKey))
            return false;
        return true;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    @Override
    public String toString() {

        Gson gson = new Gson();
        String json = gson.toJson(this, pgppojo.class);
        return json;

    }

}