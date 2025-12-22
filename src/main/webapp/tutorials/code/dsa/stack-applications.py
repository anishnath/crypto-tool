"""
Stack Applications - Real-World Uses
Expression evaluation, balanced parentheses, function calls, undo/redo
These are THE most common stack interview questions!
"""

# ============================================================================
# APPLICATION 1: Balanced Parentheses/Brackets
# ============================================================================

def is_balanced(expression):
    """
    Check if parentheses/brackets are balanced
    Time: O(n), Space: O(n)
    
    Examples:
    "()" → True
    "()[]{}" → True
    "(]" → False
    "({[]})" → True
    """
    print(f"\n🔍 Checking if balanced: '{expression}'")
    
    stack = []
    matching = {'(': ')', '[': ']', '{': '}'}
    
    for i, char in enumerate(expression):
        if char in matching:  # Opening bracket
            stack.append(char)
            print(f"  Step {i+1}: Push '{char}' → Stack: {stack}")
        elif char in matching.values():  # Closing bracket
            if not stack:
                print(f"  Step {i+1}: Found '{char}' but stack empty → NOT BALANCED")
                return False
            
            top = stack.pop()
            if matching[top] != char:
                print(f"  Step {i+1}: '{char}' doesn't match '{top}' → NOT BALANCED")
                return False
            print(f"  Step {i+1}: '{char}' matches '{top}' ✓ → Stack: {stack}")
    
    is_bal = len(stack) == 0
    print(f"  Result: {'BALANCED ✓' if is_bal else 'NOT BALANCED (unclosed brackets)'}")
    return is_bal

# ============================================================================
# APPLICATION 2: Infix to Postfix Conversion
# ============================================================================

def infix_to_postfix(expression):
    """
    Convert infix to postfix notation
    Time: O(n), Space: O(n)
    
    Examples:
    "A+B" → "AB+"
    "A+B*C" → "ABC*+"
    "(A+B)*C" → "AB+C*"
    """
    print(f"\n🔄 Converting infix to postfix: '{expression}'")
    
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
    stack = []
    postfix = []
    
    for char in expression:
        if char.isalnum():  # Operand
            postfix.append(char)
            print(f"  Operand '{char}' → Output: {''.join(postfix)}")
        elif char == '(':
            stack.append(char)
            print(f"  '(' → Push to stack: {stack}")
        elif char == ')':
            while stack and stack[-1] != '(':
                postfix.append(stack.pop())
            stack.pop()  # Remove '('
            print(f"  ')' → Pop until '(' → Output: {''.join(postfix)}")
        else:  # Operator
            while (stack and stack[-1] != '(' and
                   stack[-1] in precedence and
                   precedence[stack[-1]] >= precedence[char]):
                postfix.append(stack.pop())
            stack.append(char)
            print(f"  Operator '{char}' → Stack: {stack}, Output: {''.join(postfix)}")
    
    while stack:
        postfix.append(stack.pop())
    
    result = ''.join(postfix)
    print(f"  ✅ Postfix: {result}")
    return result

# ============================================================================
# APPLICATION 3: Evaluate Postfix Expression
# ============================================================================

def evaluate_postfix(expression):
    """
    Evaluate postfix expression
    Time: O(n), Space: O(n)
    
    Examples:
    "23+" → 5
    "23*5+" → 11
    "53+82-*" → 48
    """
    print(f"\n🧮 Evaluating postfix: '{expression}'")
    
    stack = []
    
    for char in expression:
        if char.isdigit():
            stack.append(int(char))
            print(f"  Operand {char} → Push → Stack: {stack}")
        else:
            # Pop two operands
            b = stack.pop()
            a = stack.pop()
            
            # Perform operation
            if char == '+':
                result = a + b
            elif char == '-':
                result = a - b
            elif char == '*':
                result = a * b
            elif char == '/':
                result = a // b
            
            stack.append(result)
            print(f"  Operator {char} → {a} {char} {b} = {result} → Stack: {stack}")
    
    final = stack[0]
    print(f"  ✅ Result: {final}")
    return final

# ============================================================================
# APPLICATION 4: Function Call Stack Simulation
# ============================================================================

class CallStack:
    """Simulate function call stack"""
    
    def __init__(self):
        self.stack = []
    
    def call_function(self, func_name, params=None):
        """Push function onto call stack"""
        frame = {'name': func_name, 'params': params}
        self.stack.append(frame)
        print(f"  → Called {func_name}({params}) | Stack depth: {len(self.stack)}")
        self.display()
    
    def return_from_function(self):
        """Pop function from call stack"""
        if self.stack:
            frame = self.stack.pop()
            print(f"  ← Returned from {frame['name']} | Stack depth: {len(self.stack)}")
            self.display()
    
    def display(self):
        """Display current call stack"""
        if not self.stack:
            print("     Call stack: (empty)")
            return
        
        print("     Call stack (top to bottom):")
        for i in range(len(self.stack) - 1, -1, -1):
            frame = self.stack[i]
            marker = "TOP → " if i == len(self.stack) - 1 else "      "
            print(f"       {marker}{frame['name']}({frame['params']})")

# ============================================================================
# APPLICATION 5: Undo/Redo Functionality
# ============================================================================

class TextEditor:
    """Simple text editor with undo/redo"""
    
    def __init__(self):
        self.text = ""
        self.undo_stack = []
        self.redo_stack = []
    
    def type(self, char):
        """Type a character"""
        self.undo_stack.append(self.text)
        self.text += char
        self.redo_stack = []  # Clear redo on new action
        print(f"  Typed '{char}' → Text: '{self.text}'")
    
    def undo(self):
        """Undo last action"""
        if not self.undo_stack:
            print("  Nothing to undo!")
            return
        
        self.redo_stack.append(self.text)
        self.text = self.undo_stack.pop()
        print(f"  Undo → Text: '{self.text}'")
    
    def redo(self):
        """Redo last undone action"""
        if not self.redo_stack:
            print("  Nothing to redo!")
            return
        
        self.undo_stack.append(self.text)
        self.text = self.redo_stack.pop()
        print(f"  Redo → Text: '{self.text}'")

# ============================================================================
# EXAMPLE 1: Balanced Parentheses
# ============================================================================

print("=" * 70)
print("Application 1: Balanced Parentheses/Brackets")
print("=" * 70)

test_cases = [
    "()",
    "()[]{}",
    "(]",
    "([)]",
    "{[()]}",
    "(((",
    "())",
]

for expr in test_cases:
    is_balanced(expr)

print("\n" + "─" * 70)
print("KEY INSIGHT: Use stack to match opening/closing brackets!")
print("Opening → Push, Closing → Pop and check match")
print("─" * 70)

# ============================================================================
# EXAMPLE 2: Infix to Postfix
# ============================================================================

print("\n" + "=" * 70)
print("Application 2: Infix to Postfix Conversion")
print("=" * 70)

expressions = [
    "A+B",
    "A+B*C",
    "(A+B)*C",
    "A+B*C-D",
]

for expr in expressions:
    infix_to_postfix(expr)

print("\n" + "─" * 70)
print("WHY POSTFIX?")
print("  • No parentheses needed")
print("  • Easy to evaluate")
print("  • Used in calculators and compilers")
print("─" * 70)

# ============================================================================
# EXAMPLE 3: Evaluate Postfix
# ============================================================================

print("\n" + "=" * 70)
print("Application 3: Evaluate Postfix Expression")
print("=" * 70)

postfix_expressions = [
    "23+",      # 2 + 3 = 5
    "23*5+",    # 2 * 3 + 5 = 11
    "53+82-*",  # (5 + 3) * (8 - 2) = 48
]

for expr in postfix_expressions:
    evaluate_postfix(expr)

print("\n" + "─" * 70)
print("ALGORITHM:")
print("  1. Operand → Push to stack")
print("  2. Operator → Pop 2, compute, push result")
print("  3. Final answer is last item in stack")
print("─" * 70)

# ============================================================================
# EXAMPLE 4: Function Call Stack
# ============================================================================

print("\n" + "=" * 70)
print("Application 4: Function Call Stack")
print("=" * 70)

print("\nSimulating nested function calls:")
call_stack = CallStack()

print("\nmain() calls processData():")
call_stack.call_function("main", None)
call_stack.call_function("processData", "data.txt")

print("\nprocessData() calls validate():")
call_stack.call_function("validate", "input")

print("\nvalidate() calls checkFormat():")
call_stack.call_function("checkFormat", "format")

print("\nFunctions return in reverse order (LIFO):")
call_stack.return_from_function()  # checkFormat
call_stack.return_from_function()  # validate
call_stack.return_from_function()  # processData
call_stack.return_from_function()  # main

print("\n" + "─" * 70)
print("EVERY FUNCTION CALL USES A STACK!")
print("This is how recursion works!")
print("─" * 70)

# ============================================================================
# EXAMPLE 5: Undo/Redo
# ============================================================================

print("\n" + "=" * 70)
print("Application 5: Undo/Redo Functionality")
print("=" * 70)

print("\nText editor simulation:")
editor = TextEditor()

print("\nTyping 'Hello':")
for char in "Hello":
    editor.type(char)

print("\nUndo 2 times:")
editor.undo()
editor.undo()

print("\nRedo 1 time:")
editor.redo()

print("\nType '!':")
editor.type('!')

print("\nTry redo (should fail - new action clears redo):")
editor.redo()

print("\n" + "─" * 70)
print("TWO STACKS:")
print("  • Undo stack: Previous states")
print("  • Redo stack: Undone states")
print("  • New action clears redo stack")
print("─" * 70)

# ============================================================================
# COMPLEXITY ANALYSIS
# ============================================================================

print("\n" + "=" * 70)
print("Complexity Analysis")
print("=" * 70)

print(f"\n{'Application':<30} {'Time':<15} {'Space':<15}")
print("─" * 70)
print(f"{'Balanced parentheses':<30} {'O(n)':<15} {'O(n)':<15}")
print(f"{'Infix to postfix':<30} {'O(n)':<15} {'O(n)':<15}")
print(f"{'Evaluate postfix':<30} {'O(n)':<15} {'O(n)':<15}")
print(f"{'Function call (push/pop)':<30} {'O(1)':<15} {'O(1)':<15}")
print(f"{'Undo/Redo (each)':<30} {'O(1)':<15} {'O(1)':<15}")

# ============================================================================
# INTERVIEW TIPS
# ============================================================================

print("\n" + "=" * 70)
print("Interview Tips")
print("=" * 70)

print("\n✅ Balanced Parentheses:")
print("  • Very common interview question!")
print("  • Use stack to match opening/closing")
print("  • Don't forget to check stack empty at end")

print("\n✅ Expression Evaluation:")
print("  • Know infix, prefix, postfix")
print("  • Postfix is easiest to evaluate")
print("  • Use operator precedence for conversion")

print("\n✅ Function Call Stack:")
print("  • Explain how recursion works")
print("  • Stack overflow = too many calls")
print("  • Each call = new stack frame")

print("\n✅ Undo/Redo:")
print("  • Two stacks pattern")
print("  • New action clears redo")
print("  • Common in design questions")

# ============================================================================
# KEY TAKEAWAYS
# ============================================================================

print("\n" + "=" * 70)
print("Key Takeaways")
print("=" * 70)

print("\n✓ Stacks are perfect for:")
print("  1. Matching pairs (parentheses)")
print("  2. Expression evaluation (postfix)")
print("  3. Function calls (recursion)")
print("  4. Undo/Redo (two stacks)")
print("  5. Backtracking (DFS, maze solving)")

print("\n✓ Common patterns:")
print("  • Push opening, pop closing (balanced)")
print("  • Operator precedence (infix to postfix)")
print("  • Two stacks (undo/redo)")
print("  • Stack frames (function calls)")

print("\n✓ Interview favorites:")
print("  • Balanced parentheses (Easy)")
print("  • Evaluate expression (Medium)")
print("  • Min Stack (Medium)")
print("  • Largest Rectangle (Hard)")
