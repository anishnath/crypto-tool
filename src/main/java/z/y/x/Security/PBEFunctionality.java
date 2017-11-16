package z.y.x.Security;

import org.apache.commons.codec.binary.*;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.security.Security;
import java.util.*;

/**
 * 14 November 2017
 *
 * @author Anish Nath
 */
public class PBEFunctionality extends HttpServlet {

    /**
     *
     */
    private static final long serialVersionUID = 2920672118396887204L;
    static Map<String, byte[]> map = new HashMap<String, byte[]>();

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    private final String METHOD_NAME = "PBEBLOCK";
    private final String METHOD_NAME_PBE_MESSAGE ="PBEMESSAGE";

    private long maxFileSize = 1024 * 10 * 10;

    public static void main(String[] args) throws ServletException, IOException {
        new PBEFunctionality().doPost(null, null);
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        String msg = request.getParameter("uid");
       // System.out.println(msg);
        {
            if (msg != null && msg.length()>0) {
                try {
                    byte[] b = (byte[]) request.getSession().getAttribute(msg);
                    if(b!=null && b.length>0) {
                        response.setContentType("application/octet-stream");
                        response.setHeader("Content-disposition", "attachment; filename=" + msg);
                        OutputStream os = response.getOutputStream();
                        if (os != null) {
                            os.write(b);
                        }
                        os.flush();
                        os.close();
                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                    response.sendRedirect("redirect-pbefile.jsp");
                }

            }
        }

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        try {
            //PrintWriter out = response.getWriter();

            boolean isMultipart = ServletFileUpload.isMultipartContent(request);

            //System.out.println(isMultipart);

            String fName = "";


            if (isMultipart) {

                Map<String, Object> requestParameter = new HashMap<String, Object>();
                String md = "";
                // Create a new file upload handler
                ServletFileUpload upload = new ServletFileUpload(
                        getDiskFileFactory(request));

                boolean error = false;
                StringBuilder strbg = new StringBuilder();

                try {

                    List<FileItem> items = upload.parseRequest(request);
                    // Process the uploaded items
                    Iterator<FileItem> iter = items.iterator();
                    while (iter.hasNext()) {
                        FileItem item = iter.next();

                        // Process a file upload
                        if (!item.isFormField()) {
                            String fieldName = item.getFieldName();
                            fName = item.getName();
                            String contentType = item.getContentType();
                            boolean isInMemory = item.isInMemory();
                            long sizeInBytes = item.getSize();

                            //System.out.println(sizeInBytes);
                            if (sizeInBytes == 0) {
                                strbg.append("EMpty file !! Please Upload file for PBE encyption/decyption Max Size 10MB");
                                System.out.println("Here....");
                                error = true;


                            }
                            if (sizeInBytes < maxFileSize) {
                                requestParameter.put(fieldName, item);
                            } else {
                               // System.out.println("Here....22");
                                strbg.append("Only File Size of 10 MB Supported ");
                                error = true;


                            }

                        } else {
                            String name = item.getFieldName();
                            String value = item.getString();
                            requestParameter.put(name, value);
                            // System.out.println("name =" + name + " value =" + value);
                        }
                    } // end while

                } catch (Exception ex) {
                    session.setAttribute("msg","<font size=\"2\" color=\"red\"> System Error +" + ex.getMessage()+ " </font>");
                    response.sendRedirect("pbefile.jsp");
                    return;

                }

                if (error) {
                    response.setContentType("text/html");
                    //out.println("");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + strbg.toString() + " </font>");
                    response.sendRedirect("pbefile.jsp");
                    return;
                }

                String plainText = (String) requestParameter.get("plaintext");
                String rounds = (String) requestParameter.get("rounds");
                int rs = 100;
                try {
                    rs = Integer.parseInt(rounds);
                    if (rs > 5001) {
                        response.setContentType("text/html");
                        //out.println("");
                        session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Currenlty Only Supported upto 5000 round raise feature request </font>");
                        response.sendRedirect("pbefile.jsp");
                        return;
                    }
                } catch (NumberFormatException nfe) {
                    response.setContentType("text/html");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Valid Number of Rounds required in Integer </font>");
                    response.sendRedirect("pbefile.jsp");
                    //out.println("<font size=\"2\" color=\"red\"> A Valid Integer round required </font>");
                    return;
                }
                final String secret = (String) requestParameter.get("secretkey");

                if (secret == null || secret.trim().length() == 0) {
                    response.setContentType("text/html");
                    //out.println("");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Please privide the password for PBE encryption </font>");
                    response.sendRedirect("pbefile.jsp");
                    return;

                }


                String algo = (String) requestParameter.get("cipherparameter");
                final String methodName = (String) requestParameter.get("methodName");
                String encryptdecryptparameter = (String) requestParameter.get("encryptorDecrypt");
                final FileItem item = (FileItem) requestParameter.get("upfile");


                if (METHOD_NAME.equals(methodName)) {
                    System.out.println(plainText);
                    System.out.println(rounds);
                    System.out.println(secret);
                    System.out.println(algo);
                    System.out.println(methodName);
                    System.out.println(encryptdecryptparameter);


                    if ("encrypt".equals(encryptdecryptparameter)) {
                        byte[] b = PBEUtils.encryptFile(IOUtils.toByteArray(item.getInputStream()), secret, algo, rs);
                        if (b != null && b.length > 0) {
                            String msg = " <font size=\"4\" color=\"green\"> Successfully Encrypted file Name [" + fName + "] Encrypted Using Algo [" + algo + "] with round[" + rounds + "]</font>";
                            String uid = UUID.randomUUID().toString();
                            session.setAttribute("msg", msg);
                            session.setAttribute(uid, b);
                            session.setAttribute("downloadlink", uid);
                            response.sendRedirect("pbefile.jsp");
                            return;
                        } else {
                            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Error Occured Raise feature Request</font>");
                            response.sendRedirect("pbefile.jsp");
                            return;
                        }
                    }
                    if ("decrypt".equals(encryptdecryptparameter)) {
                        byte[] b = PBEUtils.decryptFile(item.getInputStream(), secret, algo, rs);
                        if (b != null && b.length > 0) {
                            System.out.println("-------");
                            String msg = " <font size=\"4\" color=\"green\"> Successfully Decrypted file Name [" + fName + "] Decrypted Using Algo [" + algo + "] with round[" + rounds + "]</font>";
                            String uid = UUID.randomUUID().toString();
                            session.setAttribute("msg", msg);
                            session.setAttribute(uid, b);
                            session.setAttribute("downloadlink", uid);
                            response.sendRedirect("pbefile.jsp");

                            return;
                        } else {
                            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> Error Occured Raise feature Request</font>");
                            response.sendRedirect("pbefile.jsp");
                            return;
                        }
                    }

                }


            }
        } catch (Exception e) {
            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> "+ e.getMessage() +" </font>");
            session.setAttribute("downloadlink", null);
            response.sendRedirect("pbefile.jsp");
            return;
        }

            String  mName= request.getParameter("methodName");

            if(METHOD_NAME_PBE_MESSAGE.equalsIgnoreCase(mName))
            {

                PrintWriter out = response.getWriter();


                String encryptdecryptparameter=request.getParameter("encryptdecryptparameter");
                String message = request.getParameter("message");
                String salt = request.getParameter("salt");
                String rounds = request.getParameter("rounds");
                String algo = request.getParameter("cipherparameter");
                int rs = 100;
                try {
                    rs = Integer.parseInt(rounds);
                    if (rs > 5001) {
                        out.println("Currenlty Only Supported upto 5000 round raise feature request");
                        return;
                    }
                } catch (NumberFormatException nfe) {
                    out.println("Valid Number of Rounds required in Integer ");
                    return;
                }
                String password = request.getParameter("password");

                if (password == null || password.trim().length() == 0) {
                    out.println("Please provide the password for PBE encryption ");
                    return;
                }

                if (message == null || message.trim().length() == 0) {
                    out.println("Please provide the message for PBE encryption ");
                    return;
                }

                if (salt == null || salt.trim().length() == 0) {
                    out.println("Minumium Salt length 8 Byte");
                    return;
                }

                if (salt != null && salt.trim().length() < 8 ) {
                    out.println("Salt Must be 8 byte Long ");
                    return;
                }

                if (salt != null && salt.trim().length() > 8 ) {
                    out.println("Salt Must be 8 byte Long ");
                    return;
                }

                try
                {

                if ("encrypt".equals(encryptdecryptparameter)) {
                    String sm = PBEUtils.encrypt(message,password,algo,rs,salt);
                    out.println(sm);
                    return;
                }

                //System.out.println("encryptdecryptparameter -- " + encryptdecryptparameter);
                if ("decryprt".equals(encryptdecryptparameter)) {

                    boolean isBase64 = org.apache.commons.codec.binary.Base64.isArrayByteBase64(message.getBytes());
                  //  System.out.println("isBase64 -- " + isBase64);
                    if (!isBase64) {
                        out.println("Please Provide Base64 Encoded value");
                        return;
                    }

                    String sm = PBEUtils.decrypt(message, password, algo, rs, salt);
                    out.println(sm);
                    return;
                }
                }catch (Exception ex)
                {
                    out.println("System Error " + ex.getMessage());
                }


                //Validations

            }

            }






    /**
     * @param request
     * @return
     */
    private DiskFileItemFactory getDiskFileFactory(HttpServletRequest request) {
        // Check that we have a file upload request

        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();

        // Configure a repository (to ensure a secure temp location is used)
        ServletContext servletContext = this.getServletConfig()
                .getServletContext();
        File repository = (File) servletContext
                .getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
        return factory;
    }

}
