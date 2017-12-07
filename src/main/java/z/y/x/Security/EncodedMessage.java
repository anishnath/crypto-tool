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

    private String hexEncoded;
    private String base64Encoded;
    private String hexDecoded;
    private String base64Decoded;

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

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((base64Decoded == null) ? 0 : base64Decoded.hashCode());
        result = prime * result + ((base64Encoded == null) ? 0 : base64Encoded.hashCode());
        result = prime * result + ((hexDecoded == null) ? 0 : hexDecoded.hashCode());
        result = prime * result + ((hexEncoded == null) ? 0 : hexEncoded.hashCode());
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
        return true;
    }

    @Override
    public String toString() {

        Gson gson = new Gson();
        String json = gson.toJson(this, EncodedMessage.class);
        return json;

    }

}