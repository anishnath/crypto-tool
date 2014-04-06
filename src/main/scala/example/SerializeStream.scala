package example

object SerializeStream {

  def ser[T](s: Stream[T]) {
    val bos = new java.io.ByteArrayOutputStream()
    val oos = new java.io.ObjectOutputStream(bos)
    oos.writeObject(s)

    val ois = new java.io.ObjectInputStream(new java.io.ByteArrayInputStream(bos.toByteArray))
    val obj = ois.readObject()
    println(obj)
    println(obj.asInstanceOf[Seq[T]].toList)
  }

  def main(args: Array[String]) {
    /**
     * The class Stream implements lazy lists where 
     * elements are only evaluated when they are needed
     */
    ser(Stream(1, 2, 3))
    ser(Stream(1))
    ser(Stream())
  }

}