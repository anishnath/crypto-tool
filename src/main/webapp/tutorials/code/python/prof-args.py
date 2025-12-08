import argparse

# NOTE: This script is designed to be run from the command line
# Example: python prof-args.py --name Alice --age 30

def main():
    # Create the parser
    parser = argparse.ArgumentParser(description="A simple greeting script")

    # Add arguments
    parser.add_argument("--name", type=str, help="Your name", required=True)
    parser.add_argument("--age", type=int, help="Your age", default=0)
    parser.add_argument("--verbose", action="store_true", help="Enable verbose output")

    # Parse arguments (in a real script, you would just call parse_args())
    # Here we simulate arguments for demonstration since we are in a web environment
    # args = parser.parse_args() 
    
    # Simulating command line input: python script.py --name Alice --age 30 --verbose
    args = parser.parse_args(['--name', 'Alice', '--age', '30', '--verbose'])

    if args.verbose:
        print("Verbose mode enabled")

    print(f"Hello, {args.name}!")
    
    if args.age > 0:
        print(f"You are {args.age} years old.")

if __name__ == "__main__":
    main()
