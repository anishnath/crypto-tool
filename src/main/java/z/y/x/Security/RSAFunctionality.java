package z.y.x.Security;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.KeyPair;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import org.apache.commons.codec.binary.Base64;

/**
 * Created by ANish Nath on 11/7/17.
 */
public class RSAFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String METHOD_CALCULATERSA = "CALCULATE_RSA";


    static {
        Security.addProvider(new BouncyCastleProvider());
    }


    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        //out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");


        String keysize = request.getParameter("keysize");
        if(keysize!=null&& keysize.trim().length()>0)
        {
            try {
                KeyPair kp = RSAUtil.generateKey(Integer.parseInt(keysize));
                String pubKey = RSAUtil.encodeBASE64(kp.getPublic().getEncoded());
                String privKey = RSAUtil.encodeBASE64(kp.getPrivate().getEncoded());

                request.getSession().setAttribute("pubkey", pubKey);
                request.getSession().setAttribute("privKey", privKey);
                request.getSession().setAttribute("keysize", keysize);
                String nextJSP = "/rsafunctions.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);


                return;
            }catch (Exception ex )
            {
                //DO NOTHING
            }
        }
        //System.out.println(keysize);
       // System.out.println("asdas");

    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        //System.out.println("algo" + algo);
        PrintWriter out = response.getWriter();


        String publiKeyParam = request.getParameter("publickeyparam");
        String privateKeParam = request.getParameter("privatekeyparam");
        final String message = request.getParameter("message");
        final String algo = request.getParameter("cipherparameter");
        final String methodName = request.getParameter("methodName");
        String keysize = request.getParameter("keysize");
        String encryptdecryptparameter = request.getParameter("encryptdecryptparameter");


                //

//        System.out.println("publiKeyParam " + publiKeyParam);
//        System.out.println("privateKeParam " + privateKeParam);
//        System.out.println("message " + message);
//        System.out.println("algo " + algo);
//        System.out.println("keysize " + keysize);
//        System.out.println("encryptdecryptparameter " + encryptdecryptparameter);
//        System.out.println("methodName " + methodName);


        if (METHOD_CALCULATERSA.equalsIgnoreCase(methodName)) {


            if ("encrypt".equals(encryptdecryptparameter)) {

                if (publiKeyParam != null && publiKeyParam.trim().length() > 0) {
                    publiKeyParam = publiKeyParam.replace("-----BEGIN PUBLIC KEY-----\n", "");
                    publiKeyParam = publiKeyParam.replace("-----END PUBLIC KEY-----", "");

                    try {
                        PublicKey publicKeyObj = RSAUtil.getPublicKeyFromString(publiKeyParam);
                        String encryptedMessage =  RSAUtil.encrypt(message,publicKeyObj,algo);
                        out.println(encryptedMessage);
                    } catch (Exception e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + e );
                    }

                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + " Public Key Can't be EMPTY </font>");

                }
            }
            else {
                if (privateKeParam != null && privateKeParam.trim().length() > 0) {

                    boolean isBase64 = Base64.isArrayByteBase64(message.getBytes());
                    if(!isBase64)
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + "Please Provide Base64 Encoded value" );
                        return;
                    }

                    privateKeParam = privateKeParam.replace("-----BEGIN PRIVATE KEY-----\n", "");
                    privateKeParam = privateKeParam.replace("-----END PRIVATE KEY-----", "");

                    try{
                        PrivateKey privatekeyObj = RSAUtil.getPrivateKeyFromString(privateKeParam);
                        String decryptMessage =  RSAUtil.decrypt(message,privatekeyObj,algo);
                        out.println(decryptMessage);

                    }catch (Exception e)
                    {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> " + e );
                    }


                } else {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> " + algo + " Public Key Can't be EMPTY </font>");
                }
            }
        }

    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }


}
