# Exercise: Analyze Time Complexity
# Determine the Big O complexity of each function

# Function 1
def function1(arr):
    """What is the time complexity?"""
    return arr[0] + arr[-1]

# Function 2
def function2(arr):
    """What is the time complexity?"""
    total = 0
    for num in arr:
        total += num
    return total

# Function 3
def function3(arr):
    """What is the time complexity?"""
    for i in range(len(arr)):
        for j in range(len(arr)):
            print(arr[i] + arr[j])

# Function 4
def function4(arr, target):
    """What is the time complexity?"""
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# Function 5
def function5(n):
    """What is the time complexity?"""
    if n <= 1:
        return n
    return function5(n - 1) + function5(n - 2)

# Test your understanding
print("Analyze the time complexity of each function:")
print("=" * 50)
print("\nFunction 1: Accesses first and last element")
print("Your answer: ___________")

print("\nFunction 2: Sums all elements")
print("Your answer: ___________")

print("\nFunction 3: Nested loops over array")
print("Your answer: ___________")

print("\nFunction 4: Binary search")
print("Your answer: ___________")

print("\nFunction 5: Recursive Fibonacci")
print("Your answer: ___________")

print("\n" + "=" * 50)
print("Uncomment the solutions below to check your answers!")
print("=" * 50)

# SOLUTIONS (uncomment to reveal)
# print("\nSOLUTIONS:")
# print("Function 1: O(1) - Constant time, just two array accesses")
# print("Function 2: O(n) - Linear time, loops through all elements")
# print("Function 3: O(n²) - Quadratic time, nested loops")
# print("Function 4: O(log n) - Logarithmic time, binary search")
# print("Function 5: O(2ⁿ) - Exponential time, naive recursion")
