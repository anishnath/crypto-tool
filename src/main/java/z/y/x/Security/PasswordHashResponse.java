package z.y.x.Security;

import com.google.gson.Gson;
import java.util.List;
import java.util.ArrayList;

/**
 * JSON response wrapper for password hashing operations (BCrypt, Scrypt, htpasswd)
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class PasswordHashResponse {

    private boolean success;
    private String operation;
    private String errorMessage;

    // Input info
    private String password;
    private String username;

    // Generated hash info
    private String hash;
    private String algorithm;
    private String prefix;

    // BCrypt specific
    private Integer costFactor;
    private String salt;
    private String hashValue;

    // Scrypt specific
    private Integer cpuCost;      // N
    private Integer memoryCost;   // r
    private Integer parallelization; // p
    private Integer keyLength;
    private String scryptSalt;
    private String memoryRequired;

    // Verification
    private Boolean verified;
    private String verificationMessage;

    // htpasswd - multiple algorithms
    private List<HtpasswdEntry> htpasswdEntries;

    public PasswordHashResponse() {
        this.htpasswdEntries = new ArrayList<>();
    }

    // Nested class for htpasswd entries
    public static class HtpasswdEntry {
        private String algorithm;
        private String prefix;
        private String hash;
        private String fullEntry; // username:hash

        public HtpasswdEntry() {}

        public HtpasswdEntry(String algorithm, String prefix, String hash, String fullEntry) {
            this.algorithm = algorithm;
            this.prefix = prefix;
            this.hash = hash;
            this.fullEntry = fullEntry;
        }

        public String getAlgorithm() { return algorithm; }
        public void setAlgorithm(String algorithm) { this.algorithm = algorithm; }
        public String getPrefix() { return prefix; }
        public void setPrefix(String prefix) { this.prefix = prefix; }
        public String getHash() { return hash; }
        public void setHash(String hash) { this.hash = hash; }
        public String getFullEntry() { return fullEntry; }
        public void setFullEntry(String fullEntry) { this.fullEntry = fullEntry; }
    }

    // Getters and Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getOperation() { return operation; }
    public void setOperation(String operation) { this.operation = operation; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getHash() { return hash; }
    public void setHash(String hash) { this.hash = hash; }

    public String getAlgorithm() { return algorithm; }
    public void setAlgorithm(String algorithm) { this.algorithm = algorithm; }

    public String getPrefix() { return prefix; }
    public void setPrefix(String prefix) { this.prefix = prefix; }

    public Integer getCostFactor() { return costFactor; }
    public void setCostFactor(Integer costFactor) { this.costFactor = costFactor; }

    public String getSalt() { return salt; }
    public void setSalt(String salt) { this.salt = salt; }

    public String getHashValue() { return hashValue; }
    public void setHashValue(String hashValue) { this.hashValue = hashValue; }

    public Integer getCpuCost() { return cpuCost; }
    public void setCpuCost(Integer cpuCost) { this.cpuCost = cpuCost; }

    public Integer getMemoryCost() { return memoryCost; }
    public void setMemoryCost(Integer memoryCost) { this.memoryCost = memoryCost; }

    public Integer getParallelization() { return parallelization; }
    public void setParallelization(Integer parallelization) { this.parallelization = parallelization; }

    public Integer getKeyLength() { return keyLength; }
    public void setKeyLength(Integer keyLength) { this.keyLength = keyLength; }

    public String getScryptSalt() { return scryptSalt; }
    public void setScryptSalt(String scryptSalt) { this.scryptSalt = scryptSalt; }

    public String getMemoryRequired() { return memoryRequired; }
    public void setMemoryRequired(String memoryRequired) { this.memoryRequired = memoryRequired; }

    public Boolean getVerified() { return verified; }
    public void setVerified(Boolean verified) { this.verified = verified; }

    public String getVerificationMessage() { return verificationMessage; }
    public void setVerificationMessage(String verificationMessage) { this.verificationMessage = verificationMessage; }

    public List<HtpasswdEntry> getHtpasswdEntries() { return htpasswdEntries; }
    public void setHtpasswdEntries(List<HtpasswdEntry> htpasswdEntries) { this.htpasswdEntries = htpasswdEntries; }

    public void addHtpasswdEntry(HtpasswdEntry entry) {
        this.htpasswdEntries.add(entry);
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
