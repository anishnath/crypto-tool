# Python Finally & Else
# The 'else' block lets you execute code when there is no error.
# The 'finally' block lets you execute code, regardless of the result of the try- and except blocks.

# 1. Else Block
try:
    print("Hello")
except:
    print("Something went wrong")
else:
    print("Nothing went wrong")

# 2. Finally Block
try:
    print(x)
except:
    print("Something went wrong")
finally:
    print("The 'try except' is finished")

# 3. Real-world example (Closing files)
try:
    f = open("demofile.txt")
    try:
        f.write("Lorum Ipsum")
    except:
        print("Something went wrong when writing to the file")
    finally:
        f.close()
except:
    print("Something went wrong when opening the file")
