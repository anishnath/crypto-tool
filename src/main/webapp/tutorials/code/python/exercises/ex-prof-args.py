import argparse

# Task: Create a script that accepts a --file argument

def main():
    parser = argparse.ArgumentParser()
    
    # 1. Add a '--file' argument (string, required)
    
    
    # Simulate arguments for the web compiler
    args = parser.parse_args(['--file', 'data.txt'])
    
    # 2. Print "Processing file: [filename]" using the argument
    

if __name__ == "__main__":
    main()
