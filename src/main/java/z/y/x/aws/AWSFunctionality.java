package z.y.x.aws;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import z.y.x.aws.ec2.secgroup.SecurityGroupGen;

public class AWSFunctionality extends HttpServlet {

	private static final long serialVersionUID = 2L;
	private static final String METHOD_GENERATE_AWS_CONFIG = "GENERATE_AWS_CONFIG";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		final String methodName = request.getParameter("methodName");

		PrintWriter out = response.getWriter();

		// System.out.println("methodName" + methodName);

		if (METHOD_GENERATE_AWS_CONFIG.equals(methodName)) {

			String region = request.getParameter("region");
			String accessKey = request.getParameter("access_key");
			String secretKey = request.getParameter("secret_key");
			String sg = request.getParameter("filter");
			String aws_resource = request.getParameter("aws_resource");
			String[] groupIds = null;

			if (null == region || region.trim().length() == 0) {
				region = "us-west-2";
			}

			if (null == sg || sg.trim().length() == 0) {
				groupIds = new String[] {};
			} else {
				groupIds = sg.split("\\s*,\\s*");
			}

			if (null == accessKey || accessKey.trim().length() == 0) {
				addHorizontalLine(out);
				out.println("<font size=\"4\" color=\"red\"> AWS_ACCESS_KEY can't be null </font>");
				return;
			}

			if (null == secretKey || secretKey.trim().length() == 0) {
				addHorizontalLine(out);
				out.println("<font size=\"4\" color=\"red\"> AWS_SECRET_KEY can't be null </font>");
				return;
			}
			
			if("security_group".equals(aws_resource))
			{
				SecurityGroupGen securityGroupGen = new SecurityGroupGen();

				try {
					String ansible = securityGroupGen.getSecurityGroup(accessKey, secretKey, region, groupIds);
					out.println("<h5 class=\"mt-4\">Ansible </h5>");
					out.println(
							"<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=30  form=\"X\">"
									+ ansible + "</textarea>");
					return;
				} catch (Exception e) {
					addHorizontalLine(out);
					out.println("<font size=\"4\" color=\"red\"> " + e.getMessage() + " </font>");
					return;
				}
			}
			else {
				addHorizontalLine(out);
				out.println("<font size=\"4\" color=\"red\"> For time Being Only work on AWS Security Group we are bringing this capablity to other resources </font>");
				return;
			}

		}

	}

	private void addHorizontalLine(PrintWriter out) {
		out.println("<hr>");
	}
}
