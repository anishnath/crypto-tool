package example

trait A1 {
  lazy val z1 = {
    Stream
    println("<forced z1>")
    "lazy z1"
  }
}