package z.y.x.Security;

/**
 * Created by aninath on 12/7/17.
 */
import com.google.gson.Gson;

/**
 *
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 *
 */

public class EncodedMessage {



    private String message;
    private String hexEncoded;
    private String base64Encoded;
    private String hexDecoded;
    private String base64Decoded;
    private String intialVector;
    private String errorMessage;



    public String getMessage() {
        return message;
    }



    public void setMessage(String message) {
        this.message = message;
    }



    public String getHexEncoded() {
        return hexEncoded;
    }



    public void setHexEncoded(String hexEncoded) {
        this.hexEncoded = hexEncoded;
    }



    public String getBase64Encoded() {
        return base64Encoded;
    }



    public void setBase64Encoded(String base64Encoded) {
        this.base64Encoded = base64Encoded;
    }



    public String getHexDecoded() {
        return hexDecoded;
    }



    public void setHexDecoded(String hexDecoded) {
        this.hexDecoded = hexDecoded;
    }



    public String getBase64Decoded() {
        return base64Decoded;
    }



    public void setBase64Decoded(String base64Decoded) {
        this.base64Decoded = base64Decoded;
    }



    public String getIntialVector() {
        return intialVector;
    }



    public void setIntialVector(String intialVector) {
        this.intialVector = intialVector;
    }



    public String getErrorMessage() {
        return errorMessage;
    }



    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }




    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((base64Decoded == null) ? 0 : base64Decoded.hashCode());
        result = prime * result + ((base64Encoded == null) ? 0 : base64Encoded.hashCode());
        result = prime * result + ((errorMessage == null) ? 0 : errorMessage.hashCode());
        result = prime * result + ((hexDecoded == null) ? 0 : hexDecoded.hashCode());
        result = prime * result + ((hexEncoded == null) ? 0 : hexEncoded.hashCode());
        result = prime * result + ((intialVector == null) ? 0 : intialVector.hashCode());
        result = prime * result + ((message == null) ? 0 : message.hashCode());
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
        EncodedMessage other = (EncodedMessage) obj;
        if (base64Decoded == null) {
            if (other.base64Decoded != null)
                return false;
        } else if (!base64Decoded.equals(other.base64Decoded))
            return false;
        if (base64Encoded == null) {
            if (other.base64Encoded != null)
                return false;
        } else if (!base64Encoded.equals(other.base64Encoded))
            return false;
        if (errorMessage == null) {
            if (other.errorMessage != null)
                return false;
        } else if (!errorMessage.equals(other.errorMessage))
            return false;
        if (hexDecoded == null) {
            if (other.hexDecoded != null)
                return false;
        } else if (!hexDecoded.equals(other.hexDecoded))
            return false;
        if (hexEncoded == null) {
            if (other.hexEncoded != null)
                return false;
        } else if (!hexEncoded.equals(other.hexEncoded))
            return false;
        if (intialVector == null) {
            if (other.intialVector != null)
                return false;
        } else if (!intialVector.equals(other.intialVector))
            return false;
        if (message == null) {
            if (other.message != null)
                return false;
        } else if (!message.equals(other.message))
            return false;
        return true;
    }



    @Override
    public String toString() {

        Gson gson = new Gson();
        String json = gson.toJson(this, EncodedMessage.class);
        return json;

    }

}