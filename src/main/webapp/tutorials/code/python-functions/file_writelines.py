
f = open("demofile3.txt", "w")
f.writelines(["See you soon!", "\nOver and out."])
f.close()

# Read the result
f = open("demofile3.txt", "r")
print(f.read())
f.close()
