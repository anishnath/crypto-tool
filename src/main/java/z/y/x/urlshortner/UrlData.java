package z.y.x.urlshortner;

import java.io.Serializable;

public class UrlData implements Serializable {

	private static final long serialVersionUID = 8380166207064696629L;
	
	private int id;
    private String originalUrl;
    private String shortCode;
    private int clickCount;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getOriginalUrl() {
		return originalUrl;
	}
	public void setOriginalUrl(String originalUrl) {
		this.originalUrl = originalUrl;
	}
	public String getShortCode() {
		return shortCode;
	}
	public void setShortCode(String shortCode) {
		this.shortCode = shortCode;
	}
	public int getClickCount() {
		return clickCount;
	}
	public void setClickCount(int clickCount) {
		this.clickCount = clickCount;
	}
    
}
