package security

import scala.collection.JavaConverters._

/**
 * @author ANish
 */
object javaConversion {
  
   def listAsJavaString(aliases: List[String]):java.util.List[String]=
  {
      aliases.asJava;
  }
  
  //The Converter do the scala to Java Converter for the List
  def listAsJavaObject(aliases: List[AnyRef]):java.util.List[Object]=
  {
      aliases.asJava;
  }
  
   //The Converter do the scala to Java Converter for the List
  def mapAsJavaObject(aliases: Map[String,AnyRef]):java.util.Map[String,Object]=
  {
      aliases.asJava;
  }
  
  //The Converter do the java to Scala Converter for the List
  def listAsScalaObject(aliases: java.util.List[String]):List[String]=
  {
      aliases.asScala.toList;
  }

}