
f = open("demofile.txt", "w")
f.write("Hello World!")
f.close()

f = open("demofile.txt", "r")
f.seek(6) # Move cursor to 6th byte
print(f.read()) # Reads from "World!"
f.close()
