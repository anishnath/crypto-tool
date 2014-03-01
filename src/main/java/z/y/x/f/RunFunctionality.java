package z.y.x.f;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import z.y.x.u.AddToClassPath;
import z.y.x.u.BuiltInCompiler;
import z.y.x.u.CreateJar;
import z.y.x.u.FileUtils;


/**
 * @author Anish nAth Servlet implementation class RunFunctionality
 *         "This Servelt Will run the User Programs what they have Supplied, This Is going to big Design in the Servlet and always have room for Improvement"
 *         , urlPatterns = { "/sdfsd" })
 */
public class RunFunctionality extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final CreateJar createJar = new CreateJar();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RunFunctionality() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		try {
  

			StringBuilder builder = new StringBuilder();
		  
		    builder.append("public class MyClass1 {");
		    builder.append("public  MyClass1() {}");
		    builder.append("public  void myMethod1() {System.out.println(\"My Method Called\");}");
		    builder.append("  public static void main(String args[]) {");
		    builder.append("    System.out.println(\"This is in another java file\");");    
		    builder.append("  }");
		    builder.append("}");
		   
		    System.out.println(builder.toString());
			
			Enumeration e =  (Enumeration)getServletContext().getAttributeNames();
			
			while(e.hasMoreElements()){
				String param = (String) e.nextElement();
				System.out.println(param);
				//System.out.println(getServletContext().getAttribute(param));
				}
			
			
			
			System.out.println(getServletContext().getAttribute("javax.servlet.context.tempdir"));
			
			String sp =String.valueOf(getServletContext().getAttribute("javax.servlet.context.tempdir"));
			sp=sp+File.separator+"tmp";
			FileUtils.createDirectory(sp); 
			
			System.out.println("SP == " + sp);

			BuiltInCompiler.doCompile("MyClass1",builder.toString(), sp);

			//Create the Jar
			final String jarName =  createJar.run(sp);
			
			//Add to the ClassPath
			AddToClassPath.addFile(jarName);
			
			//Test the Class
			BuiltInCompiler.reflectionCall("MyClass1","myMethod1");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	
}
