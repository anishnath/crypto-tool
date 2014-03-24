package z.y.x.Security

import java.security.KeyStore
import java.io.ByteArrayInputStream
import sun.misc.BASE64Decoder
import sun.misc.BASE64Encoder
import scala.collection.immutable.Nil
import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import sun.security.x509.X509CertImpl

import collection.JavaConversions._
import scala.collection.JavaConverters._

/**
 * @author Anish Nath
 * JKS stands for Java KeyStore
 */
class JKS(byte: Array[Byte], val password: String) extends abstractJKS with JKSViewer {

  def theKeyStore = byte

  def listAllAliases(): List[String] = {
    var list: List[String] = Nil
    val en = store.aliases();
    while (en.hasMoreElements()) {
      val alias = en.nextElement();

      list = list ::: List(alias)
    }
    list;
  }

  def listByAlias(aliasName: String): Map[String, AnyRef] = {

    /*Scala map is a collection of key/value pairs.By default,
     Scala uses the immutable Map If you want to use the mutable Set, 
     you'll have to import scala.collection.mutable.Map class explicitly*/
    var map = Map[String, AnyRef]()

    val en = store.aliases();
    while (en.hasMoreElements()) {
      val alias = en.nextElement();
      if (aliasName.equals(alias)) {
        val cert = store.getCertificate(alias);
        
       
        //How to check for null or false in Scala concisely?
        cert match {
          case value => {
            /*
             * Add a key-value pair to a Map, we can use the operator + as follows
             */
            map += alias -> cert;

          }
        }
      }
    }
    map
  }

  def listByAliases(aliases: List[String]): Map[String, AnyRef] = {

    /*Scala map is a collection of key/value pairs.By default,
     Scala uses the immutable Map If you want to use the mutable Set, 
     you'll have to import scala.collection.mutable.Map class explicitly*/
    var map = Map[String, AnyRef]()
    var list: List[AnyRef] = Nil
    val en = store.aliases();
    while (en.hasMoreElements()) {
      val alias = en.nextElement();
      for (obj <- aliases) {
        if (obj.equals(alias)) {
          val cert = store.getCertificate(alias);
          //check for null or false in Scala concisely?
          cert match {
            case value => {
              /*
             * Add a key-value pair to a Map, we can use the operator + as follows
             */
              map += alias -> cert;

            }
          }

        }
      }
    }
    map
  }

  def listAllJks(): Map[String, AnyRef] = {

    /*Scala map is a collection of key/value pairs.By default,
     Scala uses the immutable Map If you want to use the mutable Set, 
     you'll have to import scala.collection.mutable.Map class explicitly*/
    var map = Map[String, AnyRef]()

    var list: List[AnyRef] = Nil
    val en = store.aliases();
    var ret = "";
    while (en.hasMoreElements()) {
      val alias = en.nextElement();
      val cert = store.getCertificate(alias);
      cert match {
        case value => {
          /*
             * Add a key-value pair to a Map, we can use the operator + as follows
             */
          map += alias -> cert;

        }
      }
    }
    map;
  }

}