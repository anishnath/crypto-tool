package security

import java.security.KeyStore
import java.io.ByteArrayInputStream
import sun.misc.BASE64Encoder;
import z.y.x.Security.PemParser

object JKSStore {
  
   def listCertificate(certificateName:String){
     
   }
  
   def listAll():List[AnyRef] = {
     val days = List("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
     
     val cache = collection.mutable.Map[String, String]()
     cache.put("1", "1")
     
     return days;
   }
  
  //convert a Java byte array into a Scala byte array?
  //In Java displayKeytore(byte[] theKeyStore)
  def displayKeytore(theKeyStore: Array[Byte], password :String):String = {
     
    
	 val store = KeyStore.getInstance("JKS");
     val temp = new ByteArrayInputStream(theKeyStore);
     
    // store.store(x$1, x$2)
     store.load(temp, null)
     
     val en = store.aliases();
     var ret="";
      val pemParser = new PemParser();
        while (en.hasMoreElements())
        {
            val alias = en.nextElement();
            
            ret = "found " + alias + ", isCertificate? " + store.isCertificateEntry(alias);
            
            println(ret + " " +store.getType());
            val cert =  store.getCertificate(alias);
            val i = "-----BEGIN CERTIFICATE-----\n" + new BASE64Encoder().encode(cert.getEncoded()) + "\n" + "-----END CERTIFICATE-----"
       		ret = pemParser.parsePemFile(i, password);
            println(ret);
          // println( cert)
            
        }
        
        return ret;
        
        
  }
  //How to read a file as a byte array in Scala
  val source = scala.io.Source.fromFile("/tmp/keytool/keystore.jks", "ISO-8859-1")
  val byteArray = source.map(_.toByte).toArray
  source.close()
 JKSStore.displayKeytore(byteArray, "111111")

}