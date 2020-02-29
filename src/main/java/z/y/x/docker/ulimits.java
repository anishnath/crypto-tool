package z.y.x.docker;

public class ulimits {
	
	private int nproc;
	private nofile nofile;
	public int getNproc() {
		return nproc;
	}
	public void setNproc(int nproc) {
		this.nproc = nproc;
	}
	public nofile getNofile() {
		return nofile;
	}
	public void setNofile(nofile nofile) {
		this.nofile = nofile;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((nofile == null) ? 0 : nofile.hashCode());
		result = prime * result + nproc;
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ulimits other = (ulimits) obj;
		if (nofile == null) {
			if (other.nofile != null)
				return false;
		} else if (!nofile.equals(other.nofile))
			return false;
		if (nproc != other.nproc)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "ulimits [nproc=" + nproc + ", " + (nofile != null ? "nofile=" + nofile : "") + "]";
	}
}
