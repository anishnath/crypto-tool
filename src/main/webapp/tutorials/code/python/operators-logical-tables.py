# Truth Tables Demonstration

print("=== AND Truth Table ===")
for a in [True, False]:
    for b in [True, False]:
        print(f"{a} and {b} = {a and b}")

print("\n=== OR Truth Table ===")
for a in [True, False]:
    for b in [True, False]:
        print(f"{a} or {b} = {a or b}")

print("\n=== NOT Truth Table ===")
for a in [True, False]:
    print(f"not {a} = {not a}")

print("\n=== Combined Example ===")
# (A and B) or (not A and not B)
# This is True when A and B are the same
for a in [True, False]:
    for b in [True, False]:
        result = (a and b) or (not a and not b)
        print(f"A={a}, B={b}: (A and B) or (not A and not B) = {result}")
