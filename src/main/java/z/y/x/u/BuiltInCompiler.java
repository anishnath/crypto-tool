package z.y.x.u;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URI;
import java.util.Arrays;

import javax.tools.Diagnostic;
import javax.tools.DiagnosticCollector;
import javax.tools.JavaCompiler;
import javax.tools.JavaCompiler.CompilationTask;
import javax.tools.JavaFileObject;
import javax.tools.SimpleJavaFileObject;
import javax.tools.StandardJavaFileManager;
import javax.tools.StandardLocation;
import javax.tools.ToolProvider;

import z.y.x.e.NotCompiledException;

/**
 * @author Anish Nath
 * 
 */
public class BuiltInCompiler {

	public static void doCompile(final String fileName,
			final String fileContent, final String path) throws IOException,
			NotCompiledException {
		JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
		DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<JavaFileObject>();
		StandardJavaFileManager fileManager = compiler.getStandardFileManager(
				diagnostics, null, null);

		// Specfiy the OutPut Location
		fileManager.setLocation(StandardLocation.CLASS_OUTPUT,
				Arrays.asList(new File(path)));

		JavaFileObject file = new JavaSourceFromString(fileName, fileContent);

		Iterable<? extends JavaFileObject> compilationUnits = Arrays
				.asList(file);
		CompilationTask task = compiler.getTask(null, fileManager, diagnostics,
				null, null, compilationUnits);

		boolean success = task.call();
		StringBuilder builder = new StringBuilder();
		for (Diagnostic diagnostic : diagnostics.getDiagnostics()) {
			System.out.println(diagnostic.getCode());
			System.out.println(diagnostic.getKind());
			System.out.println(diagnostic.getPosition());
			System.out.println(diagnostic.getStartPosition());
			System.out.println(diagnostic.getEndPosition());
			System.out.println(diagnostic.getSource());
			System.out.println(diagnostic.getMessage(null));
			builder.append(diagnostic.getMessage(null));

		}
		System.out.println("Success: " + success);

		if (!success) {
			throw new NotCompiledException("Cannot Compile"
					+ builder.toString());
		}

	}

	public static void reflectionCall(final String className,
			final String methodName) {
		ClassLoader classLoader = BuiltInCompiler.class.getClassLoader();
		try {
			Class aClass = classLoader.loadClass(className);

			Constructor[] constructor = aClass.getDeclaredConstructors();
			System.out.println(constructor.length);
			Object t = null;
			// TODO NOT BUG Free we have to rely on only one Constructor
			for (int i = 0; i < constructor.length; i++) {
				System.out.println("MyCons ==" + constructor[i]);
				constructor[i].setAccessible(true);
				t = constructor[i].newInstance(null);
				System.out.println("aClass.getName() = " + aClass.getName());
				Method method = aClass.getDeclaredMethod(methodName,null);
				System.out.println(method.getName());
				method.setAccessible(true);
				method.invoke(t, null);
				break;
			}

			// t = aClass.newInstance();

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		try {
			File file = new File("/Users/aninath/Documents/Junl");
			String fileContent = FileUtils
					.fileToString("/Users/aninath/Documents/Junl/MyClass.java");

			BuiltInCompiler.doCompile("sa", fileContent,
					"/Users/aninath/Documents/Junl");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NotCompiledException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

class JavaSourceFromString extends SimpleJavaFileObject {
	final String code;

	JavaSourceFromString(String name, String code) {
		super(URI.create("string:///" + name.replace('.', '/')
				+ Kind.SOURCE.extension), Kind.SOURCE);
		this.code = code;
	}

	@Override
	public CharSequence getCharContent(boolean ignoreEncodingErrors) {
		return code;
	}

}
