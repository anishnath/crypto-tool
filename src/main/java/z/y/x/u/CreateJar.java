package z.y.x.u;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.jar.Attributes;
import java.util.jar.JarEntry;
import java.util.jar.JarOutputStream;
import java.util.jar.Manifest;

public class CreateJar {
	
	public static int BUFFER_SIZE = 10240;
	//Returns the Created Jar
	public String run(final String inputDirectory) throws IOException
	{
		 final String outputFileName = 	inputDirectory+File.separator+"output.jar";
		/*
	 
	  Manifest manifest = new Manifest();
	  manifest.getMainAttributes().put(Attributes.Name.MANIFEST_VERSION, "1.0");
	  JarOutputStream target = new JarOutputStream(new FileOutputStream(outputFileName), manifest);
	  add(new File(inputDirectory), target);
	  target.close();
	  return outputFileName;
	  */
		File[] fileList = new File(inputDirectory).listFiles();
		File f = new File(outputFileName);
		createJarArchive(f,fileList);
		return outputFileName;
	}

	private void add(File source, JarOutputStream target) throws IOException
	{
	  BufferedInputStream in = null;
	  try
	  {
	    if (source.isDirectory())
	    {
	      String name = source.getPath().replace("\\", "/");
	      if (!name.isEmpty())
	      {
	        if (!name.endsWith("/"))
	          name += "/";
	        JarEntry entry = new JarEntry(name);
	        entry.setTime(source.lastModified());
	        target.putNextEntry(entry);
	        target.closeEntry();
	      }
	      for (File nestedFile: source.listFiles())
	        add(nestedFile, target);
	      return;
	    }

	    JarEntry entry = new JarEntry(source.getPath().replace("\\", "/"));
	    entry.setTime(source.lastModified());
	    target.putNextEntry(entry);
	    in = new BufferedInputStream(new FileInputStream(source));

	    byte[] buffer = new byte[1024];
	    while (true)
	    {
	      int count = in.read(buffer);
	      if (count == -1)
	        break;
	      target.write(buffer, 0, count);
	    }
	    target.closeEntry();
	  }
	  finally
	  {
	    if (in != null)
	      in.close();
	  }
	}
	
	static protected void createJarArchive(File archiveFile, File[] tobeJared) {
		
	    try {
	      byte buffer[] = new byte[BUFFER_SIZE];
	      // Open archive file
	      FileOutputStream stream = new FileOutputStream(archiveFile);
	      JarOutputStream out = new JarOutputStream(stream, new Manifest());

	      for (int i = 0; i < tobeJared.length; i++) {
	        if (tobeJared[i] == null || !tobeJared[i].exists()
	            || tobeJared[i].isDirectory())
	          continue; // Just in case...
	        System.out.println("Adding " + tobeJared[i].getName());

	        // Add archive entry
	        JarEntry jarAdd = new JarEntry(tobeJared[i].getName());
	        jarAdd.setTime(tobeJared[i].lastModified());
	        out.putNextEntry(jarAdd);

	        // Write file to archive
	        FileInputStream in = new FileInputStream(tobeJared[i]);
	        while (true) {
	          int nRead = in.read(buffer, 0, buffer.length);
	          if (nRead <= 0)
	            break;
	          out.write(buffer, 0, nRead);
	        }
	        in.close();
	      }

	      out.close();
	      stream.close();
	      System.out.println("Adding completed OK");
	    } catch (Exception ex) {
	      ex.printStackTrace();
	      System.out.println("Error: " + ex.getMessage());
	    }
	  }

}
