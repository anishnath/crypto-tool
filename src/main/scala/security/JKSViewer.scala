package security

import scala.collection.immutable.List
import scala.collection.JavaConverters._

/**
 * @author  Anish
 */
trait JKSViewer {

  /**
   * @return collection.mutable.Map[String, List]()
   */
  def listByAlias(aliasName: String): Map[String, AnyRef]

  /**
   * @return collection.mutable.Map[String, List]()
   */
  def listByAliases(aliases: List[String]): Map[String, AnyRef]

  /**
   * @return  Map
   */
  def listAllJks(): Map[String, AnyRef]

  /**
   * @return List of The String
   */
  def listAllAliases(): List[String]

  //The Converter do the scala to Java Converter for the List
  def listAsJava(aliases: List[AnyRef]): java.util.List[Object] =
    {
      aliases.asJava;
    }

  def aliasExport(aliasName: String): Map[String, AnyRef]

}