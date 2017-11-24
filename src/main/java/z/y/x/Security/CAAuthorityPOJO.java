package z.y.x.Security;

import java.io.Serializable;

import com.google.gson.Gson;

/**
 *
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 *
 */
public class CAAuthorityPOJO implements Serializable {

    private String rootCAPrivateKey;
    private String rootCAPubliceKey;
    private String rootCACerts;

    private String interCAPrivateKey;
    private String interCAPubliceKey;
    private String interCACerts;

    private String dnsPrivateKey;
    private String dnsPubliceKey;
    private String dnsCerts;

    public String getRootCAPrivateKey() {
        return rootCAPrivateKey;
    }

    public void setRootCAPrivateKey(String rootCAPrivateKey) {
        this.rootCAPrivateKey = rootCAPrivateKey;
    }

    public String getRootCAPubliceKey() {
        return rootCAPubliceKey;
    }

    public void setRootCAPubliceKey(String rootCAPubliceKey) {
        this.rootCAPubliceKey = rootCAPubliceKey;
    }

    public String getRootCACerts() {
        return rootCACerts;
    }

    public void setRootCACerts(String rootCACerts) {
        this.rootCACerts = rootCACerts;
    }

    public String getInterCAPrivateKey() {
        return interCAPrivateKey;
    }

    public void setInterCAPrivateKey(String interCAPrivateKey) {
        this.interCAPrivateKey = interCAPrivateKey;
    }

    public String getInterCAPubliceKey() {
        return interCAPubliceKey;
    }

    public void setInterCAPubliceKey(String interCAPubliceKey) {
        this.interCAPubliceKey = interCAPubliceKey;
    }

    public String getInterCACerts() {
        return interCACerts;
    }

    public void setInterCACerts(String interCACerts) {
        this.interCACerts = interCACerts;
    }

    public String getDnsPrivateKey() {
        return dnsPrivateKey;
    }

    public void setDnsPrivateKey(String dnsPrivateKey) {
        this.dnsPrivateKey = dnsPrivateKey;
    }

    public String getDnsPubliceKey() {
        return dnsPubliceKey;
    }

    public void setDnsPubliceKey(String dnsPubliceKey) {
        this.dnsPubliceKey = dnsPubliceKey;
    }

    public String getDnsCerts() {
        return dnsCerts;
    }

    public void setDnsCerts(String dnsCerts) {
        this.dnsCerts = dnsCerts;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((dnsCerts == null) ? 0 : dnsCerts.hashCode());
        result = prime * result + ((dnsPrivateKey == null) ? 0 : dnsPrivateKey.hashCode());
        result = prime * result + ((dnsPubliceKey == null) ? 0 : dnsPubliceKey.hashCode());
        result = prime * result + ((interCACerts == null) ? 0 : interCACerts.hashCode());
        result = prime * result + ((interCAPrivateKey == null) ? 0 : interCAPrivateKey.hashCode());
        result = prime * result + ((interCAPubliceKey == null) ? 0 : interCAPubliceKey.hashCode());
        result = prime * result + ((rootCACerts == null) ? 0 : rootCACerts.hashCode());
        result = prime * result + ((rootCAPrivateKey == null) ? 0 : rootCAPrivateKey.hashCode());
        result = prime * result + ((rootCAPubliceKey == null) ? 0 : rootCAPubliceKey.hashCode());
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
        CAAuthorityPOJO other = (CAAuthorityPOJO) obj;
        if (dnsCerts == null) {
            if (other.dnsCerts != null)
                return false;
        } else if (!dnsCerts.equals(other.dnsCerts))
            return false;
        if (dnsPrivateKey == null) {
            if (other.dnsPrivateKey != null)
                return false;
        } else if (!dnsPrivateKey.equals(other.dnsPrivateKey))
            return false;
        if (dnsPubliceKey == null) {
            if (other.dnsPubliceKey != null)
                return false;
        } else if (!dnsPubliceKey.equals(other.dnsPubliceKey))
            return false;
        if (interCACerts == null) {
            if (other.interCACerts != null)
                return false;
        } else if (!interCACerts.equals(other.interCACerts))
            return false;
        if (interCAPrivateKey == null) {
            if (other.interCAPrivateKey != null)
                return false;
        } else if (!interCAPrivateKey.equals(other.interCAPrivateKey))
            return false;
        if (interCAPubliceKey == null) {
            if (other.interCAPubliceKey != null)
                return false;
        } else if (!interCAPubliceKey.equals(other.interCAPubliceKey))
            return false;
        if (rootCACerts == null) {
            if (other.rootCACerts != null)
                return false;
        } else if (!rootCACerts.equals(other.rootCACerts))
            return false;
        if (rootCAPrivateKey == null) {
            if (other.rootCAPrivateKey != null)
                return false;
        } else if (!rootCAPrivateKey.equals(other.rootCAPrivateKey))
            return false;
        if (rootCAPubliceKey == null) {
            if (other.rootCAPubliceKey != null)
                return false;
        } else if (!rootCAPubliceKey.equals(other.rootCAPubliceKey))
            return false;
        return true;
    }

    @Override
    public String toString() {

        Gson gson = new Gson();
        String json = gson.toJson(this, CAAuthorityPOJO.class);
        return json;

    }

}