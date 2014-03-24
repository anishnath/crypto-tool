package z.y.x.scalaExample
object MultipleConstructors  {
  
  def main(args: Array[String]) {

    // (1) use the primary constructor
    val al = new Person("Alvin", "Alexander", 20).asInstanceOf[Person]
    println(al)

    // (2) use a secondary constructor
    val fred = new Person("Fred", "Flinstone")
    println(fred)

    // (3) use a secondary constructor
    val barney = new Person("Barney")
    println(barney)

  }

}