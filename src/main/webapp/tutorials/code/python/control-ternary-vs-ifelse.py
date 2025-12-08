# Ternary vs Traditional if-else: When to Use Which

print("=== Use Ternary For: ===")
print()

# 1. Simple value assignment
print("1. Simple value assignment")
age = 25
status = "adult" if age >= 18 else "minor"
print(f"   status = 'adult' if age >= 18 else 'minor'")
print(f"   Result: {status}")
print()

# 2. Inline in print/function calls
print("2. Inline in print statements")
is_morning = True
print(f"   {('Good morning!' if is_morning else 'Good evening!')}")
print()

# 3. Default values
print("3. Default values")
user_input = None
value = user_input if user_input is not None else "default"
print(f"   value = user_input if user_input is not None else 'default'")
print(f"   Result: {value}")

print()
print("=== Use if-else For: ===")
print()

# 1. Multiple statements
print("1. Multiple statements in each branch")
print("   if condition:")
print("       do_something()")
print("       do_another_thing()")
print()

# 2. Complex logic
print("2. Complex conditions or logic")
print("   if x > 0 and y > 0 and is_valid:")
print("       result = calculate_complex()")
print()

# 3. When readability suffers
print("3. When ternary becomes hard to read")
print("   # BAD: hard to understand")
print("   # x = a if b else c if d else e if f else g")
print()
print("   # GOOD: clear intent")
print("   # if b:")
print("   #     x = a")
print("   # elif d:")
print("   #     x = c")
print("   # ...")
