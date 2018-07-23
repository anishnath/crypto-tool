package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.HttpClientBuilder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.security.KeyPair;
import java.security.Security;
import java.util.*;

/**
 * Created by ANish Nath on 11/7/17.
 */
public class DSAFunctionality extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String METHOD_CALCULATEDSA = "CALCULATE_DSA";

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    private long maxFileSize = 1024 * 10 * 10 * 10;

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
        if (keysize != null && keysize.trim().length() > 0) {
            try {
                KeyPair kp = RSAUtil.generateKey("DSA",Integer.parseInt(keysize));
//                String pubKey = RSAUtil.encodeBASE64(kp.getPublic().getEncoded());
//                String privKey = RSAUtil.encodeBASE64(kp.getPrivate().getEncoded());


                request.getSession().setAttribute("pubkey", RSAUtil.toPem(kp.getPublic()));
                request.getSession().setAttribute("privKey", RSAUtil.toPem(kp));
                request.getSession().setAttribute("keysize", keysize);
                String nextJSP = "/dsafunctions.jsp";
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
                dispatcher.forward(request, response);


                return;
            } catch (Exception ex) {
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


        HttpSession session = request.getSession(true);

        String path = System.getProperty("java.io.tmpdir");
        String filefullPath = path + "/" + UUID.randomUUID().toString();
        String signaturefullPath = path + "/" + UUID.randomUUID().toString();




        File fileFullPath = new File(filefullPath);
        File sigfilefullPath = new File(signaturefullPath);

        try {
            //PrintWriter out = response.getWriter();

            boolean isMultipart = ServletFileUpload.isMultipartContent(request);



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


                            if(!"sigfile".equals(fieldName)) {

                                if (sizeInBytes == 0) {
                                    strbg.append("EMpty file !!  Max Size 10MB Supported");
                                    System.out.println("Here....");
                                    error = true;


                                }
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
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> System Error +" + ex.getMessage() + " </font>");
                    response.sendRedirect("dsafunctions.jsp");
                    return;

                }

                if (error) {
                    response.setContentType("text/html");
                    //out.println("");
                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + strbg.toString() + " </font>");
                    response.sendRedirect("dsafunctions.jsp");
                    return;
                }


                String publickeyparam = (String) requestParameter.get("publickeyparam");
                String privatekeyparam = (String) requestParameter.get("privatekeyparam");
                final String methodName = (String) requestParameter.get("methodName");
                String cipherparameter = (String) requestParameter.get("encryptdecryptparameter");
                String encryptdecryptparameter = (String) requestParameter.get("cipherparameter");
                final FileItem item = (FileItem) requestParameter.get("upfile");
                final FileItem sigfile = (FileItem) requestParameter.get("sigfile");



                if (METHOD_CALCULATEDSA.equals(methodName)) {

                    if("encrypt".equals(cipherparameter))
                    {

                        if (privatekeyparam.contains("BEGIN DSA PRIVATE KEY") && privatekeyparam.contains("END DSA PRIVATE KEY")) {



                            OutputStream outStream = new FileOutputStream(fileFullPath);
                            IOUtils.copy(item.getInputStream(), outStream);
                            outStream.close();

                            Gson gson = new Gson();
                            HttpClient client = HttpClientBuilder.create().build();
                            String url1 = "http://localhost:8080/crypto/rest/dsa/sign";
                            HttpPost post = new HttpPost(url1);


                            FileBody uploadFilePart = new FileBody(fileFullPath);
                            StringBody stringBody  = new StringBody(privatekeyparam);
                            StringBody stringBody1  = new StringBody(encryptdecryptparameter);


                            MultipartEntity reqEntity = new MultipartEntity();
                            reqEntity.addPart("p_file", uploadFilePart);
                            reqEntity.addPart("p_key", stringBody);
                            reqEntity.addPart("p_algo", stringBody1);

                            post.setEntity(reqEntity);



                            HttpResponse response1 = client.execute(post);




                            if (response1.getStatusLine().getStatusCode() != 200) {
                                if (response1.getStatusLine().getStatusCode() == 404) {
                                    BufferedReader br1 = new BufferedReader(
                                            new InputStreamReader(
                                                    (response1.getEntity().getContent())
                                            )
                                    );
                                    StringBuilder content1 = new StringBuilder();
                                    String line;
                                    while (null != (line = br1.readLine())) {
                                        content1.append(line);
                                    }

                                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + content1 + " </font>");
                                    request.getSession().setAttribute("pubkey", publickeyparam);
                                    request.getSession().setAttribute("privKey", privatekeyparam);
                                    response.sendRedirect("dsafunctions.jsp");

                                    return;
                                } else {
                                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request</font>");
                                    request.getSession().setAttribute("pubkey", publickeyparam);
                                    request.getSession().setAttribute("privKey", privatekeyparam);
                                    response.sendRedirect("dsafunctions.jsp");

                                }

                            }

                            InputStream in = response1.getEntity().getContent();

                            response.setContentType("text/plain");
                            response.setHeader("Content-Disposition",
                                    "attachment;filename=" + item.getName() + ".sig");
                            ServletContext ctx = getServletContext();

                            int read=0;
                            byte[] bytes = new byte[1024];
                            OutputStream os = response.getOutputStream();

                            while((read = in.read(bytes))!= -1){
                                os.write(bytes, 0, read);
                            }
                            os.flush();
                            os.close();

                           return;




                        }
                        else {
                            response.setContentType("text/html");
                            //out.println("");
                            strbg.append("For File Signing Provide a valid DSA Private Key Start with  -----BEGIN DSA PRIVATE KEY----- Ends With -----END DSA PRIVATE KEY----- ");
                            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + strbg.toString() + " </font>");

                            request.getSession().setAttribute("pubkey", publickeyparam);
                            request.getSession().setAttribute("privKey", privatekeyparam);


                            response.sendRedirect("dsafunctions.jsp");
                            return;
                        }

                    }
                    if("decryprt".equals(cipherparameter))
                    {
                        if (publickeyparam.contains("BEGIN PUBLIC KEY") && publickeyparam.contains("END PUBLIC KEY")) {



                            OutputStream outStream = new FileOutputStream(fileFullPath);
                            IOUtils.copy(item.getInputStream(), outStream);
                            outStream.close();



                            OutputStream outStream1 = new FileOutputStream(signaturefullPath);
                            IOUtils.copy(sigfile.getInputStream(), outStream1);
                            outStream1.close();



                            Gson gson = new Gson();
                            HttpClient client = HttpClientBuilder.create().build();
                            String url1 = "http://localhost:8080/crypto/rest/dsa/verify";
                            HttpPost post = new HttpPost(url1);



                            FileBody uploadFilePart = new FileBody(fileFullPath);
                            FileBody uploadFilePart2 = new FileBody(sigfilefullPath);
                            StringBody stringBody  = new StringBody(publickeyparam);
                            StringBody stringBody1  = new StringBody(encryptdecryptparameter);


                            MultipartEntity reqEntity = new MultipartEntity();
                            reqEntity.addPart("p_file", uploadFilePart);
                            reqEntity.addPart("p_sig", uploadFilePart2);
                            reqEntity.addPart("p_key", stringBody);
                            reqEntity.addPart("p_algo", stringBody1);

                            post.setEntity(reqEntity);



                            HttpResponse response1 = client.execute(post);




                            if (response1.getStatusLine().getStatusCode() != 200) {
                                if (response1.getStatusLine().getStatusCode() == 404) {
                                    BufferedReader br1 = new BufferedReader(
                                            new InputStreamReader(
                                                    (response1.getEntity().getContent())
                                            )
                                    );
                                    StringBuilder content1 = new StringBuilder();
                                    String line;
                                    while (null != (line = br1.readLine())) {
                                        content1.append(line);
                                    }

                                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + content1 + " </font>");
                                    request.getSession().setAttribute("pubkey", publickeyparam);
                                    request.getSession().setAttribute("privKey", privatekeyparam);
                                    response.sendRedirect("dsafunctions.jsp");

                                    return;
                                } else {
                                    session.setAttribute("msg", "<font size=\"2\" color=\"red\"> SYSTEM Error Please Try Later If Problem Persist raise the feature request</font>");
                                    request.getSession().setAttribute("pubkey", publickeyparam);
                                    request.getSession().setAttribute("privKey", privatekeyparam);
                                    response.sendRedirect("dsafunctions.jsp");

                                }

                            }

                            BufferedReader br1 = new BufferedReader(
                                    new InputStreamReader(
                                            (response1.getEntity().getContent())
                                    )
                            );

                            StringBuilder content1 = new StringBuilder();
                            String line;
                            while (null != (line = br1.readLine())) {
                                content1.append(line);
                            }


                            response.setContentType("text/html");
                            if(content1.toString().contains("Succeeded"))
                            {
                                session.setAttribute("msg", "<font size=\"4\" color=\"green\"> " + content1 + " </font>");
                            }
                            else {
                                session.setAttribute("msg", "<font size=\"4\" color=\"red\"> " + content1 + " </font>");
                            }

                            request.getSession().setAttribute("pubkey", publickeyparam);
                            request.getSession().setAttribute("privKey", privatekeyparam);
                            response.sendRedirect("dsafunctions.jsp");

                            return;


                        }
                        else {

                            response.setContentType("text/html");
                            //out.println("");
                            strbg.append("For File Signing Provide a valid DSA Public Key  -----BEGIN PUBLIC KEY-----  Ends with -----END PUBLIC KEY-----");
                            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> " + strbg.toString() + " </font>");

                            request.getSession().setAttribute("pubkey", publickeyparam);
                            request.getSession().setAttribute("privKey", privatekeyparam);


                            response.sendRedirect("dsafunctions.jsp");
                            return;

                        }

                    }

                    request.getSession().setAttribute("pubkey", publickeyparam);
                    request.getSession().setAttribute("privKey", privatekeyparam);


                    response.sendRedirect("dsafunctions.jsp");
                    return;
                }
            }
        } catch (Exception e) {

            session.setAttribute("msg", "<font size=\"2\" color=\"red\"> "+ e.getMessage() +" </font>");
            response.sendRedirect("dsafunctions.jsp");
            return;
        }
        finally {

            try
            {
                fileFullPath.delete();
                sigfilefullPath.delete();
            }
            catch (Exception e)
            {

            }

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
