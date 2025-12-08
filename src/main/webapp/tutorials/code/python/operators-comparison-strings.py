# String Comparisons - Lexicographic (dictionary) order

# Equality
print('"apple" == "apple":', "apple" == "apple")  # True
print('"apple" == "Apple":', "apple" == "Apple")  # False (case-sensitive!)

print()

# Lexicographic comparison (based on Unicode values)
print('"apple" < "banana":', "apple" < "banana")  # True (a comes before b)
print('"apple" < "apricot":', "apple" < "apricot")  # True (l < r at position 2)

print()

# Uppercase vs lowercase (surprising!)
print('"Z" < "a":', "Z" < "a")    # True! (uppercase letters have lower Unicode)
print("ord('Z'):", ord('Z'))      # 90
print("ord('a'):", ord('a'))      # 97

print()

# Numbers in strings
print('"10" > "9":', "10" > "9")   # False! (string "1" < "9")
print('"10" > "09":', "10" > "09") # True ("1" > "0")
print('"2" > "10":', "2" > "10")   # True! ("2" > "1")

print()

# Case-insensitive comparison
name1 = "Alice"
name2 = "alice"
print("name1 == name2:", name1 == name2)                    # False
print("name1.lower() == name2.lower():",
      name1.lower() == name2.lower())                       # True
