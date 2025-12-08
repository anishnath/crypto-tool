import logging

# 1. Configure logging to show DEBUG level messages
# logging.basicConfig(...)

def process_data(data):
    # 2. Add an INFO log message saying "Processing data"
    
    if not data:
        # 3. Add a WARNING log message saying "Data is empty"
        return
        
    print(f"Data: {data}")

process_data("Sample")
process_data("")
