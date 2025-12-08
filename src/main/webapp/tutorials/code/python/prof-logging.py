import logging

# Configure logging
# By default, only WARNING and above are printed
# We set level to DEBUG to see all messages
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def divide(x, y):
    logging.info(f"Dividing {x} by {y}")
    try:
        result = x / y
        logging.debug(f"Result is {result}")
        return result
    except ZeroDivisionError:
        logging.error("Attempted to divide by zero!")
        return None

print("--- Calculation 1 ---")
divide(10, 2)

print("\n--- Calculation 2 ---")
divide(5, 0)

print("\n--- Log Levels ---")
logging.debug("This is a debug message")
logging.info("This is an info message")
logging.warning("This is a warning message")
logging.error("This is an error message")
logging.critical("This is a critical message")
