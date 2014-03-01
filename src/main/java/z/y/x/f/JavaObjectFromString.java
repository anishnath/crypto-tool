package z.y.x.f;

import java.io.IOException;
import java.net.URI;

import javax.tools.SimpleJavaFileObject;

public class JavaObjectFromString extends SimpleJavaFileObject {
	private String contents = null;

	protected JavaObjectFromString(URI uri, Kind kind) {
		super(uri, kind);
		// TODO Auto-generated constructor stub
	}

	public JavaObjectFromString(URI uri, Kind kind, String contents) {
		super(uri, kind);
		this.contents = contents;
	}

	public JavaObjectFromString(String className, String contents)
			throws Exception {
		super(new URI(className), Kind.SOURCE);
		this.contents = contents;
	}

	public CharSequence getCharContent(boolean ignoreEncodingErrors)
			throws IOException {
		return contents;
	}

}
