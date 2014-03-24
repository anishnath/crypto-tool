package security
import java.io.IOException
import security.JKS

object Test1 {

  def main(args: Array[String]) {
    println("Hello, world!")

    // val t  = JKSStore
    //val holidays = t.listAll.asInstanceOf[List[AnyRef]];
    //for (name <- t.listAll) println(name)

    //println(t.listAll.for)

    try {
      val source = scala.io.Source.fromFile("/tmp/keytool/keystore.jks", "ISO-8859-1")
      val byteArray = source.map(_.toByte).toArray
      source.close()
      val jks = new JKS(byteArray,"password");

      //val jks = new JKS("/tmp/keytool/keystore.jks","password");
       for (obj <- jks.listAllAliases) println(obj)
      //for (obj <- jks.listAllJks) println(obj)
      // println(jks.listByAlias("root"))
      //for (obj <- jks.listByAlias("root")) println(obj)
      // val days = List("root", "domainname", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
      // for (obj <- jks.listByAliases(days)) println(obj)

    } catch {

      case e: IllegalArgumentException => println("illegal arg. exception");
      case e: IllegalStateException => println("illegal state exception");
      case e: IOException => println("IO exception" + e.getMessage());

    }

    //  for (obj <- jks.listAllJks) println(obj)

  }

}