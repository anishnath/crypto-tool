# Logical Operators in Python
# and, or, not - for combining boolean expressions

print("=" * 50)
print("1. The 'and' Operator")
print("=" * 50)
print("Returns True if BOTH conditions are True")
print()

# Truth table for 'and'
print("and Truth Table:")
print(f"True  and True  = {True and True}")
print(f"True  and False = {True and False}")
print(f"False and True  = {False and True}")
print(f"False and False = {False and False}")

# Practical example
age = 25
has_license = True
print(f"\nage = {age}, has_license = {has_license}")
can_drive = age >= 18 and has_license
print(f"Can drive (age >= 18 and has_license): {can_drive}")

print("\n" + "=" * 50)
print("2. The 'or' Operator")
print("=" * 50)
print("Returns True if AT LEAST ONE condition is True")
print()

# Truth table for 'or'
print("or Truth Table:")
print(f"True  or True  = {True or True}")
print(f"True  or False = {True or False}")
print(f"False or True  = {False or True}")
print(f"False or False = {False or False}")

# Practical example
is_weekend = True
is_holiday = False
print(f"\nis_weekend = {is_weekend}, is_holiday = {is_holiday}")
day_off = is_weekend or is_holiday
print(f"Day off (is_weekend or is_holiday): {day_off}")

print("\n" + "=" * 50)
print("3. The 'not' Operator")
print("=" * 50)
print("Reverses the boolean value")
print()

print(f"not True  = {not True}")
print(f"not False = {not False}")

is_raining = False
print(f"\nis_raining = {is_raining}")
print(f"not is_raining: {not is_raining}")

print("\n" + "=" * 50)
print("4. Combining Logical Operators")
print("=" * 50)

# Operator precedence: not > and > or
a, b, c = True, False, True

print(f"a={a}, b={b}, c={c}")
print(f"a and b or c:   {a and b or c}")      # (a and b) or c = False or True = True
print(f"a or b and c:   {a or b and c}")      # a or (b and c) = True or False = True
print(f"not a or b:     {not a or b}")        # (not a) or b = False or False = False
print(f"not (a or b):   {not (a or b)}")      # not (True or False) = not True = False

print("\n" + "=" * 50)
print("5. Short-Circuit Evaluation")
print("=" * 50)
print("Python stops evaluating as soon as result is known")
print()

# 'and' short-circuits on first False
print("False and print('This never runs'):", False and print("This never runs"))

# 'or' short-circuits on first True
print("True or print('This never runs'):", True or print("This never runs"))

# Practical use: avoiding errors
x = 0
# Without short-circuit, would cause ZeroDivisionError
result = x != 0 and 10/x > 1  # Safe because x != 0 is False
print(f"Safe division check: {result}")

print("\n" + "=" * 50)
print("6. Logical Operators with Non-Booleans")
print("=" * 50)
print("'and' returns first falsy value or last value")
print("'or' returns first truthy value or last value")
print()

print(f"'hello' and 'world': {'hello' and 'world'}")  # 'world'
print(f"'' and 'world': {'' and 'world'}")            # ''
print(f"'hello' or 'world': {'hello' or 'world'}")    # 'hello'
print(f"'' or 'world': {'' or 'world'}")              # 'world'

# Common pattern: default values
name = ""
display_name = name or "Anonymous"
print(f"\nname = '', display_name = {display_name}")
