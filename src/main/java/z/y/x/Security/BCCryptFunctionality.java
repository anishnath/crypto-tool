package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import z.y.x.r.LoadPropertyFileFunctionality;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Password hashing functionality for BCrypt, Scrypt, and htpasswd
 * Returns structured JSON responses using PasswordHashResponse
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class BCCryptFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_HASH_BCCRYPT = "CALCULATE_BCCRYPT";
    private static final String METHOD_HASH_SCRYPT = "CALCULATE_SCRYPT";
    private static final String METHOD_CHECK_PASSWORD = "METHOD_CHECK_PASSWORD";
    private static final String METHOD_HTPASSWORD_GENERATE = "HTPASSWORD_GENERATE";

    private static final Gson gson = new Gson();

    public BCCryptFunctionality() {
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PasswordHashResponse resp = new PasswordHashResponse();
        resp.setSuccess(false);
        resp.setErrorMessage("GET method not supported. Use POST.");

        PrintWriter out = response.getWriter();
        out.println(gson.toJson(resp));
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        final String methodName = request.getParameter("methodName");
        PrintWriter out = response.getWriter();

        if (METHOD_HTPASSWORD_GENERATE.equals(methodName)) {
            handleHtpasswd(request, out);
            return;
        }

        if (METHOD_HASH_BCCRYPT.equals(methodName)) {
            handleBcrypt(request, out);
            return;
        }

        if (METHOD_HASH_SCRYPT.equals(methodName)) {
            handleScrypt(request, out);
            return;
        }

        // Unknown method
        PasswordHashResponse resp = new PasswordHashResponse();
        resp.setSuccess(false);
        resp.setErrorMessage("Unknown method: " + methodName);
        out.println(gson.toJson(resp));
    }

    /**
     * Handle htpasswd generation and verification
     */
    private void handleHtpasswd(HttpServletRequest request, PrintWriter out) {
        PasswordHashResponse resp = new PasswordHashResponse();
        resp.setOperation("htpasswd");

        final String password = request.getParameter("password");
        final String username = request.getParameter("username");
        String passwordhash = request.getParameter("hash");

        if (password == null || password.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Password is empty");
            out.println(gson.toJson(resp));
            return;
        }

        resp.setPassword(password);
        if (username != null && username.trim().length() > 0) {
            resp.setUsername(username);
        }

        String[] algo = new String[]{"bcrypt", "apr1", "md5", "sha256", "sha512", "crypt"};
        String[] verifyAlgo = new String[]{"bcrypt", "apr1", "md5", "sha256", "sha512"};

        // Verify hash if provided
        if (passwordhash != null && passwordhash.trim().length() > 0) {
            boolean isValid = false;
            String hashOnly = passwordhash.contains(":")
                ? passwordhash.substring(passwordhash.indexOf(":") + 1)
                : passwordhash;

            for (String algorithm : verifyAlgo) {
                try {
                    isValid = HtPasswordUtil.validatePassword(password, hashOnly, algorithm);
                    if (isValid) {
                        resp.setVerified(true);
                        resp.setVerificationMessage("Hash verification passed with algorithm: " + algorithm.toUpperCase());
                        resp.setHash(hashOnly);
                        resp.setAlgorithm(algorithm.toUpperCase());
                        break;
                    }
                } catch (Exception e) {
                    // Try next algorithm
                }
            }

            if (!isValid) {
                resp.setVerified(false);
                resp.setVerificationMessage("Hash verification failed - password does not match hash");
            }
        }

        // Generate hashes for all algorithms
        for (String algorithm : algo) {
            try {
                String htpassword = HtPasswordUtil.createPassword(password, algorithm);
                String prefix = getHtpasswdPrefix(algorithm);
                String fullEntry = (username != null && username.trim().length() > 0)
                    ? username + ":" + htpassword
                    : htpassword;

                PasswordHashResponse.HtpasswdEntry entry = new PasswordHashResponse.HtpasswdEntry(
                    algorithm.toUpperCase(),
                    prefix,
                    htpassword,
                    fullEntry
                );
                resp.addHtpasswdEntry(entry);
            } catch (Exception e) {
                // Skip failed algorithms
            }
        }

        resp.setSuccess(true);
        out.println(gson.toJson(resp));
    }

    /**
     * Get the prefix identifier for htpasswd algorithms
     */
    private String getHtpasswdPrefix(String algorithm) {
        switch (algorithm.toLowerCase()) {
            case "bcrypt": return "$2y$";
            case "apr1": return "$apr1$";
            case "md5": return "$1$";
            case "sha256": return "$5$";
            case "sha512": return "$6$";
            case "crypt": return "(DES)";
            default: return "";
        }
    }

    /**
     * Handle BCrypt hash generation and verification
     */
    private void handleBcrypt(HttpServletRequest request, PrintWriter out) {
        PasswordHashResponse resp = new PasswordHashResponse();
        resp.setOperation("bcrypt");
        resp.setAlgorithm("BCrypt");

        final String password = request.getParameter("password");
        final String workload = request.getParameter("workload");
        final String passwordhash = request.getParameter("hash");

        if (password == null || password.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Password is empty");
            out.println(gson.toJson(resp));
            return;
        }

        resp.setPassword(password);

        int costFactor = 10; // default
        try {
            costFactor = Integer.parseInt(workload);
            if (costFactor > 13) {
                resp.setSuccess(false);
                resp.setErrorMessage("Maximum supported cost factor is 13");
                out.println(gson.toJson(resp));
                return;
            }
            if (costFactor < 4) {
                costFactor = 4; // minimum
            }
        } catch (NumberFormatException nfe) {
            costFactor = 10;
        }

        resp.setCostFactor(costFactor);

        // Generate hash
        String hashpassword = JBCryptUtil.hashPassword(password, costFactor);
        resp.setHash(hashpassword);

        // Parse BCrypt hash components
        if (hashpassword.length() >= 29) {
            resp.setPrefix(hashpassword.substring(0, 4));  // $2a$ or $2b$ or $2y$
            resp.setSalt(hashpassword.substring(7, 29));   // 22 character salt
            resp.setHashValue(hashpassword.substring(29)); // remaining is hash
        }

        resp.setSuccess(true);

        // Verify hash if provided
        if (passwordhash != null && passwordhash.trim().length() > 0) {
            if (passwordhash.length() < 5) {
                resp.setVerified(false);
                resp.setVerificationMessage("Invalid BCrypt hash format");
            } else {
                String prefix = passwordhash.substring(0, 4);
                if ("$2a$".equals(prefix) || "$2y$".equals(prefix) || "$2b$".equals(prefix)) {
                    boolean valid = JBCryptUtil.checkPassword(password, passwordhash);
                    resp.setVerified(valid);
                    resp.setVerificationMessage(valid
                        ? "Hash verification passed"
                        : "Hash verification failed - password does not match");
                } else {
                    resp.setVerified(false);
                    resp.setVerificationMessage("Invalid BCrypt hash - must start with $2a$, $2b$, or $2y$");
                }
            }
        }

        out.println(gson.toJson(resp));
    }

    /**
     * Handle Scrypt hash generation and verification
     */
    private void handleScrypt(HttpServletRequest request, PrintWriter out) {
        PasswordHashResponse resp = new PasswordHashResponse();
        resp.setOperation("scrypt");
        resp.setAlgorithm("Scrypt");

        final String password = request.getParameter("password");
        final String workparam = request.getParameter("workparam");
        final String memoryparam = request.getParameter("memoryparam");
        final String parallelizationparam = request.getParameter("parallelizationparam");
        final String length = request.getParameter("length");
        final String salt = request.getParameter("salt");
        final String hash = request.getParameter("hash");

        // Validation
        if (password == null || password.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Password is empty");
            out.println(gson.toJson(resp));
            return;
        }

        if (salt == null || salt.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Salt (S) is empty or null");
            out.println(gson.toJson(resp));
            return;
        }

        if (workparam == null || workparam.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("CPU cost parameter (N) is empty");
            out.println(gson.toJson(resp));
            return;
        }

        if (memoryparam == null || memoryparam.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Memory cost parameter (r) is empty or null");
            out.println(gson.toJson(resp));
            return;
        }

        if (parallelizationparam == null || parallelizationparam.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Parallelization parameter (p) is empty or null");
            out.println(gson.toJson(resp));
            return;
        }

        if (length == null || length.trim().length() == 0) {
            resp.setSuccess(false);
            resp.setErrorMessage("Output length is empty or null");
            out.println(gson.toJson(resp));
            return;
        }

        resp.setPassword(password);
        resp.setScryptSalt(salt);

        // Parse and validate parameters
        final int cpuCost;
        final int memoryCost;
        final int parallelization;
        final int keylength;

        try {
            cpuCost = Integer.parseInt(workparam);
        } catch (NumberFormatException e) {
            resp.setSuccess(false);
            resp.setErrorMessage("CPU cost (N) must be an integer");
            out.println(gson.toJson(resp));
            return;
        }

        try {
            memoryCost = Integer.parseInt(memoryparam);
        } catch (NumberFormatException e) {
            resp.setSuccess(false);
            resp.setErrorMessage("Memory cost (r) must be an integer");
            out.println(gson.toJson(resp));
            return;
        }

        try {
            parallelization = Integer.parseInt(parallelizationparam);
        } catch (NumberFormatException e) {
            resp.setSuccess(false);
            resp.setErrorMessage("Parallelization (p) must be an integer");
            out.println(gson.toJson(resp));
            return;
        }

        try {
            keylength = Integer.parseInt(length);
            if (keylength > 3000) {
                resp.setSuccess(false);
                resp.setErrorMessage("Maximum supported key length is 3000");
                out.println(gson.toJson(resp));
                return;
            }
        } catch (NumberFormatException e) {
            resp.setSuccess(false);
            resp.setErrorMessage("Key length must be an integer");
            out.println(gson.toJson(resp));
            return;
        }

        // Validate parameter constraints
        if (cpuCost <= 1) {
            resp.setSuccess(false);
            resp.setErrorMessage("CPU cost (N) must be greater than 1");
            out.println(gson.toJson(resp));
            return;
        }

        if (!isPowerOf2(cpuCost)) {
            resp.setSuccess(false);
            resp.setErrorMessage("CPU cost (N) must be a power of 2. Got: " + cpuCost);
            out.println(gson.toJson(resp));
            return;
        }

        if (memoryCost == 1 && cpuCost > 65536) {
            resp.setSuccess(false);
            resp.setErrorMessage("When r=1, CPU cost (N) must be <= 65536");
            out.println(gson.toJson(resp));
            return;
        }

        if (memoryCost < 1) {
            resp.setSuccess(false);
            resp.setErrorMessage("Memory cost (r) must be >= 1");
            out.println(gson.toJson(resp));
            return;
        }

        int maxParallel = Integer.MAX_VALUE / (128 * memoryCost * 8);
        if (parallelization < 1 || parallelization > maxParallel) {
            resp.setSuccess(false);
            resp.setErrorMessage("Parallelization (p) must be >= 1 and <= " + maxParallel + " (based on r=" + memoryCost + ")");
            out.println(gson.toJson(resp));
            return;
        }

        if (keylength < 1) {
            resp.setSuccess(false);
            resp.setErrorMessage("Key length must be >= 1");
            out.println(gson.toJson(resp));
            return;
        }

        // Set parameters in response
        resp.setCpuCost(cpuCost);
        resp.setMemoryCost(memoryCost);
        resp.setParallelization(parallelization);
        resp.setKeyLength(keylength);

        // Calculate memory required
        long memoryBytes = 128L * cpuCost * memoryCost;
        resp.setMemoryRequired(formatBytes(memoryBytes));

        // Call external Scrypt service
        HttpClient client = HttpClientBuilder.create().build();
        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "scrypt/generatehash";

        List<NameValuePair> urlParameters = new ArrayList<>();

        boolean isVerification = hash != null && hash.trim().length() > 0;
        if (isVerification) {
            urlParameters.add(new BasicNameValuePair("p_rawpassphrase", hash));
            url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "scrypt/verifyhash";
        }

        urlParameters.add(new BasicNameValuePair("p_passphrase", password));
        urlParameters.add(new BasicNameValuePair("p_salt", salt));
        urlParameters.add(new BasicNameValuePair("p_n", workparam));
        urlParameters.add(new BasicNameValuePair("p_r", memoryparam));
        urlParameters.add(new BasicNameValuePair("p_p", parallelizationparam));
        urlParameters.add(new BasicNameValuePair("p_outputlength", length));

        try {
            HttpPost post = new HttpPost(url1);
            post.setEntity(new UrlEncodedFormEntity(urlParameters));
            HttpResponse response1 = client.execute(post);

            if (response1.getStatusLine().getStatusCode() != 200) {
                BufferedReader br = new BufferedReader(
                    new InputStreamReader(response1.getEntity().getContent())
                );
                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }

                resp.setSuccess(false);
                resp.setErrorMessage("Scrypt service error: " + content.toString());
                out.println(gson.toJson(resp));
                return;
            }

            BufferedReader br = new BufferedReader(
                new InputStreamReader(response1.getEntity().getContent())
            );
            StringBuilder content = new StringBuilder();
            String line;
            while (null != (line = br.readLine())) {
                content.append(line);
            }

            EncodedMessage certpojo1 = gson.fromJson(content.toString(), EncodedMessage.class);

            resp.setSuccess(true);
            resp.setHash(certpojo1.getBase64Encoded());

            if (isVerification) {
                String message = certpojo1.getMessage();
                // Check for various success indicators (including typo "Sucessfull" from external service)
                boolean verified = message != null &&
                    (message.toLowerCase().contains("match") ||
                     message.toLowerCase().contains("success") ||
                     message.toLowerCase().contains("sucessful"));
                resp.setVerified(verified);
                resp.setVerificationMessage(verified
                    ? "Hash verification passed"
                    : "Hash verification failed - password does not match hash");
            }

            out.println(gson.toJson(resp));

        } catch (Exception e) {
            resp.setSuccess(false);
            resp.setErrorMessage("Error: " + e.getMessage());
            out.println(gson.toJson(resp));
        }
    }

    /**
     * Format bytes to human-readable string
     */
    private String formatBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.1f KB", bytes / 1024.0);
        if (bytes < 1024 * 1024 * 1024) return String.format("%.1f MB", bytes / (1024.0 * 1024));
        return String.format("%.1f GB", bytes / (1024.0 * 1024 * 1024));
    }

    private static boolean isPowerOf2(int x) {
        return ((x & (x - 1)) == 0);
    }
}
