
package z.y.x.Security;
import java.security.Provider;
import java.security.Security;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class ListAlgorithms
{
    /**
     * Print out the set entries, indented, one per line, with the name of the set
     * unindented appearing on the first line.
     * 
     * @param setName the name of the set being printed
     * @param algorithms the set of algorithms associated with the given name
     * @return 
     */
    public static String printSet(
        String setName,
        Set	   algorithms)
    {
    		StringBuilder builder = new StringBuilder();
       // System.out.println(setName + ":");
    		 builder.append("<center><table  border=\"10\">");
        builder.append(setName);
        builder.append(":");
        builder.append("\n");
        
        if (algorithms.isEmpty()) 
        {
            System.out.println("            None available.");
        }
        else
        {
            Iterator	it = algorithms.iterator();
            
            while (it.hasNext())
            {
                String	name = (String)it.next();
                builder.append("<tr bordercolor=\"red\"><td>");
                //System.out.println("            " + name);
                builder.append("                 ");
                builder.append(name);
               // builder.append("\n");
                builder.append("</tr></td>");
                
                
            }
        }
        builder.append("</center></table>");
       return builder.toString();
    }
    
	/**
	 * List the available algorithm names for ciphers, key agreement, macs,
	 * message digests and signatures.
	 */
    public static void main(
        String[]    args)
    {
    	 
        System.out.println(addToListAlgoSet("Signatures"));
    }

    public static String addToListAlgoSet(final String what ) {
		Provider[]	providers = Security.getProviders();
        Set			ciphers = new HashSet();
        Set			keyAgreements = new HashSet();
        Set			macs = new HashSet();
        Set			messageDigests = new HashSet();
        Set			signatures = new HashSet();
        
        for (int i = 0; i != providers.length; i++)
        {
            Iterator  it = providers[i].keySet().iterator();
            
            while (it.hasNext())
            {
                String	entry = (String)it.next();
                
                if (entry.startsWith("Alg.Alias."))
                {
                    entry = entry.substring("Alg.Alias.".length());
                }
                
                if (entry.startsWith("Cipher."))
                {
                    ciphers.add(entry.substring("Cipher.".length()));
                }
                else if (entry.startsWith("KeyAgreement."))
                {
                    keyAgreements.add(entry.substring("KeyAgreement.".length()));
                }
                else if (entry.startsWith("Mac."))
                {
                    macs.add(entry.substring("Mac.".length()));
                }
                else if (entry.startsWith("MessageDigest."))
                {
                    messageDigests.add(entry.substring("MessageDigest.".length()));
                }
                else if (entry.startsWith("Signature."))
                {
                    signatures.add(entry.substring("Signature.".length()));
                }
            }
        }
        
        if("all".equalsIgnoreCase(what) || what==null)
        {
        	StringBuilder builder = new StringBuilder();
        		builder.append(printSet("Ciphers", ciphers));
        		builder.append( printSet("KeyAgreeents", keyAgreements));
        		builder.append( printSet("Macs", macs));
        		builder.append( printSet("MessageDigests", messageDigests));
        		builder.append( printSet("Signatures", signatures));
        		return builder.toString();
        }
        
        if(what.contains("Ciphers"))
        {
        		return printSet("Ciphers", ciphers);
        }
        if(what.contains("KeyAgreeents"))
        {
        	return printSet("KeyAgreeents", ciphers);
        }
        if(what.contains("Macs"))
        {
        	return printSet("Macs", ciphers);
        }
        if(what.contains("MessageDigests"))
        {
        	return	printSet("MessageDigests", ciphers);
        }
        if(what.contains("Signatures"))
        {
        	return	printSet("Signatures", ciphers);
        }
		return what;
       
	}
}
