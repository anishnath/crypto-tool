# Custom Exception Classes

print("=== Custom Exceptions ===\n")

# 1. Basic custom exception
print("1. Simple custom exception:")

class ValidationError(Exception):
    """Raised when validation fails."""
    pass

try:
    raise ValidationError("Email format is invalid")
except ValidationError as e:
    print(f"   Caught ValidationError: {e}")
print()

# 2. Custom exception with attributes
print("2. Exception with extra attributes:")

class ConfigError(Exception):
    """Raised when configuration is invalid."""
    def __init__(self, message, key=None, value=None):
        super().__init__(message)
        self.key = key
        self.value = value

try:
    raise ConfigError("Invalid port number", key="port", value=-1)
except ConfigError as e:
    print(f"   Message: {e}")
    print(f"   Key: {e.key}")
    print(f"   Value: {e.value}")
print()

# 3. Exception hierarchy for an application
print("3. Exception hierarchy:")

# Base exception for the app
class AppError(Exception):
    """Base exception for our application."""
    pass

# Specific exceptions inherit from base
class AuthError(AppError):
    """Authentication/authorization errors."""
    pass

class DatabaseError(AppError):
    """Database-related errors."""
    pass

class NotFoundError(DatabaseError):
    """Resource not found in database."""
    def __init__(self, resource_type, resource_id):
        super().__init__(f"{resource_type} with id {resource_id} not found")
        self.resource_type = resource_type
        self.resource_id = resource_id

# Using the hierarchy
def get_user(user_id):
    if user_id < 0:
        raise AuthError("Invalid user ID")
    if user_id == 0:
        raise NotFoundError("User", user_id)
    return {"id": user_id, "name": "Alice"}

test_ids = [-1, 0, 42]
for uid in test_ids:
    try:
        user = get_user(uid)
        print(f"   ID {uid}: Got user {user}")
    except NotFoundError as e:
        print(f"   ID {uid}: {e.resource_type} not found")
    except AuthError as e:
        print(f"   ID {uid}: Auth error: {e}")
    except AppError as e:
        print(f"   ID {uid}: App error: {e}")
print()

# 4. Custom __str__ method
print("4. Custom string representation:")

class APIError(Exception):
    """API call failed."""
    def __init__(self, endpoint, status_code, message):
        self.endpoint = endpoint
        self.status_code = status_code
        self.message = message
        super().__init__(self._format_message())

    def _format_message(self):
        return f"API {self.endpoint} failed ({self.status_code}): {self.message}"

try:
    raise APIError("/users", 404, "User not found")
except APIError as e:
    print(f"   {e}")
    print(f"   Status: {e.status_code}")
print()

# 5. Practical example: Form validation
print("5. Form validation exceptions:")

class FieldError(Exception):
    """Single field validation error."""
    def __init__(self, field, message):
        super().__init__(f"{field}: {message}")
        self.field = field
        self.message = message

class FormError(Exception):
    """Multiple field validation errors."""
    def __init__(self, errors):
        self.errors = errors  # List of FieldError
        messages = [str(e) for e in errors]
        super().__init__("Form validation failed: " + "; ".join(messages))

def validate_signup(data):
    errors = []

    if not data.get('email') or '@' not in data.get('email', ''):
        errors.append(FieldError('email', 'Invalid email format'))

    password = data.get('password', '')
    if len(password) < 8:
        errors.append(FieldError('password', 'Must be at least 8 characters'))

    if not data.get('username'):
        errors.append(FieldError('username', 'Required'))

    if errors:
        raise FormError(errors)

    return True

# Test form validation
forms = [
    {'email': 'bad', 'password': '123', 'username': ''},
    {'email': 'good@email.com', 'password': 'secure123', 'username': 'alice'},
]

for form in forms:
    try:
        validate_signup(form)
        print(f"   Form valid: {form}")
    except FormError as e:
        print(f"   Form invalid:")
        for err in e.errors:
            print(f"     - {err.field}: {err.message}")
