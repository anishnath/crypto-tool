package z.y.x.u;

import java.io.Serializable;

/**
 * Created by aninath on 11/11/17.
 */
public class IPLocation implements Serializable {

    public IPLocation() {

    }

    private String ip;
    private String loc;
    private String city;
    private String region;
    private String country;
    private String org;
    private String hostname;

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getLoc() {
        return loc;
    }

    public void setLoc(String loc) {
        this.loc = loc;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getOrg() {
        return org;
    }

    public void setOrg(String org) {
        this.org = org;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }



    @Override
    public String toString() {
        return "IPLocation{" +
                "ip='" + ip + '\'' +
                ", loc='" + loc + '\'' +
                ", city='" + city + '\'' +
                ", region='" + region + '\'' +
                ", country='" + country + '\'' +
                ", org='" + org + '\'' +
                ", hostname='" + hostname + '\'' +
                '}';
    }
}
