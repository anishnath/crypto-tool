package z.y.x.r;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

public class ColorCodeOnStartupFunctionality  extends HttpServlet {
	 
	 protected String myParam = null; 
	 
	 private static Map<Integer,String> colorCodes = new HashMap<Integer, String>();

	  public void init(ServletConfig servletConfig) throws ServletException{
	    this.myParam = servletConfig.getInitParameter("colorcode");
	    
	   // System.out.println(this.myParam);
	    
	    //System.out.println(servletConfig.getServletContext().getContextPath());
	    
	  InputStream is =  servletConfig.getServletContext().getResourceAsStream("WEB-INF/"+this.myParam);
	  // reads till the end of the stream
    
      char c;
      BufferedReader reader = null;
      reader = new BufferedReader(new InputStreamReader(is));
      try {
		String line = reader.readLine(); 
		int i=0;
		while(line != null){
			//System.out.println(line);
			colorCodes.put(i, line);
			++i;
			line = reader.readLine();
		}
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
      
	    
	  }

	
	public static String getRandomColor()
	{
		   Random randomGenerator = new Random();
		   int randomInt = randomGenerator.nextInt(colorCodes.size());
		   
		   return colorCodes.get(randomInt);
		   
	}
	
	

}
