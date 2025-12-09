import java.util.logging.Logger;
import java.util.logging.Level;

public class LoggingExample {
    // Get logger for this class
    private static final Logger logger = Logger.getLogger(LoggingExample.class.getName());
    
    public static void main(String[] args) {
        // Different log levels
        logger.severe("This is a SEVERE message");
        logger.warning("This is a WARNING message");
        logger.info("This is an INFO message");
        logger.config("This is a CONFIG message");
        logger.fine("This is a FINE message");
        logger.finer("This is a FINER message");
        logger.finest("This is a FINEST message");
        
        // Example: Logging in a method
        processData("test data");
    }
    
    public static void processData(String data) {
        logger.info("Processing data: " + data);
        
        try {
            if (data == null || data.isEmpty()) {
                logger.warning("Empty data provided");
                return;
            }
            
            // Process data...
            logger.fine("Data processed successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing data", e);
        }
    }
}

