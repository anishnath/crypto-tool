import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.logging.Handler;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.SimpleFormatter;

public class LoggingConfig {
    private static final Logger logger = Logger.getLogger(LoggingConfig.class.getName());
    
    static {
        try {
            // Create file handler
            FileHandler fileHandler = new FileHandler("app.log", true);
            fileHandler.setFormatter(new SimpleFormatter());
            fileHandler.setLevel(Level.ALL);
            
            // Create console handler
            ConsoleHandler consoleHandler = new ConsoleHandler();
            consoleHandler.setLevel(Level.INFO);
            
            // Add handlers to logger
            logger.addHandler(fileHandler);
            logger.addHandler(consoleHandler);
            
            // Set logger level
            logger.setLevel(Level.ALL);
            
            // Prevent messages from being logged to parent handlers
            logger.setUseParentHandlers(false);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        logger.info("Application started");
        logger.warning("This is a warning");
        logger.severe("This is a severe error");
        logger.info("Application ended");
    }
}

