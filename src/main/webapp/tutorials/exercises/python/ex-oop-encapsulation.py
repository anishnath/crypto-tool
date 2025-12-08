# Exercise: Secure User Account
# Create a User class with proper encapsulation

class User:
    """
    Create a User class with:
    - Public: username (can be seen by anyone)
    - Protected: _email (internal, subclasses might need it)
    - Private: __password (highly sensitive)
    """

    def __init__(self, username, email, password):
        # 1. Store username as public
        # Your code here:

        # 2. Store email as protected (_email)
        # Your code here:

        # 3. Store password as private (__password)
        # Your code here:
        pass

    # 4. Create a getter for email (get_email)
    # Your code here:


    # 5. Create a method to verify password (verify_password)
    #    Takes a password string, returns True if it matches
    # Your code here:


    # 6. Create a method to change password (change_password)
    #    Takes old_password and new_password
    #    Only changes if old_password is correct
    #    Returns True if changed, False if old password wrong
    # Your code here:


    # 7. Create __str__ that shows username and masked email
    #    Email should show first char + *** + @domain
    #    Example: "User: alice, Email: a***@example.com"
    # Your code here:



# Test your implementation:
# user = User("alice", "alice@example.com", "secret123")

# Test public access
# print(user.username)  # Should work

# Test getter
# print(user.get_email())  # Should work

# Test password verification
# print(user.verify_password("secret123"))  # True
# print(user.verify_password("wrong"))  # False

# Test password change
# print(user.change_password("secret123", "newpass"))  # True
# print(user.change_password("wrong", "newpass"))  # False

# Test string representation
# print(user)  # User: alice, Email: a***@example.com

# These should NOT work (or be discouraged):
# print(user.__password)  # AttributeError
# print(user._email)  # Works but discouraged
