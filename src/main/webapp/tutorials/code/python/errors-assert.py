# Python Assertions
# Assertions are statements that assert or state a fact confidently in your program.
# For example, while writing a division function, you're confident the divisor shouldn't be zero, you assert divisor is not zero.

# 1. Basic Assertion
def avg(marks):
    assert len(marks) != 0, "List is empty."
    return sum(marks)/len(marks)

mark2 = [55, 88, 78, 90, 79]
print("Average of mark2:", avg(mark2))

# 2. Assertion Error
mark1 = []
# print("Average of mark1:", avg(mark1)) # This will raise AssertionError

# 3. Disabling Assertions
# Assertions can be disabled by running Python with -O flag.
print("Assertions are useful for debugging.")
