package security
import java.io.ByteArrayInputStream
import java.security.KeyStore

abstract class abstractJKS {
  
  def theKeyStore: Array[Byte];
  
 
   // val source = scala.io.Source.fromFile(inputFile, "ISO-8859-1")
    //val theKeyStore = source.map(_.toByte).toArray
    //source.close()
  	@throws[Exception]("if the file doesn't exist")
    val temp = new ByteArrayInputStream(theKeyStore);
    val store = KeyStore.getInstance("JKS");
    store.load(temp, null)
    
    
  
    
}