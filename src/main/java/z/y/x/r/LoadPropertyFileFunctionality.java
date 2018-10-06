package z.y.x.r;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

public class LoadPropertyFileFunctionality extends HttpServlet {

	private static Properties prop = new Properties();
	 
	 protected String myParam = null; 
	 
	 private static Map<String,String> configProperty = new HashMap<>();
	  public void init(ServletConfig servletConfig) throws ServletException{

		  this.myParam = servletConfig.getInitParameter("props");


      try {

		  InputStream is =  servletConfig.getServletContext().getResourceAsStream("WEB-INF/"+this.myParam);
		  prop.load(is);
		  if(prop.getProperty("url")!=null)
		  {
			  configProperty.put("url", prop.getProperty("url"));
		  }
		  else
		  {
			  configProperty.put("url", "localhost");
		  }

		  if(prop.getProperty("port")!=null)
		  {
			  configProperty.put("port", prop.getProperty("port"));
		  }
		  else{
			  configProperty.put("port", "8080");
		  }

		  if(prop.getProperty("ep")!=null)
		  {
			  configProperty.put("ep", prop.getProperty("ep"));
		  }
		  else{
			  configProperty.put("ep", "http://localhost/crypto/rest/");
		  }

		  if(prop.getProperty("epn")!=null)
		  {
			  configProperty.put("epn", prop.getProperty("epn"));
		  }
		  else{
			  configProperty.put("epn", "http://localhost/ntru/rest/");
		  }


		  System.out.println("API PORT-- " + prop.getProperty("port"));
		  System.out.println("API URL-- " + prop.getProperty("url"));
		  System.out.println("API ENDPOINT-- " + prop.getProperty("ep"));


	} catch (Exception e) {

		  configProperty.put("url", "localhost");
		  configProperty.put("ep", "http://localhost/crypto/rest/");
		  configProperty.put("epn", "http://localhost/ntru/rest/");



	}
      
	    
	  }

	public static Map<String, String> getConfigProperty() {
		return configProperty;
	}
}
