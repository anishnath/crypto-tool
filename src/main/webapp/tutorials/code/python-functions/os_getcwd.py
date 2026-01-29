import os

# Get current working directory
cwd = os.getcwd()
print(f"Current directory: {cwd}")

# You can use this to build file paths
filename = "myfile.txt"
full_path = os.path.join(cwd, filename)
print(f"Full path: {full_path}")
