package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.codec.binary.*;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import z.y.x.r.LoadPropertyFileFunctionality;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.ByteBuffer;
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



    private final String METHOD_NAME = "PBEBLOCK";
    private final String METHOD_NAME_PBE_MESSAGE ="PBEMESSAGE";

    private long maxFileSize = 1024 * 10 * 10 *10;

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
//                    System.out.println(plainText);
//                    System.out.println(rounds);
//                    System.out.println(secret);
//                    System.out.println(algo);
//                    System.out.println(methodName);
//                    System.out.println(encryptdecryptparameter);


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


                if(Utils.vaildate())
                {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> License Expired Request Fresh License </font>");
                    return;
                }


                String encryptdecryptparameter=request.getParameter("encryptdecryptparameter");
                String message = request.getParameter("message");
                String salt = request.getParameter("salt");
                String rounds = request.getParameter("rounds");
                String algo = request.getParameter("cipherparameter");
                int rs = 100;

//                    System.out.println(encryptdecryptparameter);
//                    System.out.println(message);
//                    System.out.println(salt);
//                    System.out.println(rounds);
//                    System.out.println(algo);


                try {
                    rs = Integer.parseInt(rounds);
                    if (rs > 20001) {
                        addHorizontalLine(out);
                        out.println("<font size=\"2\" color=\"red\"> Currenlty Only Supported upto 20000 round raise feature request </font>");
                        return;
                    }
                } catch (NumberFormatException nfe) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Valid Number of Rounds required in Integer </font>");
                    return;
                }
                String password = request.getParameter("password");

                if (password == null || password.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Please provide the password for PBE encryption </font>");
                    return;
                }

                if (message == null || message.trim().length() == 0) {
                    addHorizontalLine(out);
                    out.println("<font size=\"2\" color=\"red\"> Please provide the message for PBE encryption </font>");
                    return;
                }

                try
                {
                    String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") +  "pbe/encrypt";

                //System.out.println("encryptdecryptparameter -- " + encryptdecryptparameter);
                if ("decryprt".equals(encryptdecryptparameter)) {

                    String pattern = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$";
                    boolean isValidMessage = false;
                    if (message.matches(pattern)) {
                        isValidMessage = true;
                    }

                    if (!isValidMessage) {
                        try {
                            Long.parseLong(message, 16);
                            isValidMessage = true;
                        } catch (NumberFormatException ex) {
                            isValidMessage = false;
                        }
                    }
                    if (!isValidMessage) {
                        addHorizontalLine(out);
                        out.println("<font size=\"4\" color=\"red\"> For Decryption Please Base64 Message which is generated during encryption process [" + message + "]</font>");
                        return;
                    }

                    url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "pbe/decrypt";

                }



                final String[] cipherparameter = request.getParameterValues("cipherparameternew");

                Gson gson = new Gson();
                HttpClient client = HttpClientBuilder.create().build();

                HttpPost post = new HttpPost(url1);



                for(int i=0; i<cipherparameter.length; i++)
                {


                    List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
                    urlParameters.add(new BasicNameValuePair("p_msg", message));
                    urlParameters.add(new BasicNameValuePair("p_cipher", cipherparameter[i]));
                    urlParameters.add(new BasicNameValuePair("p_secretkey", password));
                    urlParameters.add(new BasicNameValuePair("p_rounds", String.valueOf(rs)));


                    post.setEntity(new UrlEncodedFormEntity(urlParameters));


                    post.addHeader("accept", "application/json");

                    HttpResponse response1 = client.execute(post);

                    if (response1.getStatusLine().getStatusCode() != 200) {
                        if (response1.getStatusLine().getStatusCode() == 404) {
                            BufferedReader br = new BufferedReader(
                                    new InputStreamReader(
                                            (response1.getEntity().getContent())
                                    )
                            );
                            StringBuilder content = new StringBuilder();
                            String line;
                            while (null != (line = br.readLine())) {
                                content.append(line);
                            }
                            addHorizontalLine(out);
                            StringBuilder stringBuilder = new StringBuilder();
                            stringBuilder.append(content);

                            out.println("<font size=\"4\" color=\"red\"> SYSTEM Error  " + stringBuilder + "</font>");
                            return;
                        } else {
                            addHorizontalLine(out);
                            out.println("<font size=\"4\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request </font>");
                            return;
                        }
                    }


                    BufferedReader br = new BufferedReader(
                            new InputStreamReader(
                                    (response1.getEntity().getContent())
                            )
                    );

                    StringBuilder content = new StringBuilder();
                    String line;
                    while (null != (line = br.readLine())) {
                        content.append(line);
                    }

                    EncodedMessage encodedMessage = gson.fromJson(content.toString(), EncodedMessage.class);
                    addHorizontalLine(out);
                    out.println("<font size=\"4\" color=\"purple\">Input Message [  " + message + "] </font> </br>");

                    out.println("<font size=\"4\" color=\"green\">Algo  "+  cipherparameter[i]  + " </font> </br>");

                    if (!"decryprt".equals(encryptdecryptparameter)) {
                        ByteBuffer buffer = ByteBuffer.wrap(new BASE64Decoder().decodeBuffer(encodedMessage.getMessage()));
                        byte[] saltBytes = new byte[8];
                        buffer.get(saltBytes, 0, saltBytes.length);
                        byte[] ivBytes1 = new byte[16];
                        buffer.get(ivBytes1, 0, ivBytes1.length);

                        String salt8bit = new BASE64Encoder().encode(saltBytes);
                        String iv16bit = new BASE64Encoder().encode(ivBytes1);

                        out.println("<font size=\"4\" color=\"red\"> Encrypted Message </font><font size=\"5\" color=\"green\">" + encodedMessage.getMessage() + " </font> </br>");
                        out.println("<font size=\"4\" color=\"blue\">8 bit salt used[  "+  salt8bit + "] </font> </br>");
                        out.println("<font size=\"4\" color=\"blue\">16 bit Initial Vector[  "+  iv16bit + "] </font> </br>");
                    }
                    else
                    {
                        out.println("<font size=\"4\" color=\"red\"> Decryped Message[</font> <font size=\"5\" color=\"green\"> " + encodedMessage.getMessage() + "]  </font> </br>");
                    }




                }
                }catch (Exception ex)
                {
                    addHorizontalLine(out);
                    out.println("System Error " + ex.getMessage());
                }


                //Validations

            }


            }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
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
