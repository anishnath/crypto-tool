package z.y.x.u;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

/*
 * ANish Nath
 * The File Utility Class
 */
public class FileUtils {
	
	public static void createDirectory(final String PathToDirectory)
	{
		System.out.println("PathToDirectory " + PathToDirectory);
		new File(PathToDirectory).mkdirs();
	}
	
	public static final String fileToString(final String fileName) throws IOException
	{
		BufferedReader br = new BufferedReader(new FileReader(fileName));
	    try {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            System.out.println(sb);
	            line = br.readLine();
	        }
	        String everything = sb.toString();
	        return everything;
	    } finally {
	        br.close();
	    }
	}
	
	public static final String writeFile(final String fileName, final String fileContent,final String directoryLocation) throws FileNotFoundException, UnsupportedEncodingException 
	{
		final String outputFile=directoryLocation+File.separator+fileName;
		System.out.println("outputFile  " +outputFile);
		PrintWriter writer = new PrintWriter(outputFile, "UTF-8");
		writer.println(fileContent);
		writer.close();
		return outputFile;
	}

}
