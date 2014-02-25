package z.y.x.Network;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.util.List;

public class NetworkDiagnostics {
	private final String os = System.getProperty("os.name");

	public String traceRoute(InetAddress address) {
		String route = "";
		try {
			Process traceRt;
			if (os.contains("win"))
				traceRt = Runtime.getRuntime().exec(
						"tracert " + address.getHostAddress());
			else
				traceRt = Runtime.getRuntime().exec(
						"traceroute " + address.getHostAddress());

		} catch (Exception e) {
			System.out.println(e);
		}

		return route;
	}

	public static String doCommand(List<String> command)

	{
		StringBuilder builder = new StringBuilder();
		try {
			String s = null;

			ProcessBuilder pb = new ProcessBuilder(command);
			Process process = pb.start();

			BufferedReader stdInput = new BufferedReader(new InputStreamReader(
					process.getInputStream()));
			BufferedReader stdError = new BufferedReader(new InputStreamReader(
					process.getErrorStream()));

			// read the output from the command
			System.out.println("Here is the standard output of the command:\n"
					+ command.toString());
			while ((s = stdInput.readLine()) != null) {
				builder.append(s + "<br>");
				builder.append(System.getProperty("line.separator"));
			}

			// read any errors from the attempted command
			System.out
					.println("Here is the standard error of the command (if any):\n");
			while ((s = stdError.readLine()) != null) {
				builder.append(s + "<br>");
				builder.append(System.getProperty("line.separator"));
			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return builder.toString();
	}
}