package z.y.x.f;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import z.y.x.u.BuiltInCompiler;

/**
 * 
 * @author Anish
 *Purpose of the CLass os to Execute the Loaded 
 */
public class ExecuteFunctionality  extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7874516020917706558L;
	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//Test the Class
		BuiltInCompiler.reflectionCall("MyClass1","myMethod1");

	}

}
